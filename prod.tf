terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.92.0"
    }
  }
}

# BEGIN AND SETUP
provider "azurerm" {
  features {}
}

variable "namePrefix" {
  type = list(string)
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.namePrefix[0]}"
  location = "eastus"

  tags = {
    "Terraform" : "true"
  }
}

# MAINLINE
# Create the Linux App Service Plan
resource "azurerm_app_service_plan" "appserviceplan" {
  name                = "appserviceplan-${var.namePrefix[0]}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  
  sku {
    tier = "Free"
    size = "F1"
  }

  tags = {
    "Terraform" : "true"
  }
}

# Create WebApps for HackingExercises
resource "azurerm_app_service" "HackingExercisesOne" {
  name                = "webapp-${var.namePrefix[0]}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  app_service_plan_id = azurerm_app_service_plan.appserviceplan.id

  source_control {
    repo_url           = "https://github.com/thomaskennedy1066/HackingExampleOne.git"
    branch             = "main"
    manual_integration = true
    use_mercurial      = false
  }

  tags = {
    "Terraform" : "true"
  }
}

resource "azurerm_app_service" "HackingExercisesTwo" {
  name                = "webapp-${var.namePrefix[1]}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  app_service_plan_id = azurerm_app_service_plan.appserviceplan.id

  source_control {
    repo_url           = "https://github.com/thomaskennedy1066/HackingExampleTwo.git"
    branch             = "main"
    manual_integration = true
    use_mercurial      = false
  }

  tags = {
    "Terraform" : "true"
  }
}
