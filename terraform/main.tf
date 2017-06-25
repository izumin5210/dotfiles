variable "region"             {}
variable "name"               {}
variable "domain"             {}
variable "install_script_url" {}

data "terraform_remote_state" "tfstates" {
  backend = "s3"
  config {
    bucket = "izumin5210-tfstates"
    key    = "izumin5210/tf/dotfiles"
    region = "ap-northeast-1"
  }
}

terraform {
  backend "s3" {
    bucket = "izumin5210-tfstates"
    key    = "izumin5210/dotfiles/dotfiles"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  access_key = "${data.terraform_remote_state.tfstates.access_id}"
  secret_key = "${data.terraform_remote_state.tfstates.secret_key}"
  region     = "${var.region}"
}

data "template_file" "dotfiles_s3_policy" {
  template = "${file("s3_policy.json.tpl")}"

  vars {
    bucket_name            = "${var.name}"
    origin_access_identity = "${aws_cloudfront_origin_access_identity.dotfiles.id}"
  }
}

data "template_file" "dotfiles_index_document" {
  template = "${file("index.html.tpl")}"

  vars {
    redirect_to = "${var.install_script_url}"
  }
}

resource "aws_cloudfront_origin_access_identity" "dotfiles" {
  comment = "${var.name}"
}

resource "aws_s3_bucket" "dotfiles" {
  bucket = "${var.name}"
  acl    = "private"
  policy = "${data.template_file.dotfiles_s3_policy.rendered}"

  website {
    index_document = "index.html"
    error_document = "404.html"
  }
}

resource "aws_s3_bucket_object" "dotfiles-index-document" {
  bucket = "${aws_s3_bucket.dotfiles.id}"
  key    = "index.html"
  content = "${data.template_file.dotfiles_index_document.rendered}"
}

resource "aws_cloudfront_distribution" "dotfiles" {
  origin {
    domain_name = "${aws_s3_bucket.dotfiles.bucket_domain_name}"
    origin_id   = "${var.name}"

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.name}"
  default_root_object = "index.html"
  aliases             = ["${var.domain}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${aws_s3_bucket.dotfiles.id}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_route53_zone" "dotfiles" {
  name = "${var.domain}"
}

resource "aws_route53_record" "dotfiles" {
  zone_id = "${aws_route53_zone.dotfiles.zone_id}"
  name    = "${var.domain}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.dotfiles.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.dotfiles.hosted_zone_id}"
    evaluate_target_health = false
  }
}
