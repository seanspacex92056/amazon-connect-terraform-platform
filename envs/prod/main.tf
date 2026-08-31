provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.tags
  }
}

locals {
  project_name = "webroot-connect"
  tags = {
    Project     = local.project_name
    Environment = "prod"
    Service     = "connect"
    Owner       = "cloud-platform"
    CostCenter  = "support"
  }
}

module "lambda" {
  source       = "../../modules/lambda"
  project_name = local.project_name
  environment  = "prod"
  tags         = local.tags
}

resource "aws_s3_bucket" "recordings" {
  bucket_prefix = "webroot-prod-connect-"
  tags          = local.tags
}

module "connect" {
  source                     = "../../modules/connect"
  project_name               = local.project_name
  environment                = "prod"
  recordings_bucket_arn      = aws_s3_bucket.recordings.arn
  customer_lookup_lambda_arn = module.lambda.customer_lookup_lambda_arn
  tags                       = local.tags
}

module "observability" {
  source              = "../../modules/observability"
  project_name        = local.project_name
  environment         = "prod"
  connect_instance_id = module.connect.instance_id
  tags                = local.tags
}
