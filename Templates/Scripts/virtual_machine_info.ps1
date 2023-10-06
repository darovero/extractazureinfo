param(
    [string]$resourceGroup,
    [string]$outputFilePath
)

# Get Virtual Machine in Resource Group
$virtualMachines = Get-AzResource -ResourceGroupName $resourcegroup -ResourceType Microsoft.Compute/virtualMachines
        
# Initialize content variable
$ExportContent = ""

# Loop through each Virtual Machine
foreach ($vms in $virtualMachines) {
    $vmsName = $vms.Name

    # Get Properties
    $properties = Get-AzVM -Name $vmsName

    # Tags
    $tags = $properties.Tags

    # Diagnostics Profile
    $diagnosticsprofile = $properties.DiagnosticsProfile.BootDiagnostics

    # Hardware Profile
    $hardwareprofile = $properties.HardwareProfile

    # Network Profile
    $networkprofile = $properties.NetworkProfile

    # Keys
    $keys = Get-AzKeyVaultKey -VaultName $vaultName

    # Append information to ExportContent
    $ExportContent += @"
Virtual Machine: $vaultName

Properties:
$($Properties | Select-Object -ExcludeProperty Tags,DiagnosticsProfile,HardwareProfile,NetworkProfile,SecurityProfile,OSProfile,StorageProfile | Format-List | Out-String -Width 4096)

Tags:
$($tags | Format-List | Out-String -Width 4096)
       
Diagnostics Profile:
 $($diagnosticsprofile | Select-Object | Format-List | Out-String -Width 4096)

Hardware Profile:
$($hardwareprofile | Select-Object VaultName,Name,Id,Created,Updated,NotBefore,Expires | Format-List | Out-String -Width 4096)

Network Profile:
$($networkprofile | Select-Object VaultName,Name,Id,Created,Updated | Format-List | Out-String -Width 4096)

Keys:
$($keys | Select-Object VaultName,Name,KeyType,KeySize,Version,Id,Enabled,Created,Updated,NotBefore,Expires,RecoveryLevel,ReleasePolicy | Format-List | Out-String -Width 4096)

"@
}

# Export the information to a text file
$ExportContent | Out-File -FilePath $outputFilePath -Encoding UTF8
