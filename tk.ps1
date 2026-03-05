# ==========================================
# TK ENTERPRISE TOOLKIT v3
# Author : Sithu M S
# Supports : Windows PowerShell 5.1 / PowerShell 7+
# ==========================================

function Banner {
Clear-Host
Write-Host "========================================="
Write-Host "        TK ENTERPRISE TOOLKIT v3         "
Write-Host "========================================="
}

# -------------------------
# SYSTEM INFO
# -------------------------

function System-Info {

Write-Host "===== SYSTEM INFO ====="

$os = Get-CimInstance Win32_OperatingSystem
$cpu = Get-CimInstance Win32_Processor
$ram = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory /1GB

Write-Host "OS :" $os.Caption
Write-Host "CPU :" $cpu.Name
Write-Host "Cores :" $cpu.NumberOfCores
Write-Host "RAM :" ([math]::Round($ram,2)) "GB"

}

# -------------------------
# DASHBOARD
# -------------------------

function Dashboard {

$cpu = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue

$ram = Get-CimInstance Win32_OperatingSystem
$total = $ram.TotalVisibleMemorySize
$free = $ram.FreePhysicalMemory
$ramPercent = [math]::Round((($total-$free)/$total)*100)

Write-Host "CPU :" ([math]::Round($cpu)) "%"
Write-Host "RAM :" $ramPercent "%"

}

# -------------------------
# LIVE MONITOR
# -------------------------

function Live-Monitor {

while ($true){

Clear-Host

$cpu = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue

$ram = Get-CimInstance Win32_OperatingSystem
$total = $ram.TotalVisibleMemorySize
$free = $ram.FreePhysicalMemory
$ramPercent = [math]::Round((($total-$free)/$total)*100)

Write-Host "CPU :" ([math]::Round($cpu)) "%"
Write-Host "RAM :" $ramPercent "%"

Start-Sleep 2

}

}

# -------------------------
# INTERNET TEST
# -------------------------

function Ping-Test {

Test-Connection 8.8.8.8 -Count 4

}

# -------------------------
# NETWORK INFO
# -------------------------

function Network-Info {

ipconfig /all

}

function Active-Connections {

netstat -ano

}

function Network-Adapters {

Get-NetAdapter

}

# -------------------------
# DISK TOOLS
# -------------------------

function Disk-Health {

Get-PhysicalDisk | Select FriendlyName,HealthStatus

}

function Disk-Usage {

Get-PSDrive

}

# -------------------------
# LICENSE CHECKS
# -------------------------

function Windows-License {

$lic = Get-CimInstance SoftwareLicensingProduct |
Where-Object {$_.PartialProductKey}

if ($lic.LicenseStatus -eq 1){
Write-Host "Windows Activated"
}
else{
Write-Host "Windows NOT Activated"
}

}

function Office-License {

$path = "C:\Program Files\Microsoft Office\Office16\OSPP.VBS"

if(Test-Path $path){

cscript $path /dstatus

}else{

Write-Host "Office not detected"

}

}

# -------------------------
# ADMIN UTILITIES
# -------------------------

function Restart-Explorer {

Stop-Process explorer -Force
Start-Process explorer

}

function Reset-Password {

$user = Read-Host "Username"
$pass = Read-Host "Password"

net user $user $pass

}

function Drivers {

driverquery

}

function Installed-Software {

Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
Select DisplayName

}

function Running-Processes {

Get-Process

}

function Services {

Get-Service

}

function Firewall-Status {

Get-NetFirewallProfile

}

function Windows-Updates {

Get-HotFix

}

function Startup-Programs {

Get-CimInstance Win32_StartupCommand

}

function System-Uptime {

(get-date) - (gcim Win32_OperatingSystem).LastBootUpTime

}

# -------------------------
# AUTO SOFTWARE INSTALLER
# -------------------------

function Install-Chrome {

winget install Google.Chrome

}

function Install-Firefox {

winget install Mozilla.Firefox

}

function Install-Brave {

winget install Brave.Brave

}

function Install-VSCode {

winget install Microsoft.VisualStudioCode

}

function Install-Git {

winget install Git.Git

}

function Install-Node {

winget install OpenJS.NodeJS

}

function Install-Docker {

winget install Docker.DockerDesktop

}

function Install-All {

Install-Chrome
Install-Firefox
Install-Brave
Install-VSCode
Install-Git
Install-Node
Install-Docker

}

# -------------------------
# MENU
# -------------------------

do {

Banner

Write-Host "1  System Info"
Write-Host "2  Dashboard"
Write-Host "3  Live CPU/RAM Monitor"
Write-Host "4  Ping Internet"
Write-Host "5  Network Info"
Write-Host "6  Active Connections"
Write-Host "7  Network Adapters"
Write-Host "8  Disk Health"
Write-Host "9  Disk Usage"
Write-Host "10 Windows License"
Write-Host "11 Office License"
Write-Host "12 Running Processes"
Write-Host "13 Services"
Write-Host "14 Drivers"
Write-Host "15 Installed Software"
Write-Host "16 Firewall Status"
Write-Host "17 Windows Updates"
Write-Host "18 Startup Programs"
Write-Host "19 System Uptime"
Write-Host "20 Restart Explorer"
Write-Host "21 Reset User Password"
Write-Host "22 Install Chrome"
Write-Host "23 Install Firefox"
Write-Host "24 Install Brave"
Write-Host "25 Install VS Code"
Write-Host "26 Install Git"
Write-Host "27 Install NodeJS"
Write-Host "28 Install Docker"
Write-Host "29 Install ALL Software"
Write-Host "0  Exit"

$choice = Read-Host "Select Option"

switch ($choice) {

"1" {System-Info}
"2" {Dashboard}
"3" {Live-Monitor}
"4" {Ping-Test}
"5" {Network-Info}
"6" {Active-Connections}
"7" {Network-Adapters}
"8" {Disk-Health}
"9" {Disk-Usage}
"10" {Windows-License}
"11" {Office-License}
"12" {Running-Processes}
"13" {Services}
"14" {Drivers}
"15" {Installed-Software}
"16" {Firewall-Status}
"17" {Windows-Updates}
"18" {Startup-Programs}
"19" {System-Uptime}
"20" {Restart-Explorer}
"21" {Reset-Password}
"22" {Install-Chrome}
"23" {Install-Firefox}
"24" {Install-Brave}
"25" {Install-VSCode}
"26" {Install-Git}
"27" {Install-Node}
"28" {Install-Docker}
"29" {Install-All}

}

pause

} while ($choice -ne "0")