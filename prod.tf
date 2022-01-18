terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.92.0"
    }
  }
}

provider "azurerm" {
  features {}
}

#
## Create a resource group
#resource "azurerm_resource_group" "HackingExerciseOne" {
#  name     = "HackingExerciseOne"
#  location = "East US"
#
#  tags = {
#    "Terraform" : "true"
#  }
#}
#
#
#resource "azurerm_app_service_plan" "HackingExerciseOne" {
#  name                = "HackingExerciseOne-appserviceplan"
#  location            = azurerm_resource_group.HackingExerciseOne.location
#  resource_group_name = azurerm_resource_group.HackingExerciseOne.name
#
#  sku {
#    tier = "Free"
#    size = "F1"
#  }
#
#  tags = {
#    "Terraform" : "true"
#  }
#}
#
#resource "azurerm_app_service" "HackingExerciseOne" {
#  name                = "HackingExerciseOne-app-service"
#  location            = azurerm_resource_group.HackingExerciseOne.location
#  resource_group_name = azurerm_resource_group.HackingExerciseOne.name
#  app_service_plan_id = azurerm_app_service_plan.HackingExerciseOne.id
#
#  site_config {
#    dotnet_framework_version = "v4.0"
#    #scm_type                 = "VSTSRM"
#  }
#
#  source_control {
#    repo_url           = "https://github.com/thomaskennedy1066/HackingExampleOne.git"
#    branch             = "main"
#    manual_integration = true
#  }
#
#
#
#  tags = {
#    "Terraform" : "true"
#  }
#}

variable "namePrefix" {
  type = string
}

# Create the resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.namePrefix}"
  location = "eastus"

  tags = {
    "Terraform" : "true"
  }
}

# Create the Linux App Service Plan
resource "azurerm_app_service_plan" "appserviceplan" {
  name                = "appserviceplan-${var.namePrefix}"
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

# Create the web app, pass in the App Service Plan ID, and deploy code from a public GitHub repo
resource "azurerm_app_service" "HackingExerciseOne" {
  name                = "webapp-${var.namePrefix}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  app_service_plan_id = azurerm_app_service_plan.appserviceplan.id
  
  source_control {
    repo_url           = "https://github.com/thomaskennedy1066/nodejs-docs-hello-world.git"
    branch             = "master"
    manual_integration = true
    use_mercurial      = false
  }

  tags = {
    "Terraform" : "true"
  }
}