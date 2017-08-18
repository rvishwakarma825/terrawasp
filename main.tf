        ############################################################################################################################################
        ######VPC CONFIGURATION
        ############################################################################################################################################

        ##replace these ${aws_vpc.wasp_vpc.id} and internet gateway_id ${aws_internet_gateway.wasp_ig.id}


        # VPC Creation

        resource "aws_vpc" "wasp_vpc" {
                cidr_block = "10.0.0.0/16"
                enable_dns_hostnames = "true"
                enable_dns_support = "true"


                        tags {
                          Name = "Prod_VPC"
          }
        }

        #Internet Gateway Creation

        resource "aws_internet_gateway" "wasp_ig" {
                vpc_id = "${aws_vpc.wasp_vpc.id}"
                        tags {
                          Name = "Prod_IG"
          }

        }

        #NATgateway Creation

        resource "aws_eip" "natip" {
          vpc      = true

        }

        resource "aws_nat_gateway" "natgateway" {
          allocation_id = "${aws_eip.natip.id}"
          subnet_id     = "${aws_subnet.publicsubnet.id}"
        }


        #Public Subnet and Route table

        resource "aws_subnet" "publicsubnet" {
                        vpc_id = "${aws_vpc.wasp_vpc.id}"
                        availability_zone = "eu-west-1a"
                        cidr_block = "10.0.0.0/20"
                        tags {
                          Name = "Publicsubnet"
          }
        }

        resource "aws_route_table" "publicrt" {
                        vpc_id = "${aws_vpc.wasp_vpc.id}"

                        route {
                                        cidr_block = "0.0.0.0/0"
                                        gateway_id = "${aws_internet_gateway.wasp_ig.id}"
                        }
                        tags {
                          Name = "PublicRout"
          }
        }

        resource "aws_route_table_association" "publicrt" {
                        subnet_id = "${aws_subnet.publicsubnet.id}"
                        route_table_id = "${aws_route_table.publicrt.id}"
        }



        #Privatewithinternet subnet and routing table

        resource "aws_subnet" "privateintsubnet" {
                        vpc_id = "${aws_vpc.wasp_vpc.id}"
                        availability_zone = "eu-west-1a"
                        cidr_block = "10.0.16.0/20"
                        tags {
                          Name = "PrivateIntsubnet"
          }
        }


        resource "aws_route_table" "privateintrt" {
                        vpc_id = "${aws_vpc.wasp_vpc.id}"

                        route {
                                        cidr_block = "0.0.0.0/0"
                                        nat_gateway_id = "${aws_nat_gateway.natgateway.id}"
                        }

                        tags {
                          Name = "PrivateIntRout"
          }
        }

        resource "aws_route_table_association" "privateintrt" {
                        subnet_id = "${aws_subnet.privateintsubnet.id}"
                        route_table_id = "${aws_route_table.privateintrt.id}"
        }

        #multiaz1 subnet and routing table

        resource "aws_subnet" "mazsubnet_1" {
                        vpc_id = "${aws_vpc.wasp_vpc.id}"
                        availability_zone = "eu-west-1b"
                        cidr_block = "10.0.32.0/20"
                        tags {
                          Name = "MAZsubnet_1"
          }
        }

        resource "aws_route_table" "mazrt_1" {
                        vpc_id = "${aws_vpc.wasp_vpc.id}"

                        route {
                                        cidr_block = "0.0.0.0/0"
                                        nat_gateway_id = "${aws_nat_gateway.natgateway.id}"
                        }

                        tags {
                          Name = "MAZ_1Rout"
          }
        }

        resource "aws_route_table_association" "mazrt_1" {
                        subnet_id = "${aws_subnet.mazsubnet_1.id}"
                        route_table_id = "${aws_route_table.mazrt_1.id}"
        }


        #multiaz2 subnet and routing table

        resource "aws_subnet" "mazsubnet_2" {
                        vpc_id = "${aws_vpc.wasp_vpc.id}"
                        availability_zone = "eu-west-1c"
                        cidr_block = "10.0.48.0/20"
                        tags {
                          Name = "MAZsubnet_2"
          }
        }

        resource "aws_route_table" "mazrt_2" {
                        vpc_id = "${aws_vpc.wasp_vpc.id}"

                        route {
                                        cidr_block = "0.0.0.0/0"
                                        nat_gateway_id = "${aws_nat_gateway.natgateway.id}"
                        }

                        tags {
                          Name = "MAZ_2Rout"
          }
        }

        resource "aws_route_table_association" "mazrt_2" {
                        subnet_id = "${aws_subnet.mazsubnet_2.id}"
                        route_table_id = "${aws_route_table.mazrt_2.id}"
        }

#################################################
#####Windows & Ubuntu Bastion
#################################################

#Bastion instance security group
resource "aws_security_group" "bastion_sg" {
  name        = "bastion"
  description = "bastion_security_group"
  vpc_id = "${aws_vpc.wasp_vpc.id}"

        tags {
          Name = "bastion_security_group"
  }


  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks     = ["::/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks     = ["::/0"]
  }

   ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
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

#instances

resource "aws_instance" "bastion1" {
  ami           = "ami-6dd02214"
  instance_type = "t2.micro"
  key_name      = "${var.keypair}"
  subnet_id   = "${aws_subnet.publicsubnet.id}"
  associate_public_ip_address = "true"
  vpc_security_group_ids = ["${aws_security_group.bastion_sg.id}"]
        tags {
          Name = "bastion1"
  }
}

resource "aws_instance" "bastion2" {
  ami           = "ami-785db401"
  instance_type = "t2.micro"
  key_name      = "${var.keypair}"
  subnet_id   = "${aws_subnet.publicsubnet.id}"
  associate_public_ip_address = "true"
  vpc_security_group_ids = ["${aws_security_group.bastion_sg.id}"]
        tags {
          Name = "bastion2"
  }
}

#Elastic IPs for Bastion

resource "aws_eip" "ip1" {
  instance = "${aws_instance.bastion1.id}"
}
resource "aws_eip" "ip2" {
  instance = "${aws_instance.bastion2.id}"
}


#################################################################################################################################
####Jenkins
#################################################################################################################################

#instance security group
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "jenkins_sg"
  vpc_id = "${aws_vpc.wasp_vpc.id}"

        tags {
          Name = "Prod_jenkins_sg"
  }


  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks  = ["::/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks  = ["::/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks  = ["::/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks  = ["::/0"]
  }

}


resource "aws_instance" "jenkins" {
  ami           = "ami-785db401"
  instance_type = "t2.micro"
  key_name      = "${var.keypair}"
  subnet_id   = "${aws_subnet.publicsubnet.id}"
  associate_public_ip_address = "true"
  vpc_security_group_ids = ["${aws_security_group.jenkins_sg.id}"]


  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = "${file("rvwaspprod.pem")}"
  }


  # Copying the script file to remote server.

  provisioner "file" {
    source      = "files.tar.gz"
    destination = "/home/ubuntu/files.tar.gz"
  }
  provisioner "remote-exec" {
    inline = [
         "sudo apt-get update -y",
                 "sudo tar -xzf files.tar.gz",
                 "cd files",
         "sudo chmod +x jenkins.sh",
         "sudo ./jenkins.sh",
    ]
  }
  tags {
    Name = "Prod_jenkins"
  }
}


        ###########################################
        #####Kafka Cluster
        ###########################################

        #Kafka Cluster Security Group
          resource "aws_security_group" "kafka-sg" {
          name        = "kafka-sg"
          description = "Kafka Security Group"
          vpc_id = "${aws_vpc.wasp_vpc.id}"

          ingress {
                from_port   = 0
                to_port     = 0
                protocol    = "-1"
                cidr_blocks = ["10.0.0.0/16"]
          }

          # outbound internet access
          egress {
                from_port   = 0
                to_port     = 0
                protocol    = "-1"
                cidr_blocks = ["0.0.0.0/0"]
          }
        }

        #Kafka 1st Instance


        resource "aws_autoscaling_group" "kafka1-asg" {
          availability_zones   = ["eu-west-1a"]
          name                 = "kafka1-asg"
          max_size             = "1"
          min_size             = "1"
          desired_capacity     = "1"
          force_delete         = true
          launch_configuration = "${aws_launch_configuration.kafka1-launchconfig.name}"
          vpc_zone_identifier  = ["${aws_subnet.privateintsubnet.id}"]
          tag {
                key                 = "Name"
                value               = "kafka-1"
                propagate_at_launch = "true"
          }
        }

        resource "aws_launch_configuration" "kafka1-launchconfig" {
          name          = "kafka1-launchconfig"
          image_id      = "${var.kafka1-ami}"
          instance_type = "t2.micro"
          security_groups = ["${aws_security_group.kafka-sg.id}"]
          key_name        = "${var.keypair}"
        }

        ####Kafka 2nd instance


          resource "aws_autoscaling_group" "kafka2-asg" {
          availability_zones   = ["eu-west-1b"]
          name                 = "kafka2-asg"
          max_size             = "1"
          min_size             = "1"
          desired_capacity     = "1"
          force_delete         = true
          launch_configuration = "${aws_launch_configuration.kafka2-launchconfig.name}"
          vpc_zone_identifier  = ["${aws_subnet.mazsubnet_1.id}"]
          tag {
                key                 = "Name"
                value               = "kafka-2"
                propagate_at_launch = "true"
          }
        }

        resource "aws_launch_configuration" "kafka2-launchconfig" {
          name          = "kafka2-launchconfig"
          image_id      = "${var.kafka2-ami}"
          instance_type = "t2.micro"
          security_groups = ["${aws_security_group.kafka-sg.id}"]
          key_name        = "${var.keypair}"
        }

        #Kafka 3rd Instance

                resource "aws_autoscaling_group" "kafka3-asg" {
          availability_zones   = ["eu-west-1c"]
          name                 = "kafka3-asg"
          max_size             = "1"
          min_size             = "1"
          desired_capacity     = "1"
          force_delete         = true
          launch_configuration = "${aws_launch_configuration.kafka3-launchconfig.name}"
          vpc_zone_identifier  = ["${aws_subnet.mazsubnet_2.id}"]
          tag {
                key                 = "Name"
                value               = "kafka-3"
                propagate_at_launch = "true"
          }
        }

        resource "aws_launch_configuration" "kafka3-launchconfig" {
          name          = "kafka3-launchconfig"
          image_id      = "${var.kafka3-ami}"
          instance_type = "t2.micro"
          security_groups = ["${aws_security_group.kafka-sg.id}"]
          key_name        = "${var.keypair}"
        }

############################################################################
#######Mongo DB Cluster
############################################################################

        ###########################################
        #####mongo Cluster
        ###########################################

        #mongo Cluster Security Group
          resource "aws_security_group" "mongo-sg" {
          name        = "mongo-sg"
          description = "mongo Security Group"
          vpc_id = "${aws_vpc.wasp_vpc.id}"

          ingress {
                from_port   = 0
                to_port     = 0
                protocol    = "-1"
                cidr_blocks = ["10.0.0.0/16"]
          }

          # outbound internet access
          egress {
                from_port   = 0
                to_port     = 0
                protocol    = "-1"
                cidr_blocks = ["0.0.0.0/0"]
          }
        }

        #mongo 1st Instance


        resource "aws_autoscaling_group" "mongo1-asg" {
          availability_zones   = ["eu-west-1a"]
          name                 = "mongo1-asg"
          max_size             = "1"
          min_size             = "1"
          desired_capacity     = "1"
          force_delete         = true
          launch_configuration = "${aws_launch_configuration.mongo1-launchconfig.name}"
          vpc_zone_identifier  = ["${aws_subnet.privateintsubnet.id}"]
          tag {
                key                 = "Name"
                value               = "mongo-1"
                propagate_at_launch = "true"
          }
        }

        resource "aws_launch_configuration" "mongo1-launchconfig" {
          name          = "mongo1-launchconfig"
          image_id      = "${var.mongo1-ami}"
          instance_type = "t2.micro"
          security_groups = ["${aws_security_group.mongo-sg.id}"]
          key_name        = "${var.keypair}"
        }

        ####mongo 2nd instance


          resource "aws_autoscaling_group" "mongo2-asg" {
          availability_zones   = ["eu-west-1b"]
          name                 = "mongo2-asg"
          max_size             = "1"
          min_size             = "1"
          desired_capacity     = "1"
          force_delete         = true
          launch_configuration = "${aws_launch_configuration.mongo2-launchconfig.name}"
          vpc_zone_identifier  = ["${aws_subnet.mazsubnet_1.id}"]
          tag {
                key                 = "Name"
                value               = "mongo-2"
                propagate_at_launch = "true"
          }
        }

        resource "aws_launch_configuration" "mongo2-launchconfig" {
          name          = "mongo2-launchconfig"
          image_id      = "${var.mongo2-ami}"
          instance_type = "t2.micro"
          security_groups = ["${aws_security_group.mongo-sg.id}"]
          key_name        = "${var.keypair}"
        }

        #mongo 3rd Instance

                resource "aws_autoscaling_group" "mongo3-asg" {
          availability_zones   = ["eu-west-1c"]
          name                 = "mongo3-asg"
          max_size             = "1"
          min_size             = "1"
          desired_capacity     = "1"
          force_delete         = true
          launch_configuration = "${aws_launch_configuration.mongo3-launchconfig.name}"
          vpc_zone_identifier  = ["${aws_subnet.mazsubnet_2.id}"]
          tag {
                key                 = "Name"
                value               = "mongo-3"
                propagate_at_launch = "true"
          }
        }

        resource "aws_launch_configuration" "mongo3-launchconfig" {
          name          = "mongo3-launchconfig"
          image_id      = "${var.mongo3-ami}"
          instance_type = "t2.micro"
          security_groups = ["${aws_security_group.mongo-sg.id}"]
          key_name        = "${var.keypair}"
        }


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


###################################################
###### Elasticache Redis
###################################################

#elasticachesubnetgroup

resource "aws_elasticache_subnet_group" "elasticachesubnetgroup" {
  name       = "prod-elasticache-subnetgroup"
  subnet_ids = ["${aws_subnet.privateintsubnet.id}","${aws_subnet.mazsubnet_1.id}","${aws_subnet.mazsubnet_2.id}"]
}


#Elasticache security group


resource "aws_security_group" "Elasticachesg" {
  name        = "Prod_Elasticache_SecurityGroup"
  description = "Prod_Elasticache_SecurityGroup"
  vpc_id = "${aws_vpc.wasp_vpc.id}"

        tags {
          Name = "Prod_Elasticache_SecurityGroup"
  }


  ingress {
    from_port   = 6379
    to_port     = 6379
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


#Elasticache

resource "aws_elasticache_replication_group" "wasp-replication-group" {
  replication_group_id          = "wasp-repltn-group"
  replication_group_description = "wasp-replication-group"
  node_type                     = "cache.t2.medium"
  port                          = 6379
  parameter_group_name          = "default.redis3.2.cluster.on"
  subnet_group_name = "${aws_elasticache_subnet_group.elasticachesubnetgroup.id}"
  snapshot_retention_limit      = "3"
  security_group_ids = ["${aws_security_group.Elasticachesg.id}"]
  automatic_failover_enabled    = true
  cluster_mode {
    replicas_per_node_group     = 2
    num_node_groups             = 3
  }
}


