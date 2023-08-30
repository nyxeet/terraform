
provider "aws" {}

resource "aws_instance" "my_ubuntu" {
  ami           = "ami-04e601abe3e1a910f"
  instance_type = "t2.micro"

  tags = {
    Name    = "My ubuntu server test"
    Owner   = "Dima Kyrych"
    Project = "Amazon"
  }
}

resource "aws_instance" "my_amazon_linux" {
  ami           = "ami-0766f68f0b06ab145"
  instance_type = "t2.small"

  tags = {
    Name    = "My amazon linux server"
    Owner   = "Dima Kyrych"
    Project = "Amazon"
  }
}
