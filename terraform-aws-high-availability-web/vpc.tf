module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0"

  name = "mesVPC"
  cidr = "10.10.0.0/16"

  azs            = ["us-east-1a", "us-east-1b"]
  public_subnets = ["10.10.1.0/24", "10.10.2.0/24"]

  map_public_ip_on_launch = true
  enable_nat_gateway      = false
  enable_dns_hostnames    = true
  enable_dns_support      = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


# ALB SG: allow HTTP from the internet
resource "aws_security_group" "alb_sg" {
  name   = "mes-alb-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 SG: allow HTTP only from ALB
resource "aws_security_group" "ec2_sg" {
  name   = "mes-ec2-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}