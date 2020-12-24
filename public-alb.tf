resource "aws_lb" "public" {
  name                        = "${var.PROJECT_NAME}-${var.ENV}-public-alb"
  internal                    = false
  load_balancer_type          = "application"
  security_groups             = [aws_security_group.allow-alb-public.id]
  subnets                     = data.terraform_remote_state.vpc.outputs.PUBLIC_SUBNETS
  tags                        = {
    Name                      = "${var.PROJECT_NAME}-${var.ENV}-public-alb"
    Environment               = var.ENV
  }
}


resource "aws_security_group" "allow-alb-public" {
  name                    = "allow-alb-public-sg"
  description             = "allow-alb-public-sg"
  vpc_id                  = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress {
    description           = "HTTP"
    from_port             = 80
    to_port               = 80
    protocol              = "tcp"
    cidr_blocks           = ["0.0.0.0/0"]
  }

  egress {
    from_port             = 0
    to_port               = 0
    protocol              = "-1"
    cidr_blocks           = ["0.0.0.0/0"]
  }

  tags = {
    Name                  = "allow-alb-public-sg"
  }
}

resource "aws_lb_listener" "frontend" {
  load_balancer_arn       = aws_lb.public.arn
  port                    = "80"
  protocol                = "HTTP"

  default_action {
    type                  = "forward"
    target_group_arn      = data.terraform_remote_state.frontend.outputs.FRONTEND_TG_ARN
  }
}