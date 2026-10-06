provider "aws" {
  region = "ap-south-1"
}
resource "aws_iam_user" "user1" {
  name = "demo-user"
  path = "/"

  tags = {
    purpose = "hands-on"
  }
}