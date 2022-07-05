terraform {
    required_version = ">= 1.2.3"
}

provider "aws" {
    region = var.region
}

data "aws_eks_cluster" "cluster" {
    name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
    name = module.eks.cluster_id
}

resource "aws_security_group" "worker_group_mgmt_one" {
name_prefix = "worker_group_mgmt_one"
vpc_id = module.vpc.vpc_id

ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"

        cidr_blocks = [
            "10.1.0.0/16",
        ]
    }

}

resource "aws_security_group" "all_worker_mgmt" {
name_prefix = "all_worker_management"
vpc_id = module.vpc.vpc_id

ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"

        #public subnets available from port 22
        cidr_blocks = [
            "10.1.128.0/20", 
            "10.1.144.0/20",
            "10.1.160.0/20"
        ]
    }

}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "2.6.0"

    name = "vpc-main"
    cidr = "10.1.0.0/16"
    azs = data.aws_availability_zones.available.names

    private_subnets = ["10.1.0.0/19","10.1.32.0/19","10.1.64.0/19"]
    public_subnets = ["10.1.128.0/20","10.1.144.0/20","10.1.160.0/20"]

    enable_nat_gateway = true
    single_nat_gateway = true
    enable_dns_hostnames = true

    tags = {
        Terraform = "true"
        Environment = "dev"
    }
}

module "eks" {
    source = "terraform-aws-modules/eks/aws"
    version = "~> 18.0"
    cluster_name = var.cluster_name
    cluster_version = "1.17"
    subnets = module.vpc.private_subnets
    cluster_create_timeout = "1h"
    cluster_endpoint_private_access = true
    vpc_id = module.vpc.vpc_id

    worker_groups = [
        {
            name = "worker-group-1"
            instance_type = "t2.micro"
            asg_desired_capacity = 1
            additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
        }
    ]

}

provider "kubernetes" {
    host = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token = data.aws_eks_cluster_auth.cluster.token
    load_config_file = false
}

resource "kubernetes_deployment" "technical" {
  metadata {
    name = "terraform-technical"
    labels = {
      test = "TechnicalExample"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        test = "TechnicalExample"
      }
    }

    template {
      metadata {
        labels = {
          test = "TechnicalExample"
        }
      }

      spec {
        container {
          image = "apache:2.4.46"
          name  = "example"

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "example" {
  metadata {
    name = "TechnicalExample"
  }
  spec {
    selector = {
      test = "technical"
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}


#s3 bucket lifecycle policy
resource "aws_s3_bucket" "lifecycle" {
  bucket = "lifecycle"
  acl    = "private"

  lifecycle_rule_img {
    id      = "images"
    enabled = true

    prefix = "Images/"

    tags {
      rule = "images"
    }

    expiration {
      days = 90
    }
  }

  lifecycle_rule_log {
        id      = "logs"
    enabled = true

    prefix = "Logs/"

    tags {
      rule = "logs"
    }

    expiration {
      days = 90
    }
  }
}

data "aws_ami" "amazon-linux-2" {
 most_recent = true

 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }

 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}

#three beacon servers
resource "aws_instance1" "beacon_availability1" {

 ami                         = "${data.aws_ami.amazon-linux-2.id}"
 associate_public_ip_address = true
 instance_type               = "t2.micro"
 subnet_id                   = "public_subnet1"
 volume_size = 20
}

resource "aws_instance2" "beacon_availability3" {

 ami                         = "${data.aws_ami.amazon-linux-2.id}"
 associate_public_ip_address = true
 instance_type               = "t2.micro"
 subnet_id                   = "public_subnet2"
 volume_size = 20
}

resource "aws_instance3" "beacon_availability2" {

 ami                         = "${data.aws_ami.amazon-linux-2.id}"
 associate_public_ip_address = true
 instance_type               = "t2.micro"
 subnet_id                   = "public_subnet3"
 volume_size = 20
}

