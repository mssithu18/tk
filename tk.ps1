# ==========================================
# CROSS-PLATFORM ENTERPRISE TOOLKIT
# Author: Sithu M S
# Compatible: Windows / Linux / macOS
# Requires: PowerShell 7+
# ==========================================

function Get-SystemInfo {

    Write-Host "========== SYSTEM INFORMATION =========="

    if ($IsWindows) {
        $cpu = Get-CimInstance Win32_Processor
        $ram = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB
        $disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"

        Write-Host "OS        : Windows"
        Write-Host "CPU       : $($cpu.Name)"
        Write-Host "Cores     : $($cpu.NumberOfCores)"
        Write-Host "RAM (GB)  : $([math]::Round($ram,2))"
        Write-Host "Disk (GB) : $([math]::Round($disk.Size / 1GB,2))"
    }
    else {
        Write-Host "OS        : Linux/macOS"
        Write-Host "CPU       : $(lscpu | grep 'Model name')"
        Write-Host "RAM       : $(free -h | grep Mem)"
        Write-Host "Disk      : $(df -h / | tail -1)"
    }

    Write-Host "Username  : $env:USER"
    Write-Host "========================================="
}

function Get-NetworkInfo {

    Write-Host "========== NETWORK INFORMATION =========="

    if ($IsWindows) {
        $net = Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike "127*"}
        Write-Host "IP Address : $($net.IPAddress)"
    }
    else {
        Write-Host "IP Address : $(hostname -I)"
    }

    Write-Host "=========================================="
}

function Get-HardwareTier {

    Write-Host "========== PERFORMANCE CLASSIFICATION =========="

    if ($IsWindows) {
        $ram = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB
        $cores = (Get-CimInstance Win32_Processor).NumberOfCores
    }
    else {
        $ram = (free -g | awk '/Mem:/ {print $2}')
        $cores = (nproc)
    }

    if ($ram -le 4 -or $cores -le 2) {
        Write-Host "LOW PERFORMANCE SYSTEM"
    }
    elseif ($ram -le 8 -or $cores -le 4) {
        Write-Host "MID RANGE SYSTEM"
    }
    else {
        Write-Host "HIGH PERFORMANCE SYSTEM"
    }

    Write-Host "==============================================="
}

function Install-Browser {

    param ($browser)

    if ($IsWindows) {
        switch ($browser) {
            "chrome"   { winget install Google.Chrome }
            "firefox"  { winget install Mozilla.Firefox }
            "brave"    { winget install Brave.Brave }
        }
    }
    else {
        Write-Host "Use your distro package manager:"
        Write-Host "Ubuntu example:"
        Write-Host "sudo apt install firefox"
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
    }

} while ($choice -ne "0")