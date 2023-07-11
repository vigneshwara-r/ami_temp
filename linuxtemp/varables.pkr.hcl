variable "build_sources" {
  default = "source.docker.amazonlinux"
}

variable "sudo_prefix" {
    default = "sudo "
}

variable "region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "subnet_id" {
  default = "subnet-0952707821a56110c" // use one of our subnet ids as default doesn't exist
}

variable "vpc_id" {
  default = "vpc-0724304069772d554" // use one of our vpc ids as default doesn't exist
}
