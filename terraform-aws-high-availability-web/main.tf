terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "ec2_1" {
  ami                         = var.ami_id
  instance_type               = var.web_instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data = templatefile("user_data.tmpl", {
  })

  tags = {
    Name = "webserver1"
  }
}

resource "aws_instance" "ec2_2" {
  ami                         = var.ami_id
  instance_type               = var.web_instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  subnet_id                   = module.vpc.public_subnets[1]
  associate_public_ip_address = true
  user_data = templatefile("user_data.tmpl", {

  })

  tags = {
    Name = "webserver2"
  }
}

########################
# ALB + Target Group + Listener
########################
resource "aws_lb" "this" {
  name               = "mes-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_target_group" "tg" {
  name     = "mes-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_target_group_attachment" "attach_ec2_1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.ec2_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach_ec2_2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.ec2_2.id
  port             = 80
}
