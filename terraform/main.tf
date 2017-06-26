variable "region"              {}
variable "name"                {}
variable "domain"              {}
variable "subdomain"           {}
variable "install_script_path" {}
variable "install_script_name" {}

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

provider "aws" {
  alias  = "us-east"
  access_key = "${data.terraform_remote_state.tfstates.access_id}"
  secret_key = "${data.terraform_remote_state.tfstates.secret_key}"
  region     = "us-east-1"
}

data "aws_acm_certificate" "dotfiles" {
  provider = "aws.us-east"
  domain   = "${var.subdomain}.${var.domain}"
}

data "template_file" "dotfiles_s3_policy" {
  template = "${file("s3_policy.json.tpl")}"

  vars {
    bucket_name            = "${var.name}"
    origin_access_identity = "${aws_cloudfront_origin_access_identity.dotfiles.id}"
  }
}

resource "aws_cloudfront_origin_access_identity" "dotfiles" {
  comment = "${var.name}"
}

resource "aws_s3_bucket" "dotfiles" {
  bucket = "${var.name}"
  acl    = "public-read"
  policy = "${data.template_file.dotfiles_s3_policy.rendered}"

  website {
    index_document = "${var.install_script_name}"
  }
}

resource "aws_s3_bucket_object" "dotfiles-index-document" {
  bucket = "${aws_s3_bucket.dotfiles.id}"
  key    = "${var.install_script_name}"
  source = "${var.install_script_path}"
  acl    = "public-read"
}

resource "aws_cloudfront_distribution" "dotfiles" {
  origin {
    domain_name = "${aws_s3_bucket.dotfiles.website_endpoint}"
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
  default_root_object = "${var.install_script_name}"
  aliases             = ["${var.subdomain}.${var.domain}"]

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
    acm_certificate_arn = "${data.aws_acm_certificate.dotfiles.arn}"
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1"
  }
}

data "aws_route53_zone" "dotfiles" {
  name = "${var.domain}"
}

resource "aws_route53_record" "dotfiles-ipv4" {
  zone_id = "${data.aws_route53_zone.dotfiles.zone_id}"
  name    = "${var.subdomain}.${data.aws_route53_zone.dotfiles.name}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.dotfiles.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.dotfiles.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "dotfiles-ipv6" {
  zone_id = "${data.aws_route53_zone.dotfiles.zone_id}"
  name    = "${var.subdomain}.${data.aws_route53_zone.dotfiles.name}"
  type    = "AAAA"

  alias {
    name                   = "${aws_cloudfront_distribution.dotfiles.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.dotfiles.hosted_zone_id}"
    evaluate_target_health = false
  }
}
