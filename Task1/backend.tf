terraform {
  backend "s3" {
    bucket         = "remote-backend-s3"
    key            = "terraform/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "remote-backend-locks"
    encrypt        = true
  }
}
