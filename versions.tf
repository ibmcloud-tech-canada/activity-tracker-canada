##############################################################################
# Terraform Providers
##############################################################################

terraform {
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "~>1.51"
    }
  }
  required_version = "~>1.0"
}


# Uncomment ibmcloud_api_key if you want to pass it as variable
provider "ibm" {
 ibmcloud_api_key = var.ibmcloud_api_key
 region = "ca-tor"
}

##############################################################################

