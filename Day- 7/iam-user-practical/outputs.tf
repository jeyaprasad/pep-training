output "iam_user_name" {
  description = "The name of the created IAM user"
  value       = aws_iam_user.demouser1.name
}
