# Data source to automatically find the latest Amazon Linux 2023 AMI in the current region
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# The EC2 instance resource
resource "aws_instance" "my_ec2" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t2.micro"

  tags = {
    Name = "Terraform-EC2"
  }
}
