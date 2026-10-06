data "terraform_remote_state" "base_infra" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = var.state_key
    region = var.aws_region
  }
}

data "aws_ssm_parameter" "amazon_linux_2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}
