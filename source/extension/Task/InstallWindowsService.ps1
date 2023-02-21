param(
    [Parameter(Mandatory = $True)]
    [String]
    $serviceName,
   
    [Parameter(Mandatory = $True)]
    [String]
    $service_binaryPath,
    
    [Parameter(Mandatory = $True)]
    [String]
    $service_identity_username,
    
    [Parameter(Mandatory = $False)]
    [String]
    $service_identity_password="",
    
    [Parameter(Mandatory = $False)]
    [String]
    $serviceFriendlyName="",
   
    
    [Parameter(Mandatory = $False)]
    [String]
    $service_startupType = "Automatic"

)
if($serviceFriendlyName -eq "")
{
    $serviceFriendlyName = $serviceName
}
$service = Get-Service -Name $($serviceName) -ErrorAction SilentlyContinue

if ($service.Length -gt 0) {
    Stop-Service -Name "$($serviceName)" -Force
    Write-Host "Service stopping..."
    (Get-Service $serviceName).WaitForStatus('Stopped')
    Write-Host "Service stopped..."
    $pidnumber  = (get-wmiobject win32_service | where { $_.name -eq $($serviceName)}).processID
    if($pidnumber -gt 0)
    {
        Write-Host "Service PID: $($pidnumber) is alive!"
        Stop-Process $pidnumber -Force
        Write-Host "Service PID: $($pidnumber) killed"
    }
    Write-Host "Removing service..."
    ##Remove-Service -Name "$($serviceName)"
    sc.exe delete "$($serviceName)"
    Write-Host "Service removed..."
}
Write-Host "Creating service..."
$username = "$($service_identity_username)"
$password = "$($service_identity_password)"
$securepassword=""
if ($password -eq "") 
{
    $securepassword = (new-object System.Security.SecureString)
}
else
{
    $securepassword = ConvertTo-SecureString $password -AsPlainText -Force
}
$cred = New-Object System.Management.Automation.PSCredential ($username, $securepassword)
$params = @{
  Name = "$($serviceName)"
  BinaryPathName = "$($service_binaryPath)"
  DisplayName = "$($serviceFriendlyName)"
  StartupType = "$($service_startupType)"
}
New-Service @params -Credential $cred 
Write-Host "Service created."
Write-Host "Starting service..."
Start-Service -Name "$($serviceName)"
Write-Host "Service Installation done!"