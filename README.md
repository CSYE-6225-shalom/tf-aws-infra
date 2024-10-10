
## Setup Instructions

1. **Clone the repository:**
    ```sh
    git clone https://github.com/your-repo/tf-aws-infra.git
    cd tf-aws-infra
    ```

2. **Initialize Terraform:**
    ```sh
    terraform init
    ```

3. **Apply the Terraform configuration:**
    ```sh
    terraform apply -var-file=dev.tfvars
    ```

## Networking Configuration

### VPC

The VPC is defined in [modules/vpc/main.tf](modules/vpc/main.tf). It includes the following resources:

- `aws_vpc.main`: The main VPC resource.

### Subnets

Subnets are defined in [modules/vpc/subnets.tf](modules/vpc/subnets.tf). It includes:

- `aws_subnet.public`: Public subnets.
- `aws_subnet.private`: Private subnets.

### Route Tables

Route tables are defined in [modules/vpc/routes.tf](modules/vpc/routes.tf). It includes:

- `aws_route_table.public`: Public route table with a default route to the internet gateway.
- `aws_route_table.private`: Private route table.
- `aws_route_table_association.public`: Associations for public subnets.
- `aws_route_table_association.private`: Associations for private subnets.

### Internet Gateway

The internet gateway is defined in [modules/vpc/main.tf](modules/vpc/main.tf) and associated with the VPC:

- `aws_internet_gateway.main`: The main internet gateway resource.

## CI/CD Pipeline

The CI/CD pipeline is defined in [terraform-pr.yml](.github/workflows/terraform-pr.yml). It includes the following steps:

1. **Checkout Code**
2. **Setup Terraform**
3. **Initialize Terraform**
4. **Terraform Format Check**
5. **Install TFLint**
6. **Run TFLint**
7. **Terraform Validate**
8. **Checkov Security Scan**
9. **Clean up sensitive data**

