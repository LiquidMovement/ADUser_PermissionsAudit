if(test-path "C:\temp\EmpAudit"){}
else{New-Item "C:\temp\EmpAudit" -ItemType Directory}

Write-Host "Make sure ActiveUserMenuOptions.csv has been received from a Dev and is saved to C:\temp\EmpAudit on your PC.
Make sure to add columns Supervisor and Department to the csv before continuing with this script"

Pause

$filePath = "C:\temp\EmpAudit\ActiveUserMenuOptions.csv"
$csv = Import-Csv -Path $filePath

foreach($person in $csv){
    
    $user = $person.USER
    $ad = Get-ADUser -Identity $user -Properties Department,Description | Select-Object Department,Description

    $person.Supervisor = $ad.Description
    $person.Department = $ad.Department
    
}

$csv | Export-CSV -NoTypeInformation $filePath

Write-Host "Fix errors in the CSV before continuing forward. Review the red errors in the Powershell Console for clues."
Pause

$path = "C:\temp\EmpAudit\P8Perms_by_Sup"
if(Test-Path $path){}
else{New-item $path -ItemType Directory}

$newCSV = Import-Csv -Path $filePath

foreach($person in $newCSV){
    
    $sup = $person.Supervisor
    $supP8 = "P8_$sup"
    $newFilePath = "$path\$supP8.csv"
    
    $person | Export-CSV -NoTypeInformation $newFilePath -Append

}