provider "aws" {
  region  = ""
  access_key = ""
  secret_key = ""

}

module "cloudfront" {
  source = "github.com/sandeepkose/cloudfront-s3/modules/"

  SiteTags          = var.SiteTags
  domainName        = var.domainName
  certificate       = var.certificate
  protocol_version  = var.protocol_version
  request_policy    = var.request_policy
  cache_policy      = var.cache_policy
  root_object       = var.root_object
  origin_path       = var.origin_path
}
