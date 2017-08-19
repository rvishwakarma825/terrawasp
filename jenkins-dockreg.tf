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


