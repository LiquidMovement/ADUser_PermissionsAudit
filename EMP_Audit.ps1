
$Deptartments = @("Accounting", "Cashiers", "Compliance", "Customer Service", "Default Depts", "Exec Admin", "Exec Team", "Facilities","HECM", "HR", "Insurance", "Investor Reporting", "Information Technology", "Origination", "Shipping", "Supervisors", "Taxes_Payoffs", "Treasury")
$filePath = "C:\temp\EmpAudit\Emp.csv"

foreach($dept in $Deptartments){
    
        if($Dept -eq "Information Technology"){
            $userDept = Get-ADUser -LDAPFilter "(name=*)" -SearchBase "OU=$Dept,OU=XXXX,DC=XXXX,DC=XXXX,DC=XXXX" -SearchScope OneLevel -Properties DisplayName,Department,Title,Description,Manager | Select-Object DisplayName,Department,Title,Description,Manager | Export-Csv -Path $filePath -Append -NoTypeInformation
        }
        else{
            $UserDept = Get-ADUser -LDAPFilter "(name=*)" -SearchBase "OU=$Dept,OU=XXXX,OU=XXXX,DC=XXXX,DC=XXXX,DC=XXXX" -SearchScope OneLevel -Properties DisplayName,Department,Title,Description,Manager | Select-Object DisplayName,Department,Title,Description,Manager | Export-Csv -Path $filePath -Append -NoTypeInformation
        }

}

<#foreach($user in $test){
    
    Get-ADUser -LDAPFilter "(name=*)" -SearchBase "OU=XXXX,DC=XXXX,DC=XXXX,DC=XXXX" -SearchScope OneLevel -Properties DisplayName,Department,Description,Manager | Select-Object DisplayName,Department,Description,Manager | Export-Csv -Path C:\temp\test\Emp.csv -Append -NoTypeInformation

}#>

#$info = Import-Csv -Path C:\temp\test\Emp.csv -Header c1, c2, c3, c4

<#foreach($one in $info.c4){
    
    $one = $hold -split "="
    $resplit = $split[1] -split "\,"

    $last0 = $resplit[0]
    $lastFin = $last0.Substring(0,$last0.Length-1)
    $first = $resplit[1] -split " "

    $lastFin
    $first = $first[1]
    $first

    $entire = "$lastFin, $first"

    $entire | Out-File C:\temp\test\Emp.csv -Append

}#>