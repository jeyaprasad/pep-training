# Terraform IAM User Practical

This is a simple beginner-friendly Terraform project to demonstrate how to create an AWS IAM User using Terraform.

## Concepts Explained

**What is Terraform?**
Terraform is an Infrastructure as Code (IaC) tool by HashiCorp. It allows you to define your cloud resources (like virtual machines, network configurations, or users) in configuration files instead of clicking through a web console.

**What is AWS IAM?**
AWS IAM (Identity and Access Management) is a web service that helps you securely control access to AWS resources. It lets you manage who can be authenticated (signed in) and authorized (have permissions) to use your AWS resources.

**What is an IAM user?**
An IAM user is an entity that you create in AWS to represent the person or application that uses it to interact with AWS. An IAM user consists of a name and credentials.

**What is `aws_iam_user`?**
In Terraform, `aws_iam_user` is a specific resource type provided by the AWS Terraform provider used to manage an IAM user in your AWS account.

**Resource Block Breakdown:**
* **resource**: This keyword tells Terraform you want to create an infrastructure object.
* **name**: The name of the IAM user (e.g., `sjcedemo`). This is how the user will be identified in AWS.
* **path**: The path in which to create the user. The default `/` means no specific path or organizational structure.
* **tags**: Tags are key-value pairs you can attach to AWS resources to help organize, identify, or track them (e.g., `purpose = "hands-on"`).

## Terraform Commands Explained

* **`terraform init`**: Initializes your Terraform working directory. It downloads the required provider plugins (like the AWS provider) so Terraform can interact with cloud APIs.
* **`terraform validate`**: Checks your configuration files for syntax errors or invalid arguments without connecting to the cloud provider.
* **`terraform plan`**: Shows you what Terraform will do before it actually does it. It's like a preview or a dry run of your changes.
* **`terraform apply`**: Executes the actions proposed in the `terraform plan` to create, update, or delete your infrastructure. You will be prompted to confirm these actions by typing `yes`.
* **`terraform show`**: Provides readable output from a state or plan file. It shows the current state of your resources as Terraform knows them.
* **`terraform state list`**: Lists all the resources that Terraform is currently tracking in its state file.
* **`terraform destroy`**: Destroys all the infrastructure managed by your current Terraform project. Use with caution!

## Practical Steps

Open your PowerShell terminal, navigate to this project folder, and run the following commands sequentially:

1. Check your AWS CLI version to ensure it is installed:
   ```powershell
   aws --version
   ```

2. Verify your AWS credentials are configured properly (this should show your AWS Account ID):
   ```powershell
   aws sts get-caller-identity
   ```

3. Check your Terraform version to ensure it is installed:
   ```powershell
   terraform --version
   ```

4. Initialize the Terraform project (downloads the AWS provider):
   ```powershell
   terraform init
   ```

5. Validate the syntax of your configuration files:
   ```powershell
   terraform validate
   ```

6. Preview the changes Terraform will make (you will see it plans to add 1 resource):
   ```powershell
   terraform plan
   ```

7. Apply the changes to create the IAM user in AWS:
   ```powershell
   terraform apply
   ```
   *Note: When prompted to confirm, type `yes` and press Enter.*

8. Inspect the current state of your created resources:
   ```powershell
   terraform show
   ```

9. List the resources currently tracked by Terraform:
   ```powershell
   terraform state list
   ```
