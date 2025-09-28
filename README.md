# Terraform Assignment

## Architecture Overview

This project uses Terraform to provision resources on AWS in a modular and maintainable way. The architecture includes:

**API Gateway:** Exposes APIs so users or dashboards can query cost and usage data.
**Amazon SNS:** Sends alerts/notifications for example when costs exceed a threshold.
**Amazon Cloudfront:** Distributes the dashboard content globally with low latency.
**DynamoDB:** Stores cost and usage logs in a scalable, queryable format.
**S3:** Hosts the static dashboard website and stores log data.
**Lambda:** Runs serverless functions to process cost data, trigger alerts, or update DynamoDB.
- **IAM Roles & Policies:** Used to grant necessary permissions for EC2 instances and other resources to interact securely.
- **CloudWatch:** Enables monitoring of resource usage and cost.

Each resource is defined in its own Terraform module, allowing for reuse and easy management. 

## Steps Taken

1. **Planning:** I started by mapping out the AWS resources needed and how they would communicate.
2. **Module Creation:** Broke down infrastructure into logical modules. Defined variables for flexibility.
3. **Writing Terraform Code:** Developed each module, referencing official documentation and examples. Used Terraform best practices.
4. **Iterative Testing:** Applied changes incrementally, using `terraform plan` and `terraform apply` to validate configurations and catch errors early.
5. **Resource Connections:** Ensured all resources were connected
6. **Monitoring & Outputs:** Configured CloudWatch for monitoring and outputs for resource IDs and endpoints.

## Challenges Faced and Solutions

- **Resource Dependency Issues:** Sometimes resources were dependent on each other. Solved this by using explicit `depends_on` statements and carefully structuring modules.
- **Security Group Configuration:** Initial rules were too restrictive or too open. Resolved by iterative testing and referencing AWS documentation to define precise ingress/egress policies.
- **State File Management:** Managing state files was tricky, especially when working across machines.
- **Cost Monitoring:** Identifying expensive resources and tracking usage was challenging. Integrated CloudWatch and used AWS Cost Explorer to monitor and optimize.
- **Integrating SNS and CloudWatch alarms:** Integrating SNS so that it can bring notification was an issue that I found it hard to solve an I realizes I need further looking into so that I can grasp those concepts.
- **Writing code:** Writing a fully functional code was also hectic making me to debug and relook into the code every time and get help from other sources on how to debug.

## Key Lessons Learned

- **Terraform:**
  - Modularity is key for maintainable infrastructure.
  - Remote state management is essential for team collaboration and state integrity.
  - Using variables and outputs makes code reusable and clear.

- **AWS:**
  - Security best practices (private subnets, least privilege IAM roles) are crucial for safe deployments.
  - Resource interconnections (VPC, subnets, security groups) must be planned carefully to avoid accessibility issues.
  - Monitoring and logging (CloudWatch) are invaluable for diagnosing issues and tracking costs.

- **Cost Monitoring:**
  - Regularly review AWS billing and use tags to identify high-cost resources.
  - Automated monitoring helps catch unexpected cost spikes early.
  - Optimizing resource types and usage (e.g., reserved instances, proper sizing) can significantly reduce costs.

**LinkedIn Post:**
www.linkedin.com/in/lewis-okenye-04611234b

This project somehow strengthened my understanding of Terraform's infrastructure-as-code principles, AWS resource management, and the importance of monitoring and cost control in cloud environments but I am not yet there and  I will continue to practice to grasp fully the concepts on terraform.
