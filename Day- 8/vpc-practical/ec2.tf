resource "aws_instance" "demo2" {
  ami           = var.ubuntu-ami
  instance_type = var.free-tier-instance
  subnet_id     = aws_subnet.public.id
  
  tags = {
    Name = "demodemo"
    team = "sjce-devops"
  }
}