param([string] $BaselinePath="..\Baseline\Folders_of_Interest_Baseline.csv")

$targets = Import-Csv ..\AllHosts.csv |
  Where-Object {$_.OS -eq "Win10"} |
  Select-Object -ExpandProperty IP

#Import Configurations
$configs = Get-Content -Path ..\configuration.json | ConvertFrom-Json

#Get Credentials from the Operator
$creds = Get-Credential -UserName Administrator@anomaly.not -Message "Password?"

#Set session options (This is required for out of band connections)
$so = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck
    
$ht = @{
  ReferenceObject = Import-Csv $BaselinePath
  Property        = "FullName"
  PassThru        = $true
}

$current = Invoke-Command -UseSSL -SessionOption $so -ComputerName $targets -Credential $creds -FilePath ..\01_Reference_Scripts\foldersofinterest.ps1 -ArgumentList (,$configs.common_exploited_folders)

ForEach ($ip in $targets){
  $ht.DifferenceObject = $current |
  Where-Object {$_.pscomputername -eq $ip} |
  Sort-Object -Property FullName -Unique
  
  Compare-Object @ht |
  Where-Object {$_.sideindicator -eq "=>"}
  
  Compare-Object @ht |
  Where-Object {$_.sideindicator -eq "<="}
}