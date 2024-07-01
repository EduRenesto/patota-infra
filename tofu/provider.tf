variable "region" {
  default = "sa-saopaulo-1"
}

variable "tenancy_ocid" {
  default = "ocid1.tenancy.oc1..aaaaaaaaynhtffelvbs3rxrzftynrid6hoivssapk2khapbi5qorw2gycypa"
}

variable "user_ocid" {
  default = "ocid1.user.oc1..aaaaaaaa4oo64u6xmseirvaxqhl23zhepgw4a6rye67ciie6idqolyytob6q"
}

variable "fingerprint" {
  default = "bf:b6:9e:9e:20:49:64:c0:42:b0:ae:9e:2f:2b:62:4a"
}

variable "private_key_path" {
  default = "../rsa/renesto.pem"
}

terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      version = "6.0.0"
    }
  }
}

provider "oci" {
  region = "${var.region}"
  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  fingerprint = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
}
