param(
    [string]$resourceGroup,
    [string]$outputFilePath
)

# Get App Service Plan in Resource Group
$appServiceplan = Get-AzResource -ResourceGroupName $resourcegroup -ResourceType Microsoft.Web/serverFarms
        
# Initialize content variable
$ExportContent = ""

# Loop through each ASP
foreach ($asp in $appServiceplan) {
    $aspName = $asp.Name

    # Get Properties
    $properties = Get-AzAppServicePlan -ResourceGroupName $resourcegroup -Name $aspName

    # Tags
    $tags = $properties.Tags

    # Sku
    $sku = $properties.sku

    # Append information to ExportContent
    $ExportContent += @"
App Service Plan: $aspName

Properties:
$($Properties | Select-Object WorkerTierName,Status,Subscription,HostingEnvironmentProfile,MaximumNumberOfWorkers,GeoRegion,PerSiteScaling,ElasticScaleEnabled,MaximumElasticWorkerCount,NumberOfSites,IsSpot,SpotExpirationTime,FreeOfferExpirationTime,ResourceGroup,Reserved,IsXenon,HyperV,TargetWorkerCount,TargetWorkerSizeId,ProvisioningState,KubeEnvironmentProfile,ExtendedLocation,Id,Name,Kind,Location | Format-List | Out-String -Width 4096)

Tags:
$($tags | Format-List | Out-String -Width 4096)
       
Sku:
$($sku | Format-List | Out-String -Width 4096) 

"@
}

# Export the information to a text file
$ExportContent | Out-File -FilePath $outputFilePath -Encoding UTF8
