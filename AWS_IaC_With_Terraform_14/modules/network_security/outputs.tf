output "security_group_ids" {
  description = "Security group IDs with their ingress and egress rules configured."
  value = {
    ssh          = aws_security_group.ssh.id
    public_http  = aws_security_group.public_http.id
    private_http = aws_security_group.private_http.id
  }

  depends_on = [
    aws_security_group_rule.ssh,
    aws_security_group_rule.public_http,
    aws_security_group_rule.private_http,
    aws_security_group_rule.egress,
  ]
}
