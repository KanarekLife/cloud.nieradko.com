resource "oci_budget_budget" "kanareklifecloud-budget" {
  display_name   = "oci-budget"
  amount         = 1
  compartment_id = var.root_compartment_id
  targets        = [var.root_compartment_id]
  reset_period   = "MONTHLY"
}

resource "oci_budget_alert_rule" "kanareklifecloud-budgetalertrule" {
  budget_id      = oci_budget_budget.kanareklifecloud-budget.id
  threshold      = 1
  threshold_type = "ABSOLUTE"
  type           = "FORECAST"

  display_name = "oci-budgetalert"
  message      = "Over 1 USD will be spent!"
  recipients   = "stanislaw@nieradko.com"
}
