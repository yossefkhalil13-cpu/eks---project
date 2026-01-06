resource "aws_cloudfront_vpc_origin" "eks_origin" {
  provider = aws.us_east_1

  vpc_origin_endpoint_config {
    name                   = "eks-private-alb-origin"
    arn                    = var.alb_arn
    http_port              = 80
    https_port             = 443
    origin_protocol_policy = "http-only"

    origin_ssl_protocols {
      items    = ["TLSv1.2"]
      quantity = 1
    }
  }
}
