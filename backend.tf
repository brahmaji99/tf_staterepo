terraform {
  backend "s3" {
    bucket         = "hackathon-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

