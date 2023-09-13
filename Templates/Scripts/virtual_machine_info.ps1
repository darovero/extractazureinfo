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
    $properties = Get-VM -Name $vmsName

    # Tags
    $tags = $properties.Tags

    # Access Policies
    $accessPolicies = $properties.AccessPolicies

    # Certificates
    $certificates = Get-AzKeyVaultCertificate -VaultName $vmsName

    # Secrets
    $secrets = Get-AzKeyVaultSecret -VaultName $vaultName

    # Keys
    $keys = Get-AzKeyVaultKey -VaultName $vaultName

    # Append information to ExportContent
    $ExportContent += @"
Virtual Machine: $vaultName

Properties:
$($Properties | Select-Object -ExcludeProperty Tags,DiagnosticsProfile,HardwareProfile,NetworkProfile,SecurityProfile,OSProfile,StorageProfile | Format-List | Out-String -Width 4096)

Tags:
$($tags | Format-List | Out-String -Width 4096)
       
Access Policies:
$($accessPolicies | Select-Object TenantID,ObjectID,ApplicationID,DisplayName,@{n="PermissionsToKeys";e={$_.PermissionsToKeys -join ","}},@{n="PermissionsToKeysStr";e={$_.PermissionsToKeysStr -join ","}},@{n="PermissionsToSecrets";e={$_.PermissionsToSecrets -join ","}},@{n="PermissionsToSecretsStr";e={$_.PermissionsToSecretsStr -join ","}},@{n="PermissionsToCertificates";e={$_.PermissionsToCertificates -join ","}},@{n="PermissionsToCertificatesStr";e={$_.PermissionsToCertificatesStr -join ","}},@{n="PermissionsToStorage";e={$_.PermissionsToStorage -join ","}},@{n="PermissionsToStorageStr";e={$_.PermissionsToStorageStr -join ","}} | Format-List | Out-String -Width 4096)

Certificates:
$($certificates | Select-Object VaultName,Name,Id,Created,Updated,NotBefore,Expires | Format-List | Out-String -Width 4096)

Secrets:
$($secrets | Select-Object VaultName,Name,Id,Created,Updated | Format-List | Out-String -Width 4096)

Keys:
$($keys | Select-Object VaultName,Name,KeyType,KeySize,Version,Id,Enabled,Created,Updated,NotBefore,Expires,RecoveryLevel,ReleasePolicy | Format-List | Out-String -Width 4096)

"@
}

# Export the information to a text file
$ExportContent | Out-File -FilePath $outputFilePath -Encoding UTF8
