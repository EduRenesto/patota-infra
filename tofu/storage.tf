resource "oci_core_volume" "mc1_storage" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id = oci_identity_compartment.patota-compartment.id

  display_name = "mc1_storage"

  # min is 50 GB... waste, i know
  size_in_gbs = 50
}

resource "oci_core_volume_attachment" "mc1_storage_att" {
  attachment_type = "paravirtualized"
  display_name = "mc1_storage_att"

  instance_id = oci_core_instance.rxnl-mc1.id

  is_read_only = false

  volume_id = oci_core_volume.mc1_storage.id
}
