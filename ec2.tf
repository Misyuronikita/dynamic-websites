resource "aws_security_group" "sg" {
  vpc_id      = aws_vpc.vpc.id
  name        = "rules"
  description = "Security Group to allow traffic to EC2"
  ingress {
    to_port     = 22
    from_port   = 22
    protocol    = "tcp"
    cidr_blocks = [local.anywhere_cidr_block]
  }
  ingress {
    to_port     = 80
    from_port   = 80
    protocol    = "tcp"
    cidr_blocks = [local.anywhere_cidr_block]
  }
  ingress {
    to_port     = 443
    from_port   = 443
    protocol    = "tcp"
    cidr_blocks = [local.anywhere_cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.anywhere_cidr_block]
  }
}

resource "aws_instance" "server" {
  count                       = local.subnet_count
  associate_public_ip_address = true
  ami                         = local.instance_ami
  instance_type               = local.instance_type
  subnet_id                   = aws_subnet.subnets[count.index].id
  vpc_security_group_ids      = [aws_security_group.sg.id]
  user_data                   = filebase64("user_data.sh")
  tags = {
    Name = "Server-${count.index}"
  }
}
