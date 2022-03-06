#*****************************************************
# This script gets services running on the local machine
# and writes the output to Azure Table Storage
#
#*****************************************************

# Step 1, Set variables
# Enter Table Storage location data 
$storageAccountName = '<Enter Storage Account Here>'
$tableName = '<Enter Table Name Here>'
$sasToken = '<Enter SAS Token Here>'
$partitionKey = 'Svr1PerfData'
$injuries = Import-Excel '.\sampledatasafety.xlsx'


# Step 2, Connect to Azure Table Storage
$storageCtx = New-AzureStorageContext -StorageAccountName $storageAccountName -SasToken $sasToken
$table = Get-AzureStorageTable -Name $tableName -Context $storageCtx



foreach ($injury in $injuries) {
    Add-StorageTableRow -table $table -partitionKey $partitionKey -rowKey ([guid]::NewGuid().tostring()) -property @{
        'Date' = $injury.Date
        'Injury Location' = $injury.InjuryLocation
        'CPUTime' = $injury.Gender
        'Age' = $injury.AgeGroup
    } | Out-Null
}
