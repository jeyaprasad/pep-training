resource "aws_iam_user" "devops" {
  name = "devops"
  path = "/"

  tags = {
    purpose = "hands-on"
  }
}