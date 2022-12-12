param([string] $BaselinePath="..\Baseline\Files_of_Interest_Baseline.csv")

$targets = Import-Csv ..\AllHosts.csv |
  Where-Object {$_.OS -eq "Win10"} |
  Select-Object -ExpandProperty IP

#Import Configurations
$configs = Get-Content -Path ..\configuration.json | ConvertFrom-Json

#Get Credentials from the Operator
$creds = Get-Credential

#Set session options (This is required for out of band connections)
$so = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck
    
$ht = @{
  ReferenceObject = Import-Csv $BaselinePath
  Property        = "Path"
  PassThru        = $true
}

$current = Invoke-Command -UseSSL -SessionOption $so -ComputerName $targets -Credential $creds -FilePath ..\01_Reference_Scripts\filesofinterest.ps1 -ArgumentList (,$configs.file_patterns)

ForEach ($ip in $targets){
  $ht.DifferenceObject = $current |
  Where-Object {$_.pscomputername -eq $ip} |
  Sort-Object -Property Path -Unique
  
  Compare-Object @ht |
  Where-Object {$_.sideindicator -eq "=>"}
  
  Compare-Object @ht |
  Where-Object {$_.sideindicator -eq "<="}
}