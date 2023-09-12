param(
    [string]$resourceGroup,
    [string]$containerName,
    [string]$blobName,
    [string]$storageAccountName,
    [string]$outputFileName,
    [string]$storageAccountKey
)

if (-not (Get-Module -Name Az.Storage -ListAvailable)) {
    Install-Module -Name Az.Storage -Force -AllowClobber
}
$context = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey

$localFilePath = "$resourceGroup_outputFileName"

Set-AzStorageBlobContent -Context $context -Container $containerName -File $localFilePath -Blob $blobName -Force

Write-Host "The file $localFilePath has been uploded to the $containerName container with the name blob $blobName."