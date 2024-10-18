resource "aws_s3_bucket" "main" {
  bucket              = "${var.project}-${var.env}"
  force_destroy       = true
  object_lock_enabled = false

  tags = {
    Name = "${var.project}-${var.env}"
  }
}

resource "aws_s3_bucket_acl" "main" {
  bucket = aws_s3_bucket.main.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id

  policy = <<POLICY
{
    "Id": "ExamplePolicy",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowSSLRequestsOnly",
            "Action": "s3:*",
            "Effect": "Deny",
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.main.id}",
                "arn:aws:s3:::${aws_s3_bucket.main.id}/*"
            ],
            "Condition": {
                "Bool": {
                     "aws:SecureTransport": "false"
                }
            },
            "Principal": "*"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::797873946194:root"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.main.id}/AWSLogs/${data.aws_caller_identity.main.account_id}/*"
        },
        {
            "Sid": "AWSLogDeliveryWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "delivery.logs.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.main.id}/AWSLogs/${data.aws_caller_identity.main.account_id}/*",
            "Condition": {
              "StringEquals": {
                "s3:x-amz-acl": "bucket-owner-full-control"
              }
            }
        },
        {
          "Sid": "AWSLogDeliveryAclCheck",
          "Effect": "Allow",
          "Principal": {
            "Service": "delivery.logs.amazonaws.com"
          },
          "Action": "s3:GetBucketAcl",
          "Resource": "arn:aws:s3:::${aws_s3_bucket.main.id}"
        }
    ]
}
POLICY
}

resource "aws_ecs_cluster" "main" {
  name = "${var.project}-${var.env}"

  setting {
    name  = "containerInsights"
    value = var.containerInsights == true ? "enabled" : "disabled"
  }

  tags = {
    Name = "${var.project}-${var.env}"
  }
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name       = aws_ecs_cluster.main.name
  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_acm_certificate" "main" {
  domain_name       = "front.${var.project}.${var.domain}"
  validation_method = "DNS"

  tags = {
    Name = "front.${var.project}.${var.domain}"
  }
}

resource "aws_route53_record" "main" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.main.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.main.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.main.domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.main.zone_id
  ttl             = 60
}

resource "aws_security_group" "main" {
  name   = "${var.project}-${var.env}"
  vpc_id = data.aws_vpc.main.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-${var.env}"
  }
}

resource "aws_lb" "main" {
  name                       = "${var.project}-${var.env}"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.main.id]
  subnets                    = data.aws_subnets.main.ids
  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.main.id
    enabled = true
  }

  tags = {
    Name = "${var.project}-${var.env}"
  }
}

resource "aws_lb_target_group" "main" {
  name  = "${var.project}-${var.env}"
  target_type = "ip"
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.main.id

  health_check {
    enabled           = true
    healthy_threshold = 2
    interval          = 5
    matcher           = "200-299"
    path              = "/"
    port              = "8080"
    protocol          = "HTTP"
    unhealthy_threshold = 2
    timeout             = 3
  }

  tags = {
    Name = "${var.project}-${var.env}"
  }
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.main.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_route53_record" "app" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "front.${var.project}.${var.domain}"
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = false
  }
}