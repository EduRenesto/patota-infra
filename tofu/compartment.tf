resource "oci_identity_compartment" "patota-compartment" {
  compartment_id = "${var.tenancy_ocid}"
  description = "Compartiment for Patota cloud endeavors."
  name = "patota"
}

output "compartment-name" {
  value = oci_identity_compartment.patota-compartment.name
}

output "compartment-ocid" {
  value = oci_identity_compartment.patota-compartment.id
}
