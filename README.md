# Megazone Cloud-Engineering Technical Assignment

This Terraform project implements a production-grade network architecture in AWS to host a standard three-tier web application.

## Infrastructure

The infrastructure spans 2 availability zones: us-east-1a and us-east-1b

### Subnets
1.  **Public Subnet**: Hosts the Application Load Balancer (ALB), NAT Gateway, Internet Gateway, and Bastion Host.
2.  **Private (Application-Tier) Subnet**: Hosts the application servers.
3.  **Private Database Subnet**: Hosts databases

### Architecture Diagram
<img width="1224" height="671" alt="image" src="https://github.com/user-attachments/assets/38dc7192-2031-493c-a6fc-4d66a8730293" />

### Security Groups
*   **ALB SG**:
    *   Ingress: Allows HTTPS (443) from anywhere.
    *   Egress: Allows all outbound traffic.
*   **Bastion SG**:
    *   Ingress: Allows SSH (22) only from trusted IPs.
    *   Egress: Allows all outbound traffic.
*   **Application SG**:
    *   Ingress: Allows HTTP (80) from the ALB Security Group.
    *   Ingress: Allows SSH (22) from the Bastion Security Group.
    *   Egress: Allows MySQL (3306) to Database Subnet CIDRs.
    *   Egress: Allows HTTPS (443) to the internet (via NAT) for updates.
*   **Database SG**:
    *   Ingress: Allows MySQL (3306) from the App Security Group.

### Network ACLs
*   **Public NACL**: Allows inbound HTTP/HTTPS/SSH from the internet.
*   **Private NACL**:
    *   Ingress: Allows HTTP from the ALB and SSH from the Bastion EC2.
    *   Egress: Allows MySQL to Database Subnets and HTTPS to Internet (via NAT).
*   **Database NACL**:
    *   Ingress: Allows MySQL from Private Subnet CIDRs.
    *   Egress: Allows ephemeral responses to Private Subnet CIDRs.

## Deployment
1. **Set Local Variables**
   *   Set ssh_allows_ips in variables.tf
   *   Generate EC2 key pair to connect to Bastion instance

2.  **Initialize Terraform**:
    ```bash
    cd Cloud-Engineering
    terraform init
    ```

3.  **Plan**:
    ```bash
    terraform plan
    ```

4.  **Apply**:
    ```bash
    terraform apply
    ```

4.  **Test Bastion**:
    ```bash
    ssh -i megazone-bastion-key.pem ec2-user@your-ip-here
    ```

## Outputs
* `alb_dns_name`: The public URL of the Application Load Balancer.
* `bastion_public_ip`: The public IP to SSH into the bastion host.

