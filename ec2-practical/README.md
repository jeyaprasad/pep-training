# DevOps Lab Practical: AWS EC2 using Terraform

**AIM:** To create an AWS EC2 instance using Terraform.

**OBJECTIVE:** To learn how to provision cloud infrastructure (AWS EC2) manually through the AWS Web Console and automatically using Terraform code.

**REQUIREMENTS:**
*   AWS account
*   AWS CLI installed and configured
*   Terraform installed
*   VS Code (or any code editor)

---

## PART 1 — AWS WEB CONSOLE

Creating an EC2 instance manually helps us understand what Terraform is doing behind the scenes.

**Steps to create an EC2 instance manually:**
1. Log in to the **AWS Management Console**.
2. Make sure your region (top-right corner) is set to **Mumbai (ap-south-1)**.
3. Search for **EC2** and open the EC2 Dashboard.
4. Click on **Instances** on the left menu.
5. Click the orange **Launch instances** button.

**Explain these fields:**
1.  **Name:** The label you give your server (e.g., `sjce-devops`).
2.  **Application and OS Images / AMI:** Where you select the Operating System (like Amazon Linux).
3.  **Instance type:** The hardware capacity (CPU and RAM).
4.  **Key pair:** Used for securely logging into the server via SSH.
5.  **Network settings:** Configures which VPC and Subnet the server lives in.
6.  **Security group:** The firewall rules allowing or blocking internet traffic.
7.  **Storage:** The size of the hard drive (EBS volume) attached to the server.
8.  **Advanced details:** Extra configurations like startup scripts (User Data).
9.  **Launch instance:** The final button to create the server.

### Finding a Valid AMI ID
*AMI IDs are region-specific! An AMI ID in Mumbai will not work in N. Virginia.*
1. In the "Launch an instance" screen, under **Application and OS Images (Amazon Machine Image)**, select **Amazon Linux**.
2. Look just below the selected OS. You will see an AMI ID that looks like `ami-0a2a11883344605eb` (it changes frequently).
3. Copy this exact AMI ID to use in your Terraform code.

---

## THEORY

*   **Terraform:** An Infrastructure as Code (IaC) tool that lets you build, change, and version cloud resources safely and efficiently using configuration files.
*   **AWS:** Amazon Web Services, a comprehensive cloud computing platform provided by Amazon.
*   **EC2:** Elastic Compute Cloud, a web service that provides virtual servers in AWS.
*   **AMI:** Amazon Machine Image, a template containing the software (OS, apps) needed to launch your virtual server.
*   **Instance type:** Defines the CPU, memory, storage, and networking capacity of the EC2 instance.
*   **t3.micro:** A specific, low-cost general-purpose instance type that is often eligible for the AWS Free Tier.
*   **VPC:** Virtual Private Cloud, a logically isolated section of the AWS cloud where your resources run.
*   **Subnet:** A smaller section inside a VPC that can span a specific physical Availability Zone.
*   **Security Group:** A virtual firewall that controls incoming and outgoing traffic to your EC2 instance.
*   **Key Pair:** A set of cryptographic keys (public and private) used to prove your identity when logging into the EC2 instance.
*   **Public IP:** An internet-accessible IP address assigned to your instance so it can communicate with the outside world.
*   **Terraform provider:** A plugin that allows Terraform to interact with cloud providers like AWS.
*   **Terraform resource:** A block of code describing a single infrastructure object, like an EC2 instance or an IAM user.
*   **Terraform state:** A file (`terraform.tfstate`) where Terraform maps your real-world resources to your configuration files.

### Explaining the Terraform Block Line by Line

```hcl
resource "aws_instance" "testec2" {
  ami           = "ami-1234567890abcdef0"
  instance_type = "t3.micro"

  tags = {
    Name = "sjce-devops"
  }
}
```
*   `resource "aws_instance" "testec2" {`: Declares that we want to create an AWS EC2 instance resource and names it `testec2` internally in Terraform.
*   `ami = "..."`: Tells AWS which Operating System template to use for the server.
*   `instance_type = "t3.micro"`: Tells AWS to use the small `t3.micro` hardware size.
*   `tags = { Name = "sjce-devops" }`: Attaches a label to the server so it appears as `sjce-devops` in the AWS console.
*   `}`: Closes the resource block.

*(Note: We do not declare a VPC, Subnet, or Security Group in this simple block because AWS automatically launches the instance into your account's default VPC and default Security Group).*

---

## IMPORTANT PRACTICAL CONCEPT

**How Terraform talks to AWS:**
```
Terraform code
      ↓
Terraform AWS Provider
      ↓
AWS API
      ↓
AWS EC2
      ↓
EC2 Instance
```

**What do the commands actually do?**
*   **`terraform plan` =** "What will Terraform change?"
*   **`terraform apply` =** "Actually make the changes."
*   **`terraform destroy` =** "Remove resources created by Terraform."

---

## PART 2 — TERRAFORM COMMANDS

Open PowerShell in your `ec2-practical` directory and run these commands in order:

1.  **`aws --version`**
    Checks if the AWS CLI tool is installed.
2.  **`aws sts get-caller-identity`**
    Verifies that your AWS credentials are correct and shows your Account ID.
3.  **`terraform --version`**
    Checks if Terraform is installed.
4.  **`terraform init`**
    Initializes the project directory by downloading the AWS provider plugin.
5.  **`terraform fmt`**
    Automatically formats your Terraform code to be neat and readable.
6.  **`terraform validate`**
    Checks your code for syntax errors.
7.  **`terraform plan`**
    Shows a preview of the resources Terraform will create.
8.  **`terraform apply`**
    Executes the code to create the EC2 instance in AWS.
    *(When it asks `Do you want to perform these actions?`, you must type: **`yes`**)*
    *(Expected result: `Apply complete! Resources: 1 added, 0 changed, 0 destroyed.`)*
9.  **`terraform show`**
    Displays the current state of your built infrastructure.
10. **`terraform state list`**
    Lists all the resources Terraform is currently managing (e.g., `aws_instance.testec2`).

---

## VERIFY THE EC2

1. Go back to the **AWS Console**.
2. Navigate to **EC2** → **Instances**.
3. You should see a new instance. Check these details:
   *   **Name:** Should be `sjce-devops`.
   *   **Instance ID:** Matches the output from Terraform.
   *   **Instance state:** Should say `Running`.
   *   **Instance type:** Should be `t3.micro`.
   *   **Public IPv4 address:** Matches the output from Terraform.
   *   **Private IPv4 address:** An internal AWS IP address.
   *   **Availability Zone:** E.g., `ap-south-1a`.
   *   **AMI:** Matches the AMI ID you provided.

---

## TERRAFORM STATE

*   **`terraform show`**: Reads the state file and outputs a human-readable version of everything you have built.
*   **`terraform state list`**: Outputs a simple list of the resource names Terraform is managing.
*   **`terraform state show aws_instance.testec2`**: Shows the detailed attributes of just this specific EC2 instance.

**What is `terraform.tfstate`?**
It is a JSON file that Terraform creates locally to keep track of the real-world infrastructure it has built. It maps the code you wrote to the actual IDs in AWS. *(Do not manually edit this file!)*

---

## DELETE / CLEANUP

It is very important not to leave unnecessary AWS resources running because AWS may charge you money for them over time.

To delete the EC2 instance, run:
**`terraform destroy`**

When it prompts you, type:
**`yes`**

This safely and permanently removes the EC2 resource managed by Terraform from your AWS account.
