if(test-path "C:\temp\EmpAudit"){}
else{New-Item "C:\temp\EmpAudit" -ItemType Directory}

$Departments = @("Accounting", "Cashiers", "Compliance", "Customer Service", "Default Depts", "Exec Admin", "Exec Team", "Facilities","HECM", "HR", "Insurance", "Investor Reporting", "Information Technology", "Origination", "Shipping", "Supervisors", "Taxes_Payoffs", "Treasury")
$filePathTxt = "C:\temp\EmpAudit\Emp_Audit_Master.txt"
$filePathCSV = "C:\temp\EmpAudit\Emp_Audit_Master.csv"

"Last Name, First Name, SAMAccount, Department, Title, Supervisor, Extension, GroupMemberships" | Out-File $filePathTxt

foreach($dept in $Departments){
    
        if($Dept -eq "Information Technology"){
            $userDept = Get-ADUser -LDAPFilter "(name=*)" -SearchBase "OU=$Dept,OU=XXXX,DC=XXXX,DC=XXXX,DC=XXXX" -SearchScope OneLevel -Properties DisplayName,Department,Title,Description,Manager,sAMAccountName,telephoneNumber | Select-Object DisplayName,Department,Title,Description,Manager,sAMAccountName,telephoneNumber 
        }
        else{
            $UserDept = Get-ADUser -LDAPFilter "(name=*)" -SearchBase "OU=$Dept,OU=XXXX,OU=XXXX,DC=XXXX,DC=XXXX,DC=XXXX" -SearchScope OneLevel -Properties DisplayName,Department,Title,Description,Manager,sAMAccountName,telephoneNumber | Select-Object DisplayName,Department,Title,Description,Manager,sAMAccountName,telephoneNumber
        }
            
        foreach($user in $userDept){
                $DisplayName = $user.DisplayName
                $SAM = $user.SamAccountName
                $Depo = $user.Department
                $title = $user.Title
                $desc = $user.Description
                $ext = $user.telephoneNumber

                $userG = Get-ADPrincipalGroupMembership -Identity $SAM | Select-Object -ExpandProperty Name
                foreach($group in $userG){
                    "$Displayname,$SAM,$Depo,$Title, $desc,$ext,$group" | Out-File $filePathTxt -Append
                }
        }
        

}

Import-Csv -Path $filePathTxt -Delimiter "," | Export-csv -Path $filePathCSV -NoTypeInformation
Remove-Item -Path $filePathTxt


$path = "C:\temp\EmpAudit\ADPerms_by_Sup"
if(Test-Path $path){}
else{New-item $path -ItemType Directory}

$newCSV = Import-Csv -Path $filePathCSV

foreach($person in $newCSV){
    
    $sup = $person.Supervisor
    $supAD = "AD_$sup"
    if($sup -eq $null){
    }
    else{
        $newFilePath = "$path\$supAD.csv"
    }
    
    $person | Export-CSV -NoTypeInformation $newFilePath -Append

}