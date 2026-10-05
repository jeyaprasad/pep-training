# Terraform EC2 Practical

This is a beginner-friendly project that demonstrates how to create an AWS EC2 instance using Terraform.

## Concepts Explained

1. **What is an EC2 instance?**
   EC2 (Elastic Compute Cloud) is a virtual server in Amazon's cloud. It's like renting a computer located in a data center that you can access over the internet.

2. **What is Terraform?**
   Terraform is a tool that lets you manage your cloud infrastructure (like EC2 instances) by writing code instead of manually clicking around in a web browser.

3. **What is `aws_instance`?**
   In Terraform, `aws_instance` is a block of code (called a "resource") that specifically tells AWS to create and manage an EC2 instance.

4. **What is AMI?**
   AMI stands for Amazon Machine Image. It's a template that contains the software configuration (operating system, application server, and applications) required to launch your instance. AMI IDs are unique to each AWS region!

5. **What is `instance_type`?**
   This determines the hardware of your virtual computer (CPU, memory, storage). `t2.micro` is a small instance type that is often used for learning because it falls under the AWS Free Tier.

6. **What is a security group?**
   A security group acts as a virtual firewall for your EC2 instance to control incoming and outgoing traffic. (We are using the default one in this simple lab).

7. **What is a key pair?**
   A key pair is a set of security credentials that you use to prove your identity when connecting (SSH) to an EC2 instance. (We skipped this in this lab to keep it simple, meaning you won't be able to SSH into it).

8. **What is a public IP?**
   A public IP address is an address that can be reached from the public internet. Your EC2 instance will get one so it can communicate with the outside world.

## Line-by-Line Code Explanation

### `provider.tf`
* **`terraform { required_providers { aws = ... } }`**: Tells Terraform we want to use the AWS plugin to talk to Amazon.
* **`provider "aws" { region = "ap-south-1" }`**: Sets the default AWS region to Mumbai (`ap-south-1`). All resources will be built here.

### `ec2.tf`
* **`data "aws_ami" "amazon_linux_2023" { ... }`**: This is a "data source". Instead of hardcoding a specific AMI ID (which changes frequently), we ask AWS to find the most recent Amazon Linux 2023 image in `ap-south-1` for us.
* **`resource "aws_instance" "my_ec2" { ... }`**: Tells Terraform to create a new EC2 instance and name it `my_ec2` inside our Terraform code.
* **`ami = data.aws_ami.amazon_linux_2023.id`**: Uses the ID we found using the data source above.
* **`instance_type = "t2.micro"`**: Specifies we want a small, free-tier eligible virtual machine.
* **`tags = { Name = "Terraform-EC2" }`**: Attaches a label to the server so it shows up named "Terraform-EC2" in the AWS Console.

### `outputs.tf`
* **`output "instance_public_ip" { value = aws_instance.my_ec2.public_ip }`**: After the server is built, print the Public IP to the terminal so we can see it. We do the same for the ID, DNS, and state.

## Step-by-Step Practical Instructions

**Important before starting:** Verify that your AWS credentials are valid and you are deploying into `ap-south-1`.

Open PowerShell, navigate to this project folder, and run the following commands:

1. **`aws --version`**
   * *Expectation:* Prints the installed AWS CLI version (e.g., `aws-cli/2.x.x`).

2. **`aws sts get-caller-identity`**
   * *Expectation:* Outputs a JSON block proving you are logged in (shows Account, UserId, and ARN).

3. **`terraform --version`**
   * *Expectation:* Prints the installed Terraform version (e.g., `Terraform v1.x.x`).

4. **`terraform init`**
   * *Expectation:* Downloads the AWS provider plugin and says "Terraform has been successfully initialized!"

5. **`terraform fmt`**
   * *Expectation:* Formats your code to be neat. If your code is already neat, it outputs nothing. Otherwise, it prints the names of the files it fixed.

6. **`terraform validate`**
   * *Expectation:* Checks for typos and syntax errors. It should say "Success! The configuration is valid."

7. **`terraform plan`**
   * *Expectation:* Previews what will happen. You should see `+ create` for `aws_instance.my_ec2` and `Plan: 1 to add`. It will also say `(known after apply)` for things like the IP address because they don't exist yet.

8. **`terraform apply`**
   * *Expectation:* It will show the plan again and ask for confirmation.
   * **ACTION:** Type **`yes`** and press Enter.
   * *Expectation:* It will take about 30-60 seconds to create. At the end, it will display the `Outputs` like your instance's Public IP.

9. **`terraform show`**
   * *Expectation:* Prints all the detailed attributes of your newly created EC2 instance directly from the state file.

10. **`terraform state list`**
    * *Expectation:* Lists the resources being managed. You should see `data.aws_ami.amazon_linux_2023` and `aws_instance.my_ec2`.

## Verifying in AWS Console
1. Log into your AWS Management Console.
2. Search for **EC2** in the top search bar and click it.
3. Make sure your region in the top-right corner is set to **Mumbai (ap-south-1)**.
4. Click on **Instances (running)**.
5. You should see your new server named **Terraform-EC2**!

## Cleanup: Delete the Instance
To stop paying for the instance (or to keep your account clean), you must delete it when finished.

Run this command:
**`terraform destroy`**

* It will show you a plan to destroy (`- destroy`) your resources.
* When asked, type **`yes`**.
* This will permanently delete the EC2 instance from AWS.
