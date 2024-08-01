module "vcn" {
  source = "oracle-terraform-modules/vcn/oci"
  compartment_id = oci_identity_compartment.patota-compartment.id

  region = "${var.region}"

  internet_gateway_route_rules = null
  local_peering_gateways = null
  nat_gateway_route_rules = null

  vcn_name = "patotanet-vcn"
  vcn_dns_label = "patota"
  vcn_cidrs = ["10.0.0.0/16"]

  create_internet_gateway = true
  create_nat_gateway = true
  create_service_gateway = true
}

resource "oci_core_security_list" "patotanet-public-security-list" {
  compartment_id = oci_identity_compartment.patota-compartment.id
  vcn_id = module.vcn.vcn_id

  display_name = "patotanet-public-security-list"

  egress_security_rules {
    stateless = false
    destination = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol = "all"
  }

  # Allow SSH (22)
  ingress_security_rules {
    stateless = false
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol = "6" # 6 is TCP

    tcp_options {
      min = 22
      max = 22
    }
  }

  # Allow Minecraft (25565)
  ingress_security_rules {
    stateless = false
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol = "6" # 6 is TCP

    tcp_options {
      min = 25565
      max = 25575
    }
  }

  ingress_security_rules {
    stateless = false
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol = "6" # 6 is TCP

    tcp_options {
      min = 80
      max = 80
    }
  }

  # Allow Loki, Prometheus
  ingress_security_rules {
    stateless = false
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol = "6" # 6 is TCP

    tcp_options {
      min = 3001
      max = 3002
    }
  }
}

resource "oci_core_subnet" "patotanet-public-subnet" {
  compartment_id = oci_identity_compartment.patota-compartment.id
  vcn_id = module.vcn.vcn_id
  cidr_block = "10.0.0.0/24"

  route_table_id = module.vcn.ig_route_id
  security_list_ids = [ oci_core_security_list.patotanet-public-security-list.id ]
  display_name = "patotanet-public-subnet"
}
