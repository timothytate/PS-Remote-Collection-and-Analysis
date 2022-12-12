param([string] $FileOut="..\Baseline\Autoruns_Baseline.csv", [bool] $ToScreen)

#Import Configurations
$configs = Get-Content -Path ..\configuration.json | ConvertFrom-Json

#Get Credentials from the Operator
$creds = Get-Credential

#Set session options (This is required for out of band connections)
$so = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck

$output = $targets | ForEach-Object {if($_.Subnet -eq "OpsNet" -and $_.OS -eq "Win10") {
    Invoke-Command -UseSSL -SessionOption $so -ComputerName $_.IP -Credential $creds -FilePath ..\01_Reference_Scripts\autoruns.ps1 -ArgumentList (,$configs.autorun_locations)}}

#Given Output Path send to File, Else to STDOUT    
if($FileOut){$output}
else{$output | Export-Csv -Path $FileOut}