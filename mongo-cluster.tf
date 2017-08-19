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



