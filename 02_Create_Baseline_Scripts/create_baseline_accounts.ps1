param([string] $FileOut="..\Baseline\Accounts_Baseline.csv")

#Import Targets List
$targets = Import-Csv ..\AllHosts.csv

#Get Credentials from the Operator
$creds = Get-Credential

#Set session options (This is required for out of band connections)
$so = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck

$targets | ForEach-Object {if($_.Subnet -eq "OpsNet" -and $_.OS -eq "Win10") {
    Invoke-Command -UseSSL -SessionOption $so -ComputerName $_.IP -Credential $creds -FilePath ..\01_Reference_Scripts\accounts.ps1}} | Export-Csv -Path $FileOut