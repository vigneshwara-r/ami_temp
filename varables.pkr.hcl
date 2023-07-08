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
  default = "t4g.small"
}

variable "subnet_id" {
  default = "subnet-095497428d36194f8" // use one of our subnet ids as default doesn't exist
}

variable "vpc_id" {
  default = "vpc-0d97a4b111464b842" // use one of our vpc ids as default doesn't exist
}
