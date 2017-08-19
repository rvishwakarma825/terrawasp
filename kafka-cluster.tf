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


