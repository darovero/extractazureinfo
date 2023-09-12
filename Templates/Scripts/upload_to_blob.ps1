param(
    [string]$resourceGroup,
    [string]$storageAccountName,
    [string]$outputFileName,
    [string]$storageContainerName,
    [string]$storageAccountKey
)

if (-not (Get-Module -Name Az.Storage -ListAvailable)) {
    Install-Module -Name Az.Storage -Force -AllowClobber
}

$filePath = '$resourceGroup_$outputFileName'
$blobName = '$containerName/$resourceGroup_$outputFileName'

$storageContext = New-AzStorageContext -StorageAccountName $(storageAccountName) -StorageAccountKey $(storageAccountAccessKey)
Set-AzStorageBlobContent -Context $storageContext -Container $(storageContainerName) -File $filePath -Blob $blobName -Force