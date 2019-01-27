output "lb_id" {
  description = "the id for the azurerm_lb resource"
  value       = "${azurerm_lb.loadbalancer.id}"
}

output "lb_frontend_ip_configuration" {
  description = "the frontend_ip_configuration for the azurerm_lb resource"
  value       = "${azurerm_lb.loadbalancer.frontend_ip_configuration}"
}

output "lb_nat_rule_ids" {
  description = "the ids for the azurerm_lb_nat_rule resources"
  value       = "${azurerm_lb_nat_rule.loadbalancer_nat_rule.*.id}"
}

output "lb_backend_address_pool_id" {
  description = "the id for the azurerm_lb_backend_address_pool resource"
  value       = "${azurerm_lb_backend_address_pool.loadbalancer_backend_address_pool.id}"
}
