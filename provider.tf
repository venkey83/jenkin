provider "aws" {
region = "ap-northeast-1"

/*
assume_role {
    role_arn     = "arn:aws:iam::414560708099:role/admin"
#    session_name = "SESSION_NAME"
#   external_id  = "EXTERNAL_ID"
  }
*/
}

terraform {
  backend "s3" {
  }
}
