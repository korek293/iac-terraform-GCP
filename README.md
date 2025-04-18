# Infrastructure – Terraform GCP

This solution demonstrates the practical use of Terraform to provision a complete cloud infrastructure environment, encompassing compute, networking, security, and IAM components. It is designed to reflect real-world production scenarios where infrastructure must not only be robust and scalable, but also capable of supporting developer workflows—such as capturing debug information and sending it to object storage on instance startup.

Solution Overview
The infrastructure is provisioned using two separate Terraform configurations (states) to ensure modularity, scalability, and better state management:

1. Base Configuration
This layer sets up foundational resources required by other parts of the infrastructure. It typically includes:
  Virtual Network and subnets
  IAM roles and policies
  Object storage
  Security groups and firewall rules
These resources are shared across environments and provide the necessary groundwork for compute operations.

2. Compute Configuration
This layer handles the dynamic and scalable part of the infrastructure:
  An Auto Scaling Group that manages multiple compute instances
  A Load Balancer that distributes incoming traffic to the instances

User data scripts that configure each compute instance to report system data or logs to the object storage created in the base configuration

This setup mimics a real-world deployment where services must scale automatically and report health or debug data to centralized storage.

Post-Configuration Optimization:
Once the initial setup is complete, further enhancements are applied to improve maintainability and scalability:
  Data-driven configuration: Variables and data sources are used to make configurations reusable and adaptable to different environments.
  Modular architecture: Common infrastructure components are refactored into reusable Terraform modules to follow DRY (Don't Repeat Yourself) principles and support multi-environment deployments.
  
![image](https://github.com/user-attachments/assets/6d005503-61a7-4d20-bb30-14fc9a12956d)
