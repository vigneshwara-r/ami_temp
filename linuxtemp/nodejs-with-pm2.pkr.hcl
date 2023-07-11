packer {
    required_plugins {
        amazon = {
            version = " >= 0.0.2"
            source = "github.com/hashicorp/amazon"
        }
        docker = {
            version = " >= 0.0.7"
            source = "github.com/hashicorp/docker"
        }
    }
}

locals {
    machine_name = format("linuxserver-%s", formatdate("YYYY-MM-DD-hh-mm-ss", timestamp()))
}

source "docker" "amazonlinux" {
    image = "amazonlinux"
    commit = true
}

source "amazon-ebs" "linux" {
    ami_name = local.machine_name
    instance_type = var.instance_type
    region = var.region
    source_ami_filter {
        filters = {
            name = "al2023-ami-2023.1.20230705.0-kernel-6.1-x86_64"
            root-device-type = "ebs"
            virtualization-type = "hvm"
        }
        most_recent = true
        owners = ["amazon"]
    }
    tags = {
        "Name" = local.machine_name
    }
    subnet_id = var.subnet_id 
    vpc_id = var.vpc_id 
    ssh_username = "ec2-user"
    temporary_key_pair_type = "ed25519"
}

build {
    name = "Build Amazon Linux for HTTPD"
    sources = [var.build_sources]

    provisioner "file" {
        source = "scripts/"
        destination = "/tmp"
    }
    
    provisioner "shell" {
        inline = [
            "chmod +x /tmp/install-dependencies-security.sh",
            "${var.sudo_prefix}/tmp/install-dependencies-security.sh"
        ]
    }
    provisioner "shell" {
        script = "scripts/starting-httpd.sh"
    }
    provisioner "shell" {
	script = "scripts/content-httpd.sh"
    }

    post-processor "docker-tag" {
        repository = local.machine_name
        tags = ["latest"]
        only= ["docker.amazonlinux"]
    }
}
