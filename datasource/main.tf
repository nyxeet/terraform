provider "aws" {}

data "aws_availability_zones" "working" {}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_vpcs" "my_vpcs" {}
data "aws_vpc" "default_vpc" {}


resource "aws_subnet" "new_subnet_1" {
  vpc_id            = data.aws_vpc.default_vpc.id
  availability_zone = data.aws_availability_zones.working.names[0]
  cidr_block        = "172.31.48.0/20"

  tags = {
    Name    = "New subnet in ${data.aws_availability_zones.working.names[0]}"
    Account = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.description
  }
}
resource "aws_subnet" "new_subnet_2" {
  vpc_id            = data.aws_vpc.default_vpc.id
  availability_zone = data.aws_availability_zones.working.names[1]
  cidr_block        = "172.31.64.0/20"

  tags = {
    Name    = "New subnet in ${data.aws_availability_zones.working.names[1]}"
    Account = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.description
  }
}



output "data_aws_availability_zones" {
  value = data.aws_availability_zones.working.names
}

output "data_aws_caller_identity" {
  value = data.aws_caller_identity.current.account_id
}

output "data_aws_region_name" {
  value = data.aws_region.current.name
}

output "data_aws_region_description" {
  value = data.aws_region.current.description
}

output "data_aws_vpcs" {
  value = data.aws_vpcs.my_vpcs.ids
}
output "default_vpc_id" {
  value = data.aws_vpc.default_vpc.id
}
output "default_vpc_cidr" {
  value = data.aws_vpc.default_vpc.cidr_block
}
