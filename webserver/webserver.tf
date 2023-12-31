#------------------------------------------------------------
# My terraform
#
# Build WebServer during Bootstrap
#------------------------------------------------------------
provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "web_server" {
  ami                    = "ami-0766f68f0b06ab145" # Amazon linux AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_server_security_group.id]
  user_data              = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform!" > /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
EOF

  tags = {
    Name  = "Web Server Build by Terraform"
    Owner = "Dima"
  }
}

resource "aws_security_group" "web_server_security_group" {
  name        = "Web server security group terraform"
  description = "My first security group from terraform"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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
    Name  = "Web Server SecurityGroup Build by Terraform"
    Owner = "Dima"
  }
}
