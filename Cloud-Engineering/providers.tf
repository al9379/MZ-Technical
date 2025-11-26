provider "aws"{
    profile = "default"
    region = var.region
}

terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = ">= 6.0.0"
        }
        tls = {
            source  = "hashicorp/tls"
            version = ">= 4.0.0"
        }
    }
}