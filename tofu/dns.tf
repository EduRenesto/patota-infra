resource "cloudflare_record" "rxnl-mc" {
  zone_id = var.cf_zone_id
  name = "mc.patota.online"
  value = oci_core_instance.rxnl-mc1.public_ip
  type = "A"
  ttl = 3600
}

resource "cloudflare_record" "rxnl-grafana" {
  zone_id = var.cf_zone_id
  name = "grafana.patota.online"
  value = oci_core_instance.rxnl-wdog.public_ip
  type = "A"
  ttl = 3600
}

# resource "cloudflare_record" "rouxinold" {
#   zone_id = var.cf_zone_id
#   name = "rouxinold.patota.online"
#   value = "1.2.3.4"
#   type = "A"
#   ttl = 3600
# }
