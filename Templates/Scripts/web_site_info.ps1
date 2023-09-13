param(
    [string]$resourceGroup,
    [string]$outputFilePath
)

# Get Web Site in Resource Group
$website = Get-AzResource -ResourceGroupName $resourcegroup -ResourceType Microsoft.Web/sites
        
# Initialize content variable
$ExportContent = ""

# Loop through each Web Site
foreach ($web in $website) {
    $webName = $web.Name

    # Get Properties
    $properties = Get-AzWebApp -ResourceGroupName $resourcegroup -Name $webName

    # Tags
    $tags = $properties.Tags

    # SiteConfig
    $siteconfig = $properties.SiteConfig

    # AppSettings
    $appsettings = $properties.SiteConfig.AppSettings

    # VirtualApplications
    $virtualapplications = $properties.SiteConfig.VirtualApplications

    # Cors
    $cors = $properties.SiteConfig.Cors 

    # Append information to ExportContent
    $ExportContent += @"
Web Site: $webName

Properties:
$($Properties | Select-Object -ExcludeProperty Tags,SiteConfig | Format-List | Out-String -Width 4096)

Tags:
$($tags | Format-List | Out-String -Width 4096)
       
SiteConfig:
$($SiteConfig | Select-Object -ExcludeProperty DefaultDocuments,AppSettings,VirtualApplications,Experiments,Cors | Format-List | Out-String -Width 4096)

AppSettings:
$($appsettings | Format-List | Out-String -Width 4096)

VirtualApplications:
$($virtualapplications | Format-List | Out-String -Width 4096)

Cors:
$($Cors | Format-List | Out-String -Width 4096)

"@
}

# Export the information to a text file
$ExportContent | Out-File -FilePath $outputFilePath -Encoding UTF8
