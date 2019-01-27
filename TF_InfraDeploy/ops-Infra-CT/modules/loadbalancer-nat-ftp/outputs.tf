output "lb_nat_rule_ids" {
  description = "the ids for the azurerm_lb_nat_rule resources"
  value       = "${azurerm_lb_nat_rule.loadbalancer_nat_rule_ftp.*.id}"
}
