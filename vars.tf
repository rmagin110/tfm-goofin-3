variable "loc" {
    description = "Default Region"
    default = "eastus"
}

variable "tags" {
    default     = {
        source = "citadel"
        env = "training"
    }
}

variable "tenant_id-UFCU_Dev-Test_Local" {
    # az ad sp show --id "http://terraformKeyVaultReader" --output tsv --query appOwnerTenantId
    description = "GUID for the Azure AD tenancy or directory"
    default = "c0485409-6417-4a7f-bb35-d4ab8ba44e80" 
}

variable "webapplocs" {
    description = "List of locations for web apps"
    type        = "list"
    default     = []
}