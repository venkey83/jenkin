provider "aws" {
region = "ap-northeast-1"
assume_role {
    role_arn     = "arn:aws:iam::102235972332:role/admin"
#    session_name = "SESSION_NAME"
#   external_id  = "EXTERNAL_ID"
  }
}
