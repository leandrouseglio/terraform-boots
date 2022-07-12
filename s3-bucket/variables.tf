variable "s3_tfstate_bucket" {
  description = "Name of the S3 bucket used for Terraform state storage"
  default = "serverless-terraform-tfstate"
}
variable "aws_id" {
  default = "063353344768"
}
variable "region" {
  default = "us-east-1"
}