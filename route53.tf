###############################################################################################
######Route 53 Private entries
###############################################################################################

resource "aws_route53_zone" "main" {
  name = "intwasp.prod"
  vpc_id = "${aws_vpc.wasp_vpc.id}"
  comment = "indusnet"

  tags {
    Environment = "prod"
  }
}

resource "aws_route53_record" "kafka1" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "kafka1.intwasp.prod"
  type    = "A"
  ttl     = "30"

  records = ["10.250.0.1"]
}
resource "aws_route53_record" "kafka2" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "kafka2.intwasp.prod"
  type    = "A"
  ttl     = "30"

  records = ["10.250.0.2"]
}
resource "aws_route53_record" "kafka3" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "kafka3.intwasp.prod"
  type    = "A"
  ttl     = "30"

  records = ["10.250.0.3"]
}
resource "aws_route53_record" "mongo1" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "mongo1.intwasp.prod"
  type    = "A"
  ttl     = "30"

  records = ["10.250.0.4"]
}
resource "aws_route53_record" "mongo2" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "mongo2.intwasp.prod"
  type    = "A"
  ttl     = "30"

  records = ["10.250.0.5"]
}
resource "aws_route53_record" "mongo3" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "mongo3.intwasp.prod"
  type    = "A"
  ttl     = "30"

  records = ["10.250.0.6"]
}
resource "aws_route53_record" "postgres" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "postgres.intwasp.prod"
  type    = "A"
  ttl     = "30"

  records = ["10.250.0.7"]
}
resource "aws_route53_record" "redis" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "redis.intwasp.prod"
  type    = "A"
  ttl     = "30"

  records = ["10.250.0.8"]
}
resource "aws_route53_record" "efs" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "efs.intwasp.prod"
  type    = "A"
  ttl     = "30"

  records = ["10.250.0.9"]
}

