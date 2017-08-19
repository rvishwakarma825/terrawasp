
#################################################################################################
###### EFS
#################################################################################################

resource "aws_security_group" "efs_sg" {
  name        = "efs_sg"
  description = "efs_sg"
  vpc_id = "${aws_vpc.wasp_vpc.id}"

        tags {
          Name = "Prod_efs_sg"
  }


  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks  = ["::/0"]
  }

}

resource "aws_efs_file_system" "prod-efs" {
    performance_mode = "generalPurpose"

    tags {
        Name = "prod-efs"
    }
}

resource "aws_efs_mount_target" "efs-mount-target1" {
     file_system_id = "${aws_efs_file_system.prod-efs.id}"
    subnet_id      = "${aws_subnet.privateintsubnet.id}"
    security_groups = ["${aws_security_group.efs_sg.id}"]
}
resource "aws_efs_mount_target" "efs-mount-target2" {
     file_system_id = "${aws_efs_file_system.prod-efs.id}"
     subnet_id = "${aws_subnet.mazsubnet_1.id}"
    security_groups = ["${aws_security_group.efs_sg.id}"]
}
resource "aws_efs_mount_target" "efs-mount-target3" {
     file_system_id = "${aws_efs_file_system.prod-efs.id}"
    subnet_id = "${aws_subnet.mazsubnet_2.id}"
    security_groups = ["${aws_security_group.efs_sg.id}"]
}


