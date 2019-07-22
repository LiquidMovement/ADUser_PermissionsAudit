
$Departments = @("Accounting", "Cashiers", "Compliance", "Customer Service", "Default Depts", "Exec Admin", "Exec Team", "Facilities","HECM", "HR", "Insurance", "Investor Reporting", "Information Technology", "Origination", "Shipping", "Supervisors", "Taxes_Payoffs", "Treasury")

foreach($dept in $Departments){

        $filePathTxt = "C:\temp\EmpAudit\Depts\$dept Emp_Audit.txt"
        $filePathCSV = "C:\temp\EmpAudit\Depts\$dept Emp_Audit.csv"
        "Last Name, First Name, SAMAccount, Department, Title, Supervisor, Extension, GroupMemberships" | Out-File $filePathTxt

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
        
        Import-Csv -Path $filePathTxt -Delimiter "," | Export-csv -Path $filePathCSV -NoTypeInformation
        Remove-Item -Path $filePathTxt
}