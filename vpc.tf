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


