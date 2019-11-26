resource "azurerm_resource_group" "tfm-webapps" {
    name = "tfm-webapps"
    location = "${var.loc}"
    tags = "${var.tags}"
}

resource "random_string" "webapprnd" {
  length  = 8
  lower   = true
  number  = true
  upper   = false
  special = false
}

resource "azurerm_app_service_plan" "free" {
    count               = "${length(var.webapplocs)}"
    # count = the number of resources made, or the number of times this resource is made
    name                = "plan-free-${var.webapplocs[count.index]}"
    location            = "${var.webapplocs[count.index]}"
    resource_group_name = "${azurerm_resource_group.tfm-webapps.name}"
    tags                = "${azurerm_resource_group.tfm-webapps.tags}"

    kind                = "Linux"
    reserved            = true
    sku {
        tier = "Free"
        size = "F1"
    }
}

resource "azurerm_app_service" "citadel" {
    count               = "${length(var.webapplocs)}"
    name                = "webapp-${random_string.webapprnd.result}-${var.webapplocs[count.index]}"
    location            = "${var.webapplocs[count.index]}"
    resource_group_name = "${azurerm_resource_group.tfm-webapps.name}"
    tags                = "${azurerm_resource_group.tfm-webapps.tags}"

    app_service_plan_id = "${element(azurerm_app_service_plan.free.*.id, count.index)}"
    # element = returns a specific item (element) in an array
}

output "webapp_ids" {
  value = "${azurerm_app_service.citadel.*.id}"
}