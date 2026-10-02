resource "aws_iam_group" "main" {
  name = "${var.project}-${var.title}-group"
}

resource "aws_iam_policy" "main" {
  name        = "${var.project}-${var.title}-policy"
  description = "Write access to the designated S3 bucket"
  policy = templatefile("${path.module}/policy.json", {
    bucket_name = var.bucket_name
  })

  tags = {
    Project = var.project
  }
}

resource "aws_iam_role" "main" {
  name = "${var.project}-${var.title}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Project = var.project
  }
}

resource "aws_iam_instance_profile" "main" {
  name = "${var.project}-${var.title}-instance-profile"
  role = aws_iam_role.main.name

  tags = {
    Project = var.project
  }
}

resource "aws_iam_role_policy_attachment" "main" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.main.arn
}
