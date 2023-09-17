function StopService
{
    Param($serviceName)

    Stop-Service -Name "$($serviceName)" -Force
    Write-Host "Service $($serviceName) stopping..."
    (Get-Service $serviceName).WaitForStatus('Stopped')
    Write-Host "Service $($serviceName) stopped..."
}

function RemoveService
{
    Param($serviceName)

    $pidnumber  = (Get-WmiObject win32_service | where { $_.name -eq "$($serviceName)"}).processID
    if($pidnumber -gt 0)
    {
        Write-Host "Service PID: $($pidnumber) is alive!"
        Stop-Process $pidnumber -Force
        Write-Host "Service PID: $($pidnumber) killed"
    }
    Write-Host "Removing $($serviceName) service..."
    sc.exe delete "$($serviceName)"
    Write-Host "Service $($serviceName) removed..."
}

function CopyFiles
{
    Param($file_source, $file_dest)

    Write-Host "Copying files from $($file_source) to $($file_dest)..."
    If(!(Test-Path -PathType Container $file_dest))
    {
          New-Item -ItemType Directory -Path $file_dest
    }
    Copy-Item "$($file_source)\*" $file_dest -Recurse -Force
    Write-Host "Files copied..."
}

function CreateService
{
    Param($service_identity_username, $service_identity_password, $service_binaryPath, $serviceFriendlyName)

    Write-Host "Creating service..."
    $username = "$($service_identity_username)"
    $password = "$($service_identity_password)"
    $securepassword=""
    if ($password -eq "") 
    {
        $securepassword = (New-Object System.Security.SecureString)
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
}

function StartService
{
    Param($serviceName)

    Write-Host "Restarting service..."
    Start-Service -Name "$($serviceName)"
    (Get-Service $serviceName).WaitForStatus('Running')
    Start-Sleep -Seconds 5

    StopService

    Start-Service -Name "$($serviceName)"
    (Get-Service $serviceName).WaitForStatus('Running')
    Write-Host "Service restarted..."
}
