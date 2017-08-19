provider "aws" {
        access_key = "${var.accesskey}"
        secret_key = "${var.secretkey}"
        region = "eu-west-1"
}

variable "accesskey" {}
variable "secretkey" {}


variable "keypair" {
  default = "rvwaspprod"
}

variable "kafka1-ami" {
  default = "ami-785db401"
}
variable "kafka2-ami" {
  default = "ami-785db401"
}
variable "kafka3-ami" {
  default = "ami-785db401"
}

variable "mongo1-ami" {
  default = "ami-785db401"
}
variable "mongo2-ami" {
  default = "ami-785db401"
}
variable "mongo3-ami" {
  default = "ami-785db401"
}
variable "aws_rdsdbname" {
  default = "Prod_DB"
}
variable "aws_rdsusername" {
  default = "db_user"
}
variable "aws_rdspass" {
  default = "yoURpassw0rd"
}
