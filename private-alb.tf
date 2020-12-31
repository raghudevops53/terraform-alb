resource "aws_lb" "private" {
  name                        = "${var.PROJECT_NAME}-${var.ENV}-private-alb"
  internal                    = true
  load_balancer_type          = "application"
  security_groups             = [aws_security_group.allow-alb-private.id]
  subnets                     = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS
  tags                        = {
    Name                      = "${var.PROJECT_NAME}-${var.ENV}-private-alb"
    Environment               = var.ENV
  }
}


resource "aws_security_group" "allow-alb-private" {
  name                    = "allow-alb-private-sg"
  description             = "allow-alb-private-sg"
  vpc_id                  = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress {
    description           = "HTTP"
    from_port             = 80
    to_port               = 80
    protocol              = "tcp"
    cidr_blocks           = [data.terraform_remote_state.vpc.outputs.VPC_CIDR]
  }

  egress {
    from_port             = 0
    to_port               = 0
    protocol              = "-1"
    cidr_blocks           = ["0.0.0.0/0"]
  }

  tags = {
    Name                  = "allow-alb-private-sg"
  }
}

resource "aws_lb_listener" "default" {
  load_balancer_arn       = aws_lb.private.arn
  port                    = "80"
  protocol                = "HTTP"

  default_action {
    type                  = "fixed-response"

    fixed_response {
      content_type        = "text/plain"
      message_body        = "OK"
      status_code         = "200"
    }
  }
}

