# =========================================
# TK ADMIN TOOLKIT
# Author: Sithu M S
# Cross Platform: Windows / Linux / macOS
# =========================================

Clear-Host

# ----------------------------
# Detect OS
# ----------------------------

if ($IsWindows) { $OS="Windows" }
elseif ($IsLinux) { $OS="Linux" }
elseif ($IsMacOS) { $OS="macOS" }
else { $OS="Unknown" }

# ----------------------------
# Banner
# ----------------------------

function Banner {

Write-Host ""
Write-Host "===================================="
Write-Host "        TK ADMIN TOOLKIT"
Write-Host "===================================="
Write-Host "OS Detected : $OS"
Write-Host ""

}

# ----------------------------
# SYSTEM INFO
# ----------------------------

function SystemInfo {

Write-Host "===== SYSTEM INFORMATION ====="

if ($IsWindows){

$os = Get-CimInstance Win32_OperatingSystem
$cpu = Get-CimInstance Win32_Processor
$ram = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory/1GB

Write-Host "OS :" $os.Caption
Write-Host "CPU :" $cpu.Name
Write-Host "Cores :" $cpu.NumberOfCores
Write-Host "RAM :" ([math]::Round($ram,2)) "GB"

}

elseif ($IsLinux){

uname -a
lscpu
free -h
df -h

}

elseif ($IsMacOS){

system_profiler SPHardwareDataType

}

}

# ----------------------------
# DASHBOARD
# ----------------------------

function Dashboard {

Clear-Host

Write-Host "======= SYSTEM DASHBOARD ======="

if ($IsWindows){

$cpu = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue

$ram = Get-CimInstance Win32_OperatingSystem
$total = $ram.TotalVisibleMemorySize
$free = $ram.FreePhysicalMemory
$ramPercent = [math]::Round((($total-$free)/$total)*100)

Write-Host "CPU Usage :" ([math]::Round($cpu)) "%"
Write-Host "RAM Usage :" $ramPercent "%"

}

else {

top -n 1 | head -5

}

}

# ----------------------------
# LIVE MONITOR
# ----------------------------

function LiveMonitor {

while ($true){

Dashboard
Start-Sleep 2

}

}

# ----------------------------
# NETWORK TOOLS
# ----------------------------

function PingTest {

ping 8.8.8.8

}

function NetworkInfo {

if ($IsWindows){ ipconfig /all }
elseif ($IsLinux){ ip a }
elseif ($IsMacOS){ ifconfig }

}

function ActiveConnections {

netstat -an

}

function NetworkAdapters {

if ($IsWindows){ Get-NetAdapter }
else{ ip link }

}

# ----------------------------
# DISK TOOLS
# ----------------------------

function DiskHealth {

if ($IsWindows){

Get-PhysicalDisk | Select FriendlyName,HealthStatus

}

else{

df -h

}

}

function DiskUsage {

Get-PSDrive

}

# ----------------------------
# SECURITY / LICENSE
# ----------------------------

function WindowsLicense {

if ($IsWindows){

$lic = Get-CimInstance SoftwareLicensingProduct |
Where-Object {$_.PartialProductKey}

if ($lic.LicenseStatus -eq 1){

Write-Host "Windows Activated"

}else{

Write-Host "Windows NOT Activated"

}

}else{

Write-Host "Not Windows"

}

}

function OfficeLicense {

$path="C:\Program Files\Microsoft Office\Office16\OSPP.VBS"

if(Test-Path $path){

cscript $path /dstatus

}else{

Write-Host "Office Not Found"

}

}

# ----------------------------
# ADMIN TOOLS
# ----------------------------

function RunningProcesses { Get-Process }

function Services { Get-Service }

function Drivers {

if ($IsWindows){ driverquery }

}

function InstalledSoftware {

if ($IsWindows){

Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
Select DisplayName

}

}

function FirewallStatus {

if ($IsWindows){ Get-NetFirewallProfile }

}

function WindowsUpdates {

if ($IsWindows){ Get-HotFix }

}

function StartupPrograms {

if ($IsWindows){

Get-CimInstance Win32_StartupCommand

}

}

function SystemUptime {

if ($IsWindows){

(get-date) - (gcim Win32_OperatingSystem).LastBootUpTime

}

else{

uptime

}

}

function RestartExplorer {

if ($IsWindows){

Stop-Process explorer -Force
Start-Process explorer

}

}

function ResetPassword {

if ($IsWindows){

$user=Read-Host "Username"
$pass=Read-Host "New Password"

net user $user $pass

}

}

# ----------------------------
# SOFTWARE INSTALLER
# ----------------------------

function InstallChrome {

if ($IsWindows){ winget install Google.Chrome }

elseif ($IsLinux){ sudo apt install chromium-browser -y }

elseif ($IsMacOS){ brew install google-chrome }

}

function InstallFirefox {

if ($IsWindows){ winget install Mozilla.Firefox }

elseif ($IsLinux){ sudo apt install firefox -y }

elseif ($IsMacOS){ brew install firefox }

}

function InstallBrave {

if ($IsWindows){ winget install Brave.Brave }

}

function InstallVSCode {

if ($IsWindows){ winget install Microsoft.VisualStudioCode }

elseif ($IsLinux){ sudo snap install code --classic }

elseif ($IsMacOS){ brew install --cask visual-studio-code }

}

function InstallGit {

if ($IsWindows){ winget install Git.Git }

elseif ($IsLinux){ sudo apt install git -y }

elseif ($IsMacOS){ brew install git }

}

function InstallNode {

if ($IsWindows){ winget install OpenJS.NodeJS }

elseif ($IsLinux){ sudo apt install nodejs -y }

elseif ($IsMacOS){ brew install node }

}

function InstallDocker {

if ($IsWindows){ winget install Docker.DockerDesktop }

elseif ($IsLinux){ sudo apt install docker.io -y }

elseif ($IsMacOS){ brew install docker }

}

function InstallAll {

InstallChrome
InstallFirefox
InstallBrave
InstallVSCode
InstallGit
InstallNode
InstallDocker

}

# ----------------------------
# MENU
# ----------------------------

do {

Banner

Write-Host "1  System Info"
Write-Host "2  Dashboard"
Write-Host "3  Live Monitor"
Write-Host "4  Ping Test"
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

switch ($choice){

"1" {SystemInfo}
"2" {Dashboard}
"3" {LiveMonitor}
"4" {PingTest}
"5" {NetworkInfo}
"6" {ActiveConnections}
"7" {NetworkAdapters}
"8" {DiskHealth}
"9" {DiskUsage}
"10" {WindowsLicense}
"11" {OfficeLicense}
"12" {RunningProcesses}
"13" {Services}
"14" {Drivers}
"15" {InstalledSoftware}
"16" {FirewallStatus}
"17" {WindowsUpdates}
"18" {StartupPrograms}
"19" {SystemUptime}
"20" {RestartExplorer}
"21" {ResetPassword}
"22" {InstallChrome}
"23" {InstallFirefox}
"24" {InstallBrave}
"25" {InstallVSCode}
"26" {InstallGit}
"27" {InstallNode}
"28" {InstallDocker}
"29" {InstallAll}

}

pause

} while ($choice -ne "0")