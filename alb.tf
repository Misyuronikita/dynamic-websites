resource "aws_lb" "alb" {
  name               = "alb-misyuro"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [for item in aws_subnet.subnets : item.id]
}

resource "aws_lb_target_group" "target_group" {
  name     = "tg-misyuro"
  protocol = "HTTP"
  port     = 80
  vpc_id   = aws_vpc.vpc.id

  health_check {
    path    = "/"
    matcher = 200
  }
}

resource "aws_lb_target_group_attachment" "attachment" {
  count            = local.subnet_count
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.server[count.index].id
  port             = 80
}

resource "aws_security_group" "alb_sg" {
  name        = "alb_sg_misyuro"
  description = "ASG security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb_sg_misyuro"
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}
