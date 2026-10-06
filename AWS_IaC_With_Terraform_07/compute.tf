resource "aws_instance" "main" {
  ami                         = data.aws_ssm_parameter.amazon_linux_2023_ami.value
  instance_type               = var.instance_type
  subnet_id                   = data.terraform_remote_state.base_infra.outputs.public_subnet_id
  vpc_security_group_ids      = [data.terraform_remote_state.base_infra.outputs.security_group_id]
  associate_public_ip_address = true

  tags = {
    Name      = "${var.project_id}-ec2"
    Terraform = "true"
    Project   = var.project_id
  }
}
