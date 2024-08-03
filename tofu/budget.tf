resource "oci_budget_budget" "julius" {
  amount = "150"
  compartment_id = var.tenancy_ocid
  reset_period = "MONTHLY"
  target_type = "COMPARTMENT"
  targets = [ oci_identity_compartment.patota-compartment.id ]
}

resource "oci_budget_alert_rule" "julius_alert" {
  budget_id = oci_budget_budget.julius.id
  threshold = 80
  threshold_type = "PERCENTAGE"
  type = "ACTUAL"
}
