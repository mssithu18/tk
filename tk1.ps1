# ==========================================
# UNIVERSAL ENTERPRISE TOOLKIT
# Compatible: Windows PowerShell 5.1 + PowerShell 7+
# Author: Sithu M S
# ==========================================

# Detect OS (works in old & new PowerShell)
$IsWindowsOS = $env:OS -eq "Windows_NT"

function Get-SystemInfo {

    Write-Host "`n========== SYSTEM INFORMATION =========="

    if ($IsWindowsOS) {

        $cpu  = Get-WmiObject Win32_Processor
        $ram  = (Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory / 1GB
        $disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'"

        Write-Host "OS        : Windows"
        Write-Host "CPU       : $($cpu.Name)"
        Write-Host "Cores     : $($cpu.NumberOfCores)"
        Write-Host "RAM (GB)  : $([math]::Round($ram,2))"
        Write-Host "Disk (GB) : $([math]::Round($disk.Size / 1GB,2))"
        Write-Host "Username  : $env:USERNAME"
    }
    else {

        Write-Host "OS        : Linux/macOS"
        Write-Host "Username  : $env:USER"
        Write-Host "Use native Linux tools for detailed info."
    }

    Write-Host "========================================="
}

function Get-NetworkInfo {

    Write-Host "`n========== NETWORK INFORMATION =========="

    if ($IsWindowsOS) {

        $ip = Get-WmiObject Win32_NetworkAdapterConfiguration |
              Where-Object { $_.IPEnabled -eq $true } |
              Select-Object -First 1

        Write-Host "IP Address : $($ip.IPAddress[0])"
        Write-Host "MAC        : $($ip.MACAddress)"
    }
    else {
        Write-Host "Use: ip a"
    }

    Write-Host "=========================================="
}

function Get-HardwareTier {

    Write-Host "`n========== PERFORMANCE CLASSIFICATION =========="

    if ($IsWindowsOS) {

        $ram   = (Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory / 1GB
        $cores = (Get-WmiObject Win32_Processor).NumberOfCores

        if ($ram -le 4 -or $cores -le 2) {
            Write-Host "LOW PERFORMANCE SYSTEM"
        }
        elseif ($ram -le 8 -or $cores -le 4) {
            Write-Host "MID RANGE SYSTEM"
        }
        else {
            Write-Host "HIGH PERFORMANCE SYSTEM"
        }
    }
    else {
        Write-Host "Hardware classification available on Windows only."
    }

    Write-Host "==============================================="
}

function Install-Browser {

    param ($browser)

    if ($IsWindowsOS) {

        if (Get-Command winget -ErrorAction SilentlyContinue) {

            switch ($browser) {
                "chrome"   { winget install -e --id Google.Chrome }
                "firefox"  { winget install -e --id Mozilla.Firefox }
                "brave"    { winget install -e --id Brave.Brave }
            }

        } else {
            Write-Host "Winget not installed."
            Write-Host "Download from Microsoft Store (App Installer)."
        }
    }
    else {
        Write-Host "Use your Linux package manager."
    }
}

# MENU
do {
    Write-Host ""
    Write-Host "========== ENTERPRISE TOOLKIT =========="
    Write-Host "1. System Info"
    Write-Host "2. Network Info"
    Write-Host "3. Performance Classification"
    Write-Host "4. Install Chrome"
    Write-Host "5. Install Firefox"
    Write-Host "6. Install Brave"
    Write-Host "0. Exit"
    Write-Host "========================================"

    $choice = Read-Host "Select Option"

    switch ($choice) {
        "1" { Get-SystemInfo }
        "2" { Get-NetworkInfo }
        "3" { Get-HardwareTier }
        "4" { Install-Browser "chrome" }
        "5" { Install-Browser "firefox" }
        "6" { Install-Browser "brave" }
        "0" { break }
        default { Write-Host "Invalid selection." }
    }

} while ($choice -ne "0")