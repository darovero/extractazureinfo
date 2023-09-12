param(
    [string]$resourceGroup,
    [string]$storageAccountName,
    [string]$blobName,
    [string]$outputFileName,
    [string]$storageContainerName,
    [string]$outputFilePath,
    [string]$storageAccountAccessKey
)

if (-not (Get-Module -Name Az.Storage -ListAvailable)) {
    Install-Module -Name Az.Storage -Force -AllowClobber
}

$storageContext = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountAccessKey
Set-AzStorageBlobContent -Context $storageContext -Container $storageContainerName -File $outputFilePath -Blob $blobName -Force