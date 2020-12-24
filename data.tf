data "terraform_remote_state" "vpc" {
  backend           = "s3"
  config            = {
    bucket          = var.bucket
    key             = "vpc/${var.ENV}/terraform.tfstate"
    region          = var.region
  }
}