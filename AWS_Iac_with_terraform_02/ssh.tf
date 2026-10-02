resource "aws_key_pair" "main" {
  key_name   = "${var.resource_id}-keypair"
  public_key = var.ssh_key


  tags = {
    Project = var.project_name
    ID      = var.resource_id
  }
}
