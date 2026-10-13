aws_region = "eu-west-1"
project_id = "cmtr-p9rj0mw4"
vpc_cidr   = "10.10.0.0/16"

public_subnets = {
  a = {
    name              = "cmtr-p9rj0mw4-subnet-public-a"
    cidr_block        = "10.10.1.0/24"
    availability_zone = "eu-west-1a"
  }
  b = {
    name              = "cmtr-p9rj0mw4-subnet-public-b"
    cidr_block        = "10.10.3.0/24"
    availability_zone = "eu-west-1b"
  }
  c = {
    name              = "cmtr-p9rj0mw4-subnet-public-c"
    cidr_block        = "10.10.5.0/24"
    availability_zone = "eu-west-1c"
  }
}

allowed_ip_range = ["18.153.146.156/32", "194.147.221.112/32"]
ami_name_pattern = "al2023-ami-2023.*-x86_64"
instance_type    = "t3.micro"
desired_capacity = 2
min_size         = 2
max_size         = 2
