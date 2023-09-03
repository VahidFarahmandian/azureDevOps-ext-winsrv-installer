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

    [Parameter(Mandatory = $True)]
    [String]
    $file_source,    

    [Parameter(Mandatory = $True)]
    [String]
    $file_dest,        
    
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

. .\Core.ps1

if($serviceFriendlyName -eq "")
{
    $serviceFriendlyName = $serviceName
}
$service = Get-Service -Name $($serviceName) -ErrorAction SilentlyContinue

if ($service.Length -gt 0) {
    StopService $serviceName
    RemoveService $serviceName
}

CopyFiles $file_source $file_dest
CreateService $service_identity_username $service_identity_password $service_binaryPath $serviceFriendlyName
StartService $serviceName

Write-Host "Service Installation done!"