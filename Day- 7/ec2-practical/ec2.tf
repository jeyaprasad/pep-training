resource "aws_instance" "testec2" {
  # IMPORTANT: AMI IDs are region-specific!
  # You must find a valid Amazon Linux AMI ID for ap-south-1 in the AWS Console.
  # Check the README.md for exact instructions on how to find it.
  ami           = "ami-08e3b3155fc937a94"
  
  instance_type = "t3.micro"

  tags = {
    Name = "sjce-devops"
  }
}
