# PowerShell-PsAzureCli

## PowerShell wrapper for the Azure CLI

As functionality is added to the Azure PowerShell module and az CLI independently, there are often features which are supported in the az CLI long before they find their way in to the Azure PowerShell module. The purpose of this module is to provide support for using the az CLI within a PowerShell script, so you benefit from the full feature set of the az CLI with the flexibility of PowerShell.

At the time if writing this includes but is not limited to:
 * CosmosDB: Azure PowerShell can create an account, but cannot interact with databases or collections. In comparison the az CLI does support interacting with databases and collections 
 * Azure Kubernetes Service (Preview): Currently supported through az CLI only
 * Various others which I am not going to list right now...

It is a really basic implementation, but  it does provides a simple approach when it comes to performing actions which are supported by the az CLI but not in Azure PowerShell. 

## Features:
* Run any az CLI command easily in PowerShell
* Command parameters are defined using a hashtable
* Command switches are defined using an array
* Command responses can be parsed and returned as PowerShell objects
* Switch for disabling SSL validation to support a proxy, useful for debugging requests and responses

## Cmdlets
* **Install-AzCli**: Installs the **az cli** if it is not present
* **Invoke-AzureCli**: Executes an **az cli** command

## Installation:
```
Install-Module -Name PsAzureCli
```

## Setup:

Basically import the module, then authenticate with Azure, and point it at the desired subscription.
```
Import-Module -Name PsAzureCli
Invoke-AzureCli -ResourceType "login" -Parameters @{username = "username"; password = "password"}
Invoke-AzureCli -ResourceType "account" -Operation "set" -Parameters @{subscription = "yourAzureSubscriptionName"
}
```

## 'Invoke-AzureCli' Parameters:

* **-Path** (Optional): Specify the path to the az cli, defaults to "C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin\az.cmd
* **-ResourceType** (Required): The top level resource you are interacting with: az **vm** list
* **-Operation** (Optional): The next command block after ResourceType: az vm **list**
* **-ChildOperation** (Optional): The next command block after Operation: az ad user **create**
* **-Parameters** (Optional): A hashtable of the command parameters. Eg. @{'display-name' = "testUsername"; password = "testPassword"} is the equivilent to '**--display-name "test" --password "test"**'
* **-Switches** (Optional): An array of command switches. Eg. @('generate-ssh-keys') is the equivilent to '**--generate-ssh-keys**'
* **-PassThru** (Optional): If specified then the az cli json response will be deserialized in to a PowerShell object
* **-Verbose** (Optional): If specified then the output of the az cli command is outputted to console
* **-DisableSslVerification** (Optional): Disable the az cli SSL certificate verification for proxy support

## Usage examples:
```
# Create a resource group
Invoke-AzureCli -ResourceType "group" -Operation "create" -Parameters @{location="northeurope";name="ResourceGroup01"}

# Get resource groups
$ResourceGroups = Invoke-AzureCli -ResourceType "group" -Operation "list" -PassThru

# Create AKS cluster
$Parameters = @{
    location = "westeurope"
    name = "askcluster01"
    'node-count' = 3
    'node-vm-size' = "Standard_D2_v3"
    'resource-group' = "ResourceGroup01"
}
$Switches = @(
    'generate-ssh-keys'
)
Invoke-AzureCli -ResourceType "aks" -Operation "create" -Parameters $Parameters -Switches $Switches
```






