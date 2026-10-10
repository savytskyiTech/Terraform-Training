terraform {
  backend "s3" {
    bucket = "cmtr-p9rj0mw4-backend-new-bucket-1791453002"
    key    = "tf_code.tfstate"
    region = "eu-west-1"
  }
}
