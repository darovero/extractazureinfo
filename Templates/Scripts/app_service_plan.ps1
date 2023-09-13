param(
    [string]$resourceGroup,
    [string]$outputFilePath
)

# Get Function Apps in Resource Group
$FunctionApps = Get-AzResource -ResourceGroupName $resourcegroup -ResourceType Microsoft.Web/sites

# Initialize content variable
$ExportContent = ""

# Loop through each Key Vault
foreach ($functapp in $FunctionApps) {
    $functappName = $functapp.Name

    # Get Properties
    $properties = Get-AzFunctionApp -ResourceGroupName $resourcegroup -Name $functappName
    
    # Get Application Settings
    $applicationsettings = $properties.ApplicationSettings

    # Get Site Config
    $siteconfig = $properties.SiteConfig

    # Get App Service Plan
    $appserviceplan = Get-AzFunctionAppPlan -ResourceGroupName $resourcegroup

# Append information to ExportContent
$ExportContent += @"
Function Apps: $functappName

Properties: 
$($properties | Select-Object Name,Runtime,OSType,AppServicePlan,AvailabilityState,ClientCertEnabled,DefaultHostName,Enabled,EnabledHostName,HostName,HostNameSslState,HostNamesDisabled,HttpsOnly,HyperV,Id,Kind,LastModifiedTimeUtc,Location,MaxNumberOfWorker,OutboundIPAddress,PossibleOutboundIPAddress,RedundancyMode,RepositorySiteName,Reserved,ResourceGroup,ScmSiteAlsoStopped,ServerFarmId,State,Type,UsageState,Status,SubscriptionId  | Format-List | Out-String -Width 4096)

Application Settings:
$($applicationsettings | Format-List | Out-String -Width 4096)

Site Config:
$($siteconfig | Format-List | Out-String -Width 4096)

App Service Plan
$($appserviceplan | Select-Object Name,WorkerType,Location,Id,MaximumElasticWorkerCount,MaximumNumberOfWorker,PerSiteScaling,ProvisioningState,Reserved,ResourceGroup,SkuName,SkuSize,SkuTier,Status,Subscription,Type | Out-String -Width 4096)

"@
}

# Export the information to a text file
$ExportContent | Out-File -FilePath $outputFilePath -Encoding UTF8