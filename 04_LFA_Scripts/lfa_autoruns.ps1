param([int] $Count=1)

#Import Configurations
$configs = Get-Content -Path ..\configuration.json | ConvertFrom-Json

$targets = Import-Csv ..\AllHosts.csv |
        Select-Object -ExpandProperty ip

#Get Credentials from the Operator
$creds = Get-Credential

#Set session options (This is required for out of band connections)
$so = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck

$current = Invoke-Command -UseSSL -SessionOption $so -ComputerName $targets -Credential $creds -FilePath ..\01_Reference_Scripts\autoruns.ps1 -ArgumentList (,$configs.autorun_locations)

$current | Sort-Object -Property pscomputername, Key_ValueName -Unique |
    Group-Object Key_ValueName |
    Where-Object {$_.count -le $Count} |
    Select-Object -ExpandProperty Group
