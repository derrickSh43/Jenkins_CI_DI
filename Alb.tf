//3. Create The Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = "custom-app-lb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.front_public_subnet[*].id
  depends_on         = [aws_internet_gateway.internet_gateway]
}

//4. Create A Target Group

resource "aws_lb_target_group" "alb_ec2_tg" {
  name     = "web-server-tg"
  port     = 8080
  protocol = "HTTP"
  #target_type = "instance"
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name = "alb_ec2_tg"

  }

}
resource "aws_lb_target_group" "ec2_tg" {
  name     = "jenkins-server-tg"
  port     = 8080
  protocol = "HTTP"
  #target_type = "instance"
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name = "ec2_tg"

  }

}
resource "aws_lb_target_group_attachment" "tg_attachment_b" {
  target_group_arn = aws_lb_target_group.ec2_tg.arn
  target_id        = aws_instance.JenkinsInstance.id
  port             = 8080
}


//5. alb listener
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_ec2_tg.arn

  }

}
resource "aws_lb_listener_rule" "rule_b" {
  listener_arn = aws_lb_listener.alb_listener.arn
  priority     = 60


  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_tg.arn
  }

  condition {
    path_pattern {
      values = ["/jenkins"]
    }
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "custom-alb-sg"
  description = "Security Group for Application Load Balancer"

  vpc_id = aws_vpc.dev_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
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
    Name = "custom-alb-sg"
  }
}

