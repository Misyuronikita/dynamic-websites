### Specific naming for destribution ###
locals {
  alb_origin_id = "myALBOrigin"
}

### Destribution creating ###
resource "aws_cloudfront_distribution" "alb_distribution" {
  enabled = true
  comment = "my_cloudfront"
  origin {
    domain_name = aws_lb.alb.dns_name
    origin_id   = aws_lb.alb.dns_name
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = aws_lb.alb.dns_name
    forwarded_values {
      headers      = []
      query_string = true
      cookies {
        forward = "all"
      }
    }
    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 10
    max_ttl                = 20
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["PL"]
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
