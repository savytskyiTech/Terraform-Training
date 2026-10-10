terraform {
  backend "s3" {
    bucket = "cmtr-p9rj0mw4-backend-bucket-1791625191"
    key    = "tf_code.tfstate"
    region = "eu-west-1"
  }
}
