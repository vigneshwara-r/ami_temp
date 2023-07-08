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
    machine_name = format("pm-com-nodejs-with-pm2-datadog-%s", formatdate("YYYY-MM-DD-hh-mm-ss", timestamp()))
    sudo = "sudo "
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
            name = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-20230516"
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
    ssh_username = "ubuntu"
    temporary_key_pair_type = "ed25519"
}

build {
    name = "Build Amazon Linux for PM-COM"
    sources = [var.build_sources]

    provisioner "shell" {
        script = "scripts/create-directory.sh"
    }

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
        script = "scripts/setup-start-webserver.sh"
    }

    provisioner "shell" {
        inline = [
            "chmod +x /tmp/install-webserver.sh",
            "${var.sudo_prefix}/tmp/install-webserver.sh"
        ]
        only = ["amazon-ebs.linux"]
    }

    post-processor "docker-tag" {
        repository = local.machine_name
        tags = ["latest"]
        only= ["docker.amazonlinux"]
    }
}