import json
import boto3
import os
from datetime import datetime, timedelta

def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    table_name = os.environ['DYNAMODB_TABLE']
    table = dynamodb.Table(table_name)
    
    try:
        # Query parameters
        query_params = event.get('queryStringParameters', {}) or {}
        days = int(query_params.get('days', 7))
        
        # Calculate date range
        end_date = datetime.now().date()
        start_date = end_date - timedelta(days=days)
        
        # Query DynamoDB
        response = table.scan(
            FilterExpression=boto3.dynamodb.conditions.Key('date').between(
                start_date.strftime('%Y-%m-%d'),
                end_date.strftime('%Y-%m-%d')
            )
        )
        
        # Process data
        costs_by_date = {}
        for item in response['Items']:
            date = item['date']
            if date not in costs_by_date:
                costs_by_date[date] = []
            
            costs_by_date[date].append({
                'service': item['service'],
                'cost': float(item['cost']),
                'timestamp': item['timestamp']
            })
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'costs': costs_by_date,
                'period': {
                    'start': start_date.strftime('%Y-%m-%d'),
                    'end': end_date.strftime('%Y-%m-%d')
                }
            })
        }
        
    except Exception as e:
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'error': str(e)
            })
        }