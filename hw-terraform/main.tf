provider "aws" {
  region = "eu-central-1"
}
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "terraform"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "terraform"
  }
}

resource "aws_subnet" "my_subnet_1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true
}
resource "aws_subnet" "my_subnet_2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true
}
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.my_subnet_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "my_security_group" {
  name        = "hw terraform"
  description = "hw terraform"
  vpc_id      = aws_vpc.my_vpc.id

  dynamic "ingress" {
    for_each = ["80", "443", "22", "3306"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "my_security_group_db" {
  name        = "hw terraform for db"
  description = "hw terraform for db"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# user_data = templatefile("bootstrap.sh.tpl", {
#     RDS_URL  = aws_db_instance.default.endpoint
#     RDS_user = aws_db_instance.default.username
#     RDS_DB   = aws_db_instance.default.db_name
#     RDS_pwd  = "qwerty123"
#   })
resource "aws_instance" "my_instance" {
  ami           = "ami-0aa74281da945b6b5" # ami amazon linux 2
  instance_type = "t2.micro"
  user_data = templatefile("bootstrap.sh.tpl", {
    RDS_URL  = aws_db_instance.default.endpoint
    RDS_user = aws_db_instance.default.username
    RDS_DB   = aws_db_instance.default.db_name
    RDS_pwd  = "qwerty123"
  })
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  subnet_id              = aws_subnet.my_subnet_2.id
  tags = {
    Name  = "hw terraform"
    Owner = "Dima"
  }
  user_data_replace_on_change = true
}

resource "aws_db_instance" "default" {
  allocated_storage      = 10
  db_name                = "mydb"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  username               = "admin"
  password               = "qwerty123"
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.my_security_group_db.id]
  db_subnet_group_name   = aws_db_subnet_group.my_db_subnet_group.name
}

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.my_subnet_1.id, aws_subnet.my_subnet_2.id]
}





