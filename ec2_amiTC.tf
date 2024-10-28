//1. create the ec2 instance
resource "aws_instance" "tomcat_instance" {
  ami                         = "ami-06b21ccaeff8cd686" # Specify the base AMI ID
  instance_type               = "t2.micro"     # Specify the instance type
  associate_public_ip_address = true           # Adjust as needed
  subnet_id                   = aws_subnet.front_public_subnet[0].id


  user_data = filebase64("userdate.sh")
  tags = {
    Name = "tomcattom-instance"
  }

}
//2. Create the AMI from the ec2 instance
resource "aws_ami_from_instance" "tomcat_ami" {
  name               = "tomcat-ami"
  source_instance_id = aws_instance.tomcat_instance.id

}

//3. Wait for the AMI then Terminate the ec2 instance
data "aws_instance" "tomcat_running" {
    filter {
        name = "instance-state-name"
        values = ["running"]
    }

    instance_id = aws_instance.tomcat_instance.id

    depends_on = [aws_ami_from_instance.tomcat_ami]
}

output "TCinstance_id" {
    value = data.aws_instance.tomcat_running.id
}

resource "null_resource" "deletetc_instances" {
    triggers = {
        instance_id = "${aws_instance.tomcat_instance.id}"
    }
    depends_on = [aws_ami_from_instance.tomcat_ami]
    provisioner "local-exec" {
        command = "aws ec2 terminate-instances --instance-ids ${aws_instance.tomcat_instance.id}"
    }
}