<#
.SYNOPSIS
This script updates Azure resource tags based on data imported from an Excel file.

.DESCRIPTION
The script takes input parameters such as run mode, subscription ID, and Azure VM tag names. It imports data from an Excel file, loops through each row in the data, and updates the tags of Azure resources based on the specified run mode. The script also provides logging and error handling.

.PARAMETER RunMode
Specifies the run mode of the script. Valid values are 1 (real run), 2 (dry run), and 3 (export resources).

.PARAMETER SubscriptionId
Specifies the Azure subscription ID to log in to.

.PARAMETER Debug
Switch parameter to enable debug mode.

.PARAMETER AzureVMTagNames
Specifies an array of Azure VM tag names to update.

.EXAMPLE
.\b.ps1 -RunMode 1 -SubscriptionId "12345678-90ab-cdef-ghij-klmnopqrstuv" -Debug -AzureVMTagNames "Tag1", "Tag2"

This example runs the script in real mode, logs in to the Azure subscription with the specified ID, enables debug mode, and updates the specified Azure VM tag names.

.NOTES
- This script requires the Az and ImportExcel modules to be installed.
- The Excel file must be in the same directory as the script and named "file.xlsx".
- The script logs execution time and errors to a log file named "log.txt" in the script directory.
#>

# Import the required modules
Import-Module Az
Import-Module ImportExcel

# Variables
$XlsxFilePath = Join-Path -Path $PSScriptRoot -ChildPath "file.xlsx"

# Set up logging
$LogFilePath = Join-Path -Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -ChildPath "log.txt"
function Write-LogMessage($Message) {
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "$Timestamp - $Message"
    $LogMessage | Out-File -FilePath $LogFilePath -Append
    Write-Host $LogMessage
}

# Start timer
$StartTime = Get-Date

# Login to Azure if SubscriptionId is provided
function Get-AzureAccount($SubscriptionId) {
    if ($SubscriptionId) {
        Connect-AzAccount -SubscriptionId $SubscriptionId
    }
}

# Import data from XLSX file
function Get-DataFromExcel($XlsxFilePath) {
    try {
        $Data = Import-Excel -Path $XlsxFilePath
        return $Data
    }
    catch {
        Write-LogMessage "Failed to import data from XLSX file: $_"
        return $null
    }
}

# Update Azure resource tags
function Update-AzureResourceTags($RunMode, $Data, $AzureVMTagNames) {
    # Prompt for run mode if not provided
    if (-not $RunMode) {
        $RunMode = Read-Host "Enter run mode (1 for real run, 2 for dry run, 3 to export resources):"
    }

    # Loop through each row in the data
    foreach ($Row in $Data) {
        if ($Row.Type -eq "azure virtual machine") {
            $AzureVMName = $Row.Name

            # Loop through each Azure VM tag name
            foreach ($AzureVMTagName in $AzureVMTagNames) {
                # Get the Azure resources that start with the Azure VM name and type is not "azure virtual machine"
                $AzureResources = $Data | Where-Object { $_.Name -like "$AzureVMName*" -and $_.Type -ne "azure virtual machine" }

                # Loop through each Azure resource
                foreach ($AzureResource in $AzureResources) {
                    # Check if the tag value is empty, N/A, or does not exist
                    if (-not $AzureResource.Tags.ContainsKey($AzureVMTagName) -or
                        [string]::IsNullOrEmpty($AzureResource.Tags[$AzureVMTagName]) -or
                        $AzureResource.Tags[$AzureVMTagName] -eq "N/A") {

                        # Assign the new tag value based on run mode
                        switch ($RunMode) {
                            1 {
                                Update-TagForRealRun $AzureResource $AzureVMTagName $Row.ApplicationService
                            }
                            2 {
                                Update-TagForDryRun $AzureResource $AzureVMTagName
                            }
                            3 {
                                Export-ResourceDetailsToExcel $AzureResource $AzureVMTagName $Row.ApplicationService
                            }
                            default {
                                Write-LogMessage "Invalid run mode. Exiting..."
                                return
                            }
                        }
                    }
                }
            }
        }
    }
}

# Update tag for real run
function Update-TagForRealRun($AzureResource, $AzureVMTagName, $ApplicationService) {
    try {
        $AzureResource.Tags[$AzureVMTagName] = $ApplicationService
        $AzureResource | Set-AzResource -Force
        if ($Debug) {
            Write-LogMessage "Updated tag for $($AzureResource.ResourceId)"
        }
    }
    catch {
        Write-LogMessage "Failed to update tag for $($AzureResource.ResourceId): $_"
    }
}

# Update tag for dry run
function Update-TagForDryRun($AzureResource, $AzureVMTagName) {
    if ($Debug) {
        Write-LogMessage "Dry run: Would update tag for $($AzureResource.ResourceId)"
    }
}

# Export resource details to Excel
function Export-ResourceDetailsToExcel($AzureResource, $AzureVMTagName, $ApplicationService) {
    try {
        $ResourceDetails = [PSCustomObject]@{
            Name = $AzureResource.Name
            ResourceId = $AzureResource.ResourceId
            ApplicationService = $ApplicationService
        }
        $ResourceDetails | Export-Excel -Path $XlsxFilePath -WorksheetName "Resource Details" -AutoSize -Append
        if ($Debug) {
            Write-LogMessage "Exported resource details to Excel for $($AzureResource.ResourceId)"
        }
    }
    catch {
        Write-LogMessage "Failed to export resource details to Excel: $_"
    }
}

# Calculate execution time
function Measure-ExecutionTime($StartTime) {
    $EndTime = Get-Date
    $ExecutionTime = New-TimeSpan -Start $StartTime -End $EndTime
    $ExecutionTimeMinutes = $ExecutionTime.TotalMinutes

    # Log execution time
    Write-LogMessage "Total execution time: $ExecutionTimeMinutes minutes"
}

# Main script logic
param (
    [CmdletBinding()]
    [int]$RunMode = 0,
    [string]$SubscriptionId = "",
    [switch]$Debug,
    [string[]]$AzureVMTagNames
)

# Calculate execution time
Measure-ExecutionTime $StartTime
$ScriptPath = $MyInvocation.MyCommand.Path
$UserName = $env:USERNAME
$ComputerName = $env:COMPUTERNAME
$PowerShellVersion = $PSVersionTable.PSVersion.ToString()
$PowerShellPlatform = $env:PROCESSOR_ARCHITECTURE

$Summary = @"
Script Path: $ScriptPath
User: $UserName
Computer Name: $ComputerName
PowerShell Version: $PowerShellVersion
PowerShell Platform: $PowerShellPlatform
"@

Write-Host $Summary

# Login to Azure
Get-AzureAccount $SubscriptionId

# Import data from XLSX file
$Data = Get-DataFromExcel $XlsxFilePath

# Update Azure resource tags
Update-AzureResourceTags $RunMode $Data $AzureVMTagNames
