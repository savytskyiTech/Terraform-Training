resource "aws_iam_policy" "custom_policy" {
  name        = var.policy_name
  description = var.policy_description
  path        = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = var.policy_actions
      Resource = "*"
    }]
  })
}
