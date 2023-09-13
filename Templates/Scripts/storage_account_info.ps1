param(
    [string]$resourceGroup,
    [string]$outputFilePath
)

# Get Web Site in Resource Group
$stoacc = Get-AzResource -ResourceGroupName $resourcegroup -ResourceType Microsoft.Storage/storageAccounts
        
# Initialize content variable
$ExportContent = ""

# Loop through each Storage Account
foreach ($sto in $stoacc) {
    $stoName = $sto.Name

    # Get Properties
    $properties = Get-AzStorageAccount -ResourceGroupName $resourcegroup -Name $stoName

    # Tags
    $tags = $properties.Tags

    # Sku
    $sku = $properties.Sku

    # KeyCreationTime
    $KeyCreationTime = $properties.KeyCreationTime

    # PrimaryEndpoints
    $PrimaryEndpoints = $properties.PrimaryEndpoints

    # NetworkRuleSet
    $NetworkRuleSet = $properties.NetworkRuleSet

    # Context
    $Context = $properties.Context

    # Append information to ExportContent
    $ExportContent += @"
Storage Account: $stoName

Properties:
$($Properties | Select-Object -ExcludeProperty KeyCreationTime,Sku,Encryption,PrimaryEndpoints,Tags,NetworkRuleSet,Context,ExtendedProperties | Format-List | Out-String -Width 4096)

Tags:
$($tags | Format-List | Out-String -Width 4096)
       
Sku:
$($Sku | Format-List | Out-String -Width 4096)

KeyCreationTime:
$($KeyCreationTime | Format-List | Out-String -Width 4096)

PrimaryEndpoints:
$($PrimaryEndpoints | Format-List | Out-String -Width 4096)

NetworkRuleSet:
$($NetworkRuleSet | Format-List | Out-String -Width 4096)

Context:
$($Context | Format-List | Out-String -Width 4096)

"@
}

# Export the information to a text file
$ExportContent | Out-File -FilePath $outputFilePath -Encoding UTF8
