resource "aws_autoscaling_group" "ec2_asg" {
  max_size            = 3
  min_size            = 2
  desired_capacity    = 2
  name                = "custom-web-server-asg"
  target_group_arns   = [aws_lb_target_group.alb_ec2_tg.arn]
  vpc_zone_identifier = aws_subnet.web_private_subnet[*].id

  launch_template {
    id      = aws_launch_template.ec2_launch_template.id
    version = "$Latest"
  }

  health_check_type = "EC2"
}

resource "aws_launch_template" "ec2_launch_template" {
  name          = "custom-ec2-launch-template"
  image_id      = aws_ami_from_instance.tomcat_ami.id
  instance_type = "t2.micro"
  user_data =  filebase64(
    <<-EOF
    #!/bin/bash
    sudo service tomcat start
    EOF
  )

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.ec2w_sg.id]
  }

}
