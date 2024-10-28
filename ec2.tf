resource "aws_security_group" "ec2w_sg" {
  name        = "ec2w-sg"
  description = "Security Group for Jenkins"

  vpc_id = aws_vpc.dev_vpc.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]

  }
    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "custom-ec2w-sg"
  }
}
resource "aws_security_group" "ec2j_sg" {
  name        = "ec2j-sg"
  description = "Security Group for Jenkins"

  vpc_id = aws_vpc.dev_vpc.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]

  }
    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2j-sg"
  }
}
resource "aws_instance" "JenkinsInstance" {
  ami             = aws_ami_from_instance.example_ami.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.ec2j_sg.id]
  subnet_id       = aws_subnet.BackEnd_private_subnet[0].id

   user_data_base64 = ("get_initial_password.sh")
}

#Fetch password after Jenkins is provisioned
data "external" "jenkins_password" {
  program = ["./get_initial_password.sh"]
  depends_on = [aws_instance.JenkinsInstance]
}

output "initialAdminPassword" {
  value = data.external.jenkins_password.result["initialAdminPassword"]
}

