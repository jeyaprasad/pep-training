resource "aws_instance" "testec2" {
  ami           = var.ami-ubuntu
  subnet_id     = aws_subnet.public.id
  instance_type = var.free-tier-instance
 
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  associate_public_ip_address = "true"


  tags = {
    Name = "my-ec2"
    team = "demo-sjce"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "Learn-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "Learn-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow-ssh" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow-http" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

output "testec2_public_ip" {
  value = aws_instance.testec2.public_ip
}