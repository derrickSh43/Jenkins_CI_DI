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
    from_port   = 22
    to_port     = 22
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
  ami             = "ami-0e886e280b7bad943"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.ec2j_sg.id]
  subnet_id       = aws_subnet.BackEnd_private_subnet[0].id
  associate_public_ip_address = true
  key_name =  "DevOpsProject"
/*
    user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              
              sudo mkdir /etc/nginx/ssl
              sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx-selfsigned.key -out /etc/nginx/ssl/nginx-selfsigned.crt
              sudo nano /etc/nginx/conf.d/jenkins.conf

              server {
    listen 80;
    server_name 10.230.21.114;  # Replace with your private IP address

    # Redirect HTTP to HTTPS
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name 10.230.21.114;  # Replace with your private IP address

    ssl_certificate /etc/nginx/ssl/nginx-selfsigned.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx-selfsigned.key;

    location /jenkins {
        proxy_pass http://localhost:8080/jenkins;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # Optional: Handle WebSocket connections
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
        sudo systemctl restart nginx








              # Start Jenkins service
              sudo systemctl enable jenkins
              sudo systemctl start jenkins

         
              EOF
}
 
*/
}