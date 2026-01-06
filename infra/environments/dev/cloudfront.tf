resource "aws_cloudfront_distribution" "eks_app" {
  provider = aws.us_east_1
 
web_acl_id = aws_wafv2_web_acl.cloudfront_waf.arn

  enabled         = true
  price_class     = "PriceClass_100"
  is_ipv6_enabled = true

  origin {
    origin_id   = "eks-private-alb"
    domain_name = var.alb_dns_name

    vpc_origin_config {
      vpc_origin_id = aws_cloudfront_vpc_origin.eks_origin.id
    }
  }

  default_cache_behavior {
    target_origin_id       = "eks-private-alb"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name = "eks-cloudfront"
  }
}
