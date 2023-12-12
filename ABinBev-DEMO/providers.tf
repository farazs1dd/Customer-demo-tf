# Initiate required Providers

terraform {
  required_providers {
    prosimo = {
      source  = "prosimo-io/prosimo"
      version =  "~> 3.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}


provider "aws" {
  region = "eu-west-1"
  alias = "eu-west-1"
  profile = "default"
}

provider "aws" {
  region = "eu-west-2"
  alias  = "eu-west-2"
  profile = "default"
}

