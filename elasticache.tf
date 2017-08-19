
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

