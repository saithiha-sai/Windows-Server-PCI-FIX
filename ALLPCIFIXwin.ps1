# ===========================================
# TLS 1.0 / 1.1 / 1.2 Configuration
# ===========================================

Write-Host "`nStarting TLS configuration..." -ForegroundColor Cyan

$basePath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols"

$protocols = @(
    @{ Name = "TLS 1.0"; Disable = $true },
    @{ Name = "TLS 1.1"; Disable = $true },
    @{ Name = "TLS 1.2"; Disable = $false }
)

foreach ($proto in $protocols) {

    $protoPath = Join-Path $basePath $proto.Name
    $serverPath = Join-Path $protoPath "Server"

    if (!(Test-Path $serverPath)) {
        Write-Host "$($proto.Name) settings not found. Creating..." -ForegroundColor Yellow
        New-Item -Path $protoPath -Force | Out-Null
        New-Item -Path $serverPath -Force | Out-Null
    }

    if ($proto.Disable -eq $true) {
        New-ItemProperty -Path $serverPath -Name "Enabled" -Value 0 -PropertyType DWORD -Force | Out-Null
        New-ItemProperty -Path $serverPath -Name "DisabledByDefault" -Value 1 -PropertyType DWORD -Force | Out-Null
        Write-Host "$($proto.Name) disabled." -ForegroundColor Red
    }
    else {
        New-ItemProperty -Path $serverPath -Name "Enabled" -Value 1 -PropertyType DWORD -Force | Out-Null
        New-ItemProperty -Path $serverPath -Name "DisabledByDefault" -Value 0 -PropertyType DWORD -Force | Out-Null
        Write-Host "$($proto.Name) enabled." -ForegroundColor Green
    }
}

Write-Host "`nTLS configuration completed." -ForegroundColor Cyan



# ===========================================
# Disable Triple DES 168 Cipher
# ===========================================

Write-Host "`nDisabling Triple DES 168 cipher..." -ForegroundColor Cyan

$cipherBasePath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers"
$tripleDESPath = Join-Path $cipherBasePath "Triple DES 168"

if (!(Test-Path $tripleDESPath)) {
    Write-Host "Triple DES 168 key not found. Creating..."
    New-Item -Path $tripleDESPath -Force | Out-Null
}

New-ItemProperty -Path $tripleDESPath -Name "Enabled" -Value 0 -PropertyType DWORD -Force | Out-Null
Write-Host "Triple DES 168 disabled."

# ===========================================
# SMB Signing Configuration
# ===========================================

Write-Host "`nConfiguring SMB signing policies..." -ForegroundColor Cyan

# Client: Always sign
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" `
    -Name RequireSecuritySignature -Value 1 -Type DWord

# Client: If server agrees
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" `
    -Name EnableSecuritySignature -Value 1 -Type DWord

# Server: Always sign
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" `
    -Name RequireSecuritySignature -Value 1 -Type DWord

# Server: If client agrees
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" `
    -Name EnableSecuritySignature -Value 1 -Type DWord

Write-Host "SMB signing policies configured."



# ===========================================
# Finish
# ===========================================

Write-Host "`nAll security configurations completed successfully."
Write-Host "A server reboot is required to apply all changes." -ForegroundColor Yellow
