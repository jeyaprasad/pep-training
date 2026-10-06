variable "ubuntu-ami" {
  type    = string
  default = "ami-0fa52f1a01deb1658" # Valid Ubuntu AMI for Mumbai (ap-south-1)
}

variable "free-tier-instance" {
  type    = string
  default = "t3.micro"
}