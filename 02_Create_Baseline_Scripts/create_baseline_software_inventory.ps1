﻿param([string] $FileOut="..\Baseline\Software_Baseline.csv")

#Import Targets List
$targets = Import-Csv ..\AllHosts.csv

#Import Configurations
$configs = Get-Content -Path ..\configuration.json | ConvertFrom-Json

#Get Credentials from the Operator
$creds = Get-Credential

#Set session options (This is required for out of band connections)
$so = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck

$output = $targets | ForEach-Object {if($_.Subnet -eq "OpsNet" -and $_.OS -eq "Win10") {
    Invoke-Command -UseSSL -SessionOption $so -ComputerName $_.IP -Credential $creds -FilePath ..\01_Reference_Scripts\softwareinventory.ps1 -ArgumentList (,$configs.program_folders)}} | Export-Csv -Path $FileOut