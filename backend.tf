terraform {
  backend "s3" {
    bucket  = "infra-growth"
    key     = "us-east-1/enviroment/dev/infra-growth.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
