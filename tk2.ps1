Clear-Host

# ===============================
# ENTERPRISE TOOLKIT
# Author: Sithu M S
# Single File Admin Toolkit
# ===============================

function header {
Clear-Host
Write-Host "================================="
Write-Host "       ENTERPRISE TOOLKIT"
Write-Host "================================="
}

function pause {
Read-Host "Press Enter to continue"
}

# -------------------------------
# OS INFORMATION
# -------------------------------

function osinfo {

header
Write-Host "Operating System Information"

if($IsWindows){

Get-CimInstance Win32_OperatingSystem | Select Caption,Version,OSArchitecture

}
elseif($IsLinux){

uname -a
cat /etc/os-release

}
else{

system_profiler SPSoftwareDataType

}

pause
}

# -------------------------------
# HARDWARE INFO
# -------------------------------

function hardware {

header
Write-Host "Hardware Information"

if($IsWindows){

Get-CimInstance Win32_Processor | Select Name,NumberOfCores
(Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory/1GB
Get-CimInstance Win32_BaseBoard

}
else{

lscpu
free -h

}

pause
}

# -------------------------------
# NETWORK INFO
# -------------------------------

function network {

header
Write-Host "Network Information"

if($IsWindows){

ipconfig /all

}
else{

ip a

}

pause
}

# -------------------------------
# INTERNET TEST
# -------------------------------

function pingtest {

header
Write-Host "Internet Connectivity Test"

if($IsWindows){

ping 8.8.8.8 -n 4

}
else{

ping -c 4 8.8.8.8

}

pause
}

# -------------------------------
# TRACE ROUTE
# -------------------------------

function tracer {

header

if($IsWindows){

tracert google.com

}
else{

traceroute google.com

}

pause
}

# -------------------------------
# ACTIVE CONNECTIONS
# -------------------------------

function connections {

header

if($IsWindows){

netstat -ano

}
else{

ss -tunap

}

pause
}

# -------------------------------
# PUBLIC IP
# -------------------------------

function publicip {

header
Write-Host "Public IP"

Invoke-RestMethod ifconfig.me

pause
}

# -------------------------------
# DRIVER LIST
# -------------------------------

function drivers {

header

if($IsWindows){

driverquery

}
else{

lsmod

}

pause
}

# -------------------------------
# DISK INFO
# -------------------------------

function diskinfo {

header

if($IsWindows){

Get-Volume

}
else{

df -h

}

pause
}

# -------------------------------
# DISK HEALTH
# -------------------------------

function diskhealth {

header

if($IsWindows){

Get-PhysicalDisk

}
else{

lsblk

}

pause
}

# -------------------------------
# TOP PROCESSES
# -------------------------------

function processes {

header

Get-Process | Sort CPU -Descending | Select -First 10

pause
}

# -------------------------------
# CPU RAM MONITOR
# -------------------------------

function monitor {

header
Write-Host "Live CPU RAM Monitor (Ctrl+C to stop)"

while($true){

if($IsWindows){

$cpu=(Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
$ram=(Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue

Write-Host "CPU:"([math]::Round($cpu,2))"%"
Write-Host "Free RAM:"$ram"MB"

}

Start-Sleep 2
Clear-Host
header

}

}

# -------------------------------
# FIREWALL STATUS
# -------------------------------

function firewall {

header

if($IsWindows){

netsh advfirewall show allprofiles

}
else{

sudo ufw status

}

pause
}

# -------------------------------
# WINDOWS LICENSE
# -------------------------------

function winlicense {

header

if($IsWindows){

slmgr /xpr

}

pause
}

# -------------------------------
# OFFICE LICENSE
# -------------------------------

function officelicense {

header

if($IsWindows){

cscript "C:\Program Files\Microsoft Office\Office16\OSPP.VBS" /dstatus

}

pause
}

# -------------------------------
# RESTART EXPLORER
# -------------------------------

function restartexplorer {

header

if($IsWindows){

Stop-Process -Name explorer -Force
Start-Process explorer

}

pause
}

# -------------------------------
# SOFTWARE INSTALLER
# -------------------------------

function installer {

header

Write-Host "Software Installer"
Write-Host "1 Chrome"
Write-Host "2 Firefox"
Write-Host "3 Brave"
Write-Host "4 VS Code"
Write-Host "5 Git"
Write-Host "6 NodeJS"
Write-Host "7 Docker"

$choice=Read-Host "Select"

switch($choice){

1 { winget install Google.Chrome }
2 { winget install Mozilla.Firefox }
3 { winget install Brave.Brave }
4 { winget install Microsoft.VisualStudioCode }
5 { winget install Git.Git }
6 { winget install OpenJS.NodeJS }
7 { winget install Docker.DockerDesktop }

}

pause
}

# -------------------------------
# MAIN MENU
# -------------------------------

function menu {

header

Write-Host "1  OS Info"
Write-Host "2  Hardware Info"
Write-Host "3  Network Info"
Write-Host "4  Internet Test"
Write-Host "5  Trace Route"
Write-Host "6  Active Connections"
Write-Host "7  Public IP"
Write-Host "8  Drivers"
Write-Host "9  Disk Info"
Write-Host "10 Disk Health"
Write-Host "11 Top Processes"
Write-Host "12 CPU RAM Monitor"
Write-Host "13 Firewall Status"
Write-Host "14 Windows License"
Write-Host "15 Office Activation"
Write-Host "16 Restart Explorer"
Write-Host "17 Software Installer"
Write-Host "0  Exit"

$choice=Read-Host "Select Option"

switch($choice){

1 {osinfo}
2 {hardware}
3 {network}
4 {pingtest}
5 {tracer}
6 {connections}
7 {publicip}
8 {drivers}
9 {diskinfo}
10 {diskhealth}
11 {processes}
12 {monitor}
13 {firewall}
14 {winlicense}
15 {officelicense}
16 {restartexplorer}
17 {installer}
0 {exit}

}

}

while($true){

menu

}