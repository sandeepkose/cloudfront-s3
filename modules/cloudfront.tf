data "aws_cloudfront_origin_request_policy" "this" {
  name = "${var.request_policy}"
}

data "aws_cloudfront_cache_policy" "this" {
  name = "${var.cache_policy}"
}

resource "aws_cloudfront_distribution" "my_cloudfront" {
  depends_on = [
    aws_s3_bucket.my_site_bucket
  ]

  origin {
    domain_name = aws_s3_bucket.my_site_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.my_site_bucket.bucket_regional_domain_name
    origin_path =  var.origin_path
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = var.root_object
  aliases = [var.domainName]
  
  restrictions {
    geo_restriction {
 #     restriction_type = "none"
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]

    }
  }
  
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.my_site_bucket.bucket_regional_domain_name

    compress               = true

    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.this.id
    cache_policy_id          = data.aws_cloudfront_cache_policy.this.id


    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }


  price_class = "PriceClass_200"

  tags = {
    Environment = var.SiteTags
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    acm_certificate_arn = var.certificate
    ssl_support_method       = "sni-only"
    minimum_protocol_version = var.protocol_version
  }

}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "access-identity-${var.domainName}.s3.amazonaws.com"
}
