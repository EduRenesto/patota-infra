resource "oci_core_instance" "mc1_server" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id = oci_identity_compartment.patota-compartment.id

  # shape = "VM.Standard.A1.Flex"
  # shape_config {
  #   ocpus = 2
  #   memory_in_gbs = 2
  # }
  # source_details {
  #   # Ubuntu 22.04 Minimal aarch64
  #   source_id = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaatzk6r6llclqeyxqkko72f2yfjgk3slcfuvygcedyzzc43u73rqnq"
  #   source_type = "image"
  # }

  shape = "VM.Standard.E2.1.Micro"
  source_details {
    source_id = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaa5dnsil74ysi3u4f7ajk4aoujv3fvxppbsdxi4onu3ss54ahgwmva"
    source_type = "image"
  }

  display_name = "mc1_server"
  create_vnic_details {
    assign_public_ip = true
    subnet_id = oci_core_subnet.patotanet-public-subnet.id
  }

  metadata = {
    ssh_authorized_keys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINoMBnGCHBcsy+gagZOKhDSVRGS8gDCsYJLbKa2P8FH7 edu@Edus-MacBook-Pro.local"
  }

  preserve_boot_volume = false
}

output "mc1_server-ip" {
  value = oci_core_instance.mc1_server.public_ip
}
