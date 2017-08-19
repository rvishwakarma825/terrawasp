####################################
##### RDS
####################################

#RDS subnet group

resource "aws_db_subnet_group" "rdssubnetgroup" {
  name       = "prod_rds_subnetgroup"
  subnet_ids = ["${aws_subnet.privateintsubnet.id}","${aws_subnet.mazsubnet_1.id}","${aws_subnet.mazsubnet_2.id}"]

  tags {
    Name = "Prod_RDS_SubnetGroup"
  }
}


#dbsecurity group


resource "aws_security_group" "RDSsg" {
  name        = "Prod_RDS_SecurityGroup"
  description = "Prod_RDS_SecurityGroup"
  vpc_id = "${aws_vpc.wasp_vpc.id}"

        tags {
          Name = "Prod_RDS_SecurityGroup"
  }



  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    ipv6_cidr_blocks     = ["::/0"]
  }
}


#rds instance

resource "aws_db_instance" "wasp_rds" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "9.6.2"
  instance_class       = "db.t2.small"
  multi_az             = "true"
  publicly_accessible  = "false"
  storage_encrypted    = "true"
  backup_retention_period = "7"
  copy_tags_to_snapshot = "true"
  kms_key_id               = "arn:aws:kms:eu-west-1:004263635438:key/9dfdaa92-c657-4206-96b0-2227992cee7d"
  vpc_security_group_ids = ["${aws_security_group.RDSsg.id}"]
  db_subnet_group_name  = "${aws_db_subnet_group.rdssubnetgroup.id}"
  parameter_group_name = "default.postgres9.6"
  name                 = "${var.aws_rdsdbname}"
  username             = "${var.aws_rdsusername}"
  password             = "${var.aws_rdspass}"
}


