import boto3
import json
import os
from datetime import datetime, timedelta

def lambda_handler(event, context):
    # Initialize clients
    ce = boto3.client('ce')
    dynamodb = boto3.resource('dynamodb')
    sns = boto3.client('sns')

    table_name = os.environ['DYNAMODB_TABLE']
    sns_topic_arn = os.environ['SNS_TOPIC_ARN']
    table = dynamodb.Table(table_name)
    
    # Calculate date range (previous day)
    end_date = datetime.now().date()
    start_date = end_date - timedelta(days=1)
    
    try:
        # Get cost and usage data
        response = ce.get_cost_and_usage(
            TimePeriod={
                'Start': start_date.strftime('%Y-%m-%d'),
                'End': end_date.strftime('%Y-%m-%d')
            },
            Granularity='DAILY',
            Metrics=['UnblendedCost'],
            GroupBy=[
                {
                    'Type': 'DIMENSION',
                    'Key': 'SERVICE'
                }
            ]
        )
        
        # Process and store results
        for result in response['ResultsByTime']:
            date = result['TimePeriod']['Start']
            
            for group in result['Groups']:
                service = group['Keys'][0]
                cost = float(group['Metrics']['UnblendedCost']['Amount'])
                
                # Store in DynamoDB
                if cost > 0:  # Only store non-zero costs
                    item = {
                        'date': date,
                        'service': service,
                        'cost': str(cost),
                        'timestamp': datetime.now().isoformat(),
                        'expiry_time': int((datetime.now() + timedelta(days=365)).timestamp())  # TTL 1 year
                    }
                    message = event.get("Records", [{}])[0].get("Sns", {}).get("Message", "Test alert")
                    table.put_item(Item=item)

                      # Publish to SNS
                    sns.publish(
                        TopicArn=sns_topic_arn,
                        Message=f"Cost Alert: {service} cost on {date} is ${cost}\nDetails: {message}",
                        Subject="AWS Cost Logger Alert"
                    )
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Cost data logged successfully',
                'date': start_date.strftime('%Y-%m-%d')
            })
        }
        
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': str(e)
            })
        }