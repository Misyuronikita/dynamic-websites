locals {
  vpc_cidr_block      = "10.0.0.0/16"
  subnet_count        = 2
  anywhere_cidr_block = "0.0.0.0/0"
  instance_type       = "t2.micro"
  instance_ami        = "ami-008677ef1baf82eaf"
}
