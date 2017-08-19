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



