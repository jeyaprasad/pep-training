# VPC Practical Using Terraform

## AIM

To create an AWS VPC and configure basic networking components using Terraform.

## OBJECTIVE

To create a simple VPC in AWS with one public subnet, an Internet Gateway, a public route table, and a route table association using Terraform.

This practical does **not** create an EC2 instance, IAM user, database, load balancer, or any other extra resource.

## REQUIREMENTS

- An AWS account
- AWS CLI installed
- Terraform installed
- AWS CLI credentials already configured
- Permission to create and delete VPC networking resources
- A PowerShell terminal

The AWS region used in this practical is `ap-south-1` (Asia Pacific - Mumbai).

## THEORY

### 1. What is AWS?

AWS (Amazon Web Services) is a cloud platform. It provides services such as virtual machines, storage, databases, and networking over the internet.

### 2. What is a VPC?

A VPC (Virtual Private Cloud) is a private network created inside AWS. We choose its IP address range and place AWS resources inside it.

### 3. What is CIDR?

CIDR (Classless Inter-Domain Routing) is a way to write an IP address range. For example, `10.0.0.0/16` describes a large private network range. The number after `/` tells how many bits identify the network. A smaller number generally represents a larger range.

### 4. What is a subnet?

A subnet is a smaller network inside a VPC. AWS resources such as EC2 instances are placed in subnets.

### 5. What is a public subnet?

A public subnet is a subnet whose route table has a route to an Internet Gateway. In this practical, resources in the subnet can be configured for internet access. No EC2 instance is created here.

### 6. What is an Internet Gateway?

An Internet Gateway (IGW) connects a VPC to the internet. A route table must point internet traffic to the IGW.

### 7. What is a Route Table?

A route table is a collection of traffic rules. Each rule says where traffic for a destination should go. This practical sends `0.0.0.0/0` traffic to the Internet Gateway.

### 8. What is a Route Table Association?

A route table association connects a subnet to a route table. It tells AWS which traffic rules the subnet should use.

### 9. What is an Availability Zone?

An Availability Zone (AZ) is an isolated location inside an AWS region. `ap-south-1a` is one Availability Zone in the Mumbai region.

### 10. What is Terraform?

Terraform is an Infrastructure as Code tool. We describe the desired infrastructure in configuration files, and Terraform creates or changes it.

### 11. What is an AWS provider?

A provider is a Terraform plugin that knows how to communicate with a service. The HashiCorp AWS provider lets Terraform manage AWS resources.

### 12. What is a Terraform resource?

A resource is one infrastructure object managed by Terraform. For example, `aws_vpc.main` represents one AWS VPC.

## EXPLAIN THE NETWORK

The architecture is:

```text
Internet
   |
Internet Gateway
   |
Route Table
   |
Public Subnet
   |
VPC
```

Traffic from the public subnet that is intended for the internet matches the route `0.0.0.0/0`. The route table sends that traffic to the Internet Gateway. The Internet Gateway provides the connection between the VPC and the internet. The route table is associated with the public subnet, so the subnet uses this rule.

### CIDR ranges

- **VPC CIDR:** `10.0.0.0/16`
- **Subnet CIDR:** `10.0.1.0/24`

The VPC range is the larger address space. The subnet range is a smaller part of that address space. Therefore, `10.0.1.0/24` is inside `10.0.0.0/16`, and AWS accepts the subnet inside this VPC. The `/24` subnet provides 256 total addresses (some are reserved by AWS).

## EXPLAIN THE TERRAFORM CODE

The complete code is in [provider.tf](./provider.tf), [vpc.tf](./vpc.tf), and [outputs.tf](./outputs.tf). Terraform automatically reads all `.tf` files in this folder.

### `provider.tf`

- `terraform {}` declares Terraform settings.
- `required_providers` says that this project needs a provider.
- `source = "hashicorp/aws"` selects the official HashiCorp AWS provider.
- `version = "~> 6.0"` selects a compatible current major version in the 6.x series.
- `provider "aws"` configures the AWS provider.
- `region = "ap-south-1"` selects the Mumbai AWS region.
- No access key or secret key is written in the file. The provider uses credentials supplied by the AWS CLI configuration.

### `resource "aws_vpc" "main"`

- `resource` tells Terraform to manage an infrastructure object.
- `aws_vpc` is the official AWS provider resource type for a VPC.
- `main` is this resource's local Terraform name. Its full Terraform address is `aws_vpc.main`.
- `cidr_block = "10.0.0.0/16"` gives the VPC its IP range.
- `enable_dns_support = true` enables DNS resolution in the VPC.
- `enable_dns_hostnames = true` enables DNS hostnames for supported resources.
- The `tags` block gives the VPC the console name `sjce-vpc`.

### `resource "aws_subnet" "public"`

- `aws_subnet` is the AWS provider resource type for a subnet.
- `public` is its local Terraform name, so its address is `aws_subnet.public`.
- `vpc_id = aws_vpc.main.id` places this subnet in the VPC. Terraform gets the VPC ID after creating the VPC.
- `cidr_block = "10.0.1.0/24"` gives the subnet its smaller IP range.
- `availability_zone = "ap-south-1a"` places it in the requested Availability Zone.
- `map_public_ip_on_launch = true` makes public IPv4 assignment the default for resources that may be launched in this subnet.
- Its tag displays `sjce-public-subnet` in the AWS Console.

### `resource "aws_internet_gateway" "igw"`

- `aws_internet_gateway` is the AWS provider resource type for an Internet Gateway.
- `igw` is its local name, so its address is `aws_internet_gateway.igw`.
- `vpc_id = aws_vpc.main.id` attaches the gateway to this VPC.
- Its tag displays `sjce-igw`.

### `resource "aws_route_table" "public"`

- `aws_route_table` is the AWS provider resource type for a route table.
- `public` is its local name, so its address is `aws_route_table.public`.
- `vpc_id = aws_vpc.main.id` creates the route table in this VPC.
- The `route` block creates one rule.
- `cidr_block = "0.0.0.0/0"` means all IPv4 destinations not covered by a more specific route.
- `gateway_id = aws_internet_gateway.igw.id` sends that traffic to this Internet Gateway.
- Its tag displays `sjce-public-rt`.

### `resource "aws_route_table_association" "public"`

- `aws_route_table_association` is the AWS provider resource type that connects a subnet to a route table.
- `public` is its local name, so its address is `aws_route_table_association.public`.
- `subnet_id = aws_subnet.public.id` selects the public subnet.
- `route_table_id = aws_route_table.public.id` selects the public route table.

### How Terraform knows the dependencies

Terraform creates a dependency graph from references. For example, `aws_subnet.public` references `aws_vpc.main.id`, so the VPC must exist first. The route table references both the VPC and the Internet Gateway. The association references the subnet and route table. Terraform therefore creates the resources in a safe order and removes them in the reverse order. No manual ordering is needed.

## TERRAFORM COMMANDS

Open PowerShell and move into this project folder:

```powershell
cd "D:\Career\PEP\Pep- 2\Day- 7\vpc-practical"
```

Run these commands in this exact order:

```powershell
aws --version
aws sts get-caller-identity
terraform --version
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform show
terraform state list
```

When `terraform apply` asks:

```text
Do you want to perform these actions?
```

Type:

```text
yes
```

Terraform should report a result similar to:

```text
Apply complete! Resources: 5 added, 0 changed, 0 destroyed.
```

The exact IDs and timing will be different. The five resources are the VPC, subnet, Internet Gateway, route table, and route table association. Terraform also prints the output values from `outputs.tf`.

## AWS CONSOLE VERIFICATION

Use the AWS region selector to select **Asia Pacific (Mumbai) / `ap-south-1`**.

1. Open **AWS Console**.
2. Open the **VPC** service.
3. Choose **Your VPCs**.
4. Find **`sjce-vpc`**.
5. Check that its VPC ID is the same as the `vpc_id` Terraform output.
6. Check that its IPv4 CIDR is **`10.0.0.0/16`**.
7. Select the VPC and check the **DNS resolution** setting is enabled (DNS support).
8. Check the **DNS hostnames** setting is enabled.

Then:

1. Choose **VPC → Subnets**.
2. Find **`sjce-public-subnet`**.
3. Check that its VPC is `sjce-vpc`, its CIDR is **`10.0.1.0/24`**, and its Availability Zone is **`ap-south-1a`**.

Then:

1. Choose **VPC → Internet Gateways**.
2. Find **`sjce-igw`**.
3. Check that it is attached to `sjce-vpc`.

Then:

1. Choose **VPC → Route Tables**.
2. Find **`sjce-public-rt`**.
3. Open the **Routes** tab.
4. Verify **Destination** is `0.0.0.0/0`.
5. Verify **Target** is the Internet Gateway, showing the ID of `sjce-igw`.
6. Open the **Subnet associations** tab.
7. Verify that `sjce-public-subnet` is associated with this route table.

## TERRAFORM STATE

### `terraform show`

Displays the resources and attributes currently recorded in Terraform state in a readable format.

### `terraform state list`

Lists the Terraform addresses currently managed by this project. You should see:

```text
aws_internet_gateway.igw
aws_route_table.public
aws_route_table_association.public
aws_subnet.public
aws_vpc.main
```

### `terraform state show aws_vpc.main`

Displays the recorded attributes of only the VPC resource, including its ID, CIDR block, and settings.

### `terraform.tfstate`

`terraform.tfstate` is Terraform's state file. It records the relationship between the Terraform configuration and the real AWS resource IDs and attributes. Terraform uses it to know what already exists and what needs to change. Do **not** manually edit `terraform.tfstate`; use Terraform commands such as `plan`, `apply`, and `destroy`.

## CLEANUP

After the practical, safely remove the resources created by this project:

```powershell
terraform destroy
```

When Terraform asks for confirmation, type:

```text
yes
```

Terraform will remove the five resources it created. The dependency order ensures that the association, route table, gateway, subnet, and VPC can be removed safely. Confirm in the AWS Console that `sjce-vpc` and its networking components are gone.

## EXPECTED OUTPUT

Important successful messages include:

```text
Terraform has been successfully initialized!
```

```text
Success! The configuration is valid.
```

```text
Apply complete! Resources: 5 added, 0 changed, 0 destroyed.
```

After cleanup, the destroy result should be similar to:

```text
Destroy complete! Resources: 5 destroyed.
```

## COMMON ERRORS AND FIXES

### `terraform` or `aws` is not recognized

Install Terraform or the AWS CLI, then close and reopen PowerShell so the updated PATH is available.

### AWS credentials or `InvalidClientTokenId`

Configure the AWS CLI credentials, for example with `aws configure`, and run `aws sts get-caller-identity` again. Never put access keys in `.tf` files.

### `UnauthorizedOperation` or `AccessDenied`

The AWS identity does not have permission to create VPC networking resources. Ask the account administrator or lecturer for the required lab permissions.

### Wrong region or resource not visible

Select `ap-south-1` in the AWS Console. Terraform creates these resources in the region configured in `provider.tf`.

### `InvalidSubnet.Range`

The subnet CIDR must be inside the VPC CIDR and must not overlap another subnet. This practical uses the valid nested range `10.0.1.0/24` inside `10.0.0.0/16`.

### Availability Zone is unavailable

Availability Zones can differ by account. First try the requested `ap-south-1a`; if AWS specifically reports it is unavailable for the account, ask your lecturer before changing the practical's required Availability Zone.

### `terraform apply` asks for confirmation

This is normal. Review the plan and type `yes` only when you want Terraform to create the five listed resources.
