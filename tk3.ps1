# ===============================================================
# Enterprise Terminal Toolkit v3
# Author : mssithu18
# Mode   : Terminal Only (No GUI)
# ===============================================================

Clear-Host

# ---------------------------------------------------------------
# BANNER
# ---------------------------------------------------------------

function Show-Banner {

Write-Host ""
Write-Host "================================================="
Write-Host "         ENTERPRISE TERMINAL TOOLKIT v3"
Write-Host "================================================="
Write-Host ""

}

# ---------------------------------------------------------------
# SYSTEM INFORMATION
# ---------------------------------------------------------------

function System-Info {

Write-Host ""
Write-Host "SYSTEM INFORMATION"
Write-Host "------------------"

$cpu = (Get-CimInstance Win32_Processor).Name
$ram = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB,2)
$os = (Get-CimInstance Win32_OperatingSystem).Caption
$boot = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime

Write-Host "CPU           : $cpu"
Write-Host "RAM           : $ram GB"
Write-Host "Operating Sys : $os"
Write-Host "Last Boot     : $boot"

}

# ---------------------------------------------------------------
# NETWORK STATUS
# ---------------------------------------------------------------

function Network-Status {

Write-Host ""
Write-Host "NETWORK STATUS"
Write-Host "--------------"

Get-NetIPAddress |
Where AddressFamily -eq IPv4 |
Select InterfaceAlias,IPAddress

}

# ---------------------------------------------------------------
# INTERNET SPEED TEST
# ---------------------------------------------------------------

function Internet-SpeedTest {

Write-Host ""
Write-Host "RUNNING INTERNET SPEED TEST..."

$url = "http://speedtest.tele2.net/10MB.zip"
$temp = "$env:TEMP\speedtest.tmp"

$time = Measure-Command {
Invoke-WebRequest $url -OutFile $temp -UseBasicParsing
}

Remove-Item $temp -ErrorAction SilentlyContinue

$speed = 80 / $time.TotalSeconds
$speed = [math]::Round($speed,2)

Write-Host "Estimated Download Speed : $speed Mbps"

}

# ---------------------------------------------------------------
# DISK INFORMATION
# ---------------------------------------------------------------

function Disk-Info {

Write-Host ""
Write-Host "DISK INFORMATION"

Get-PSDrive -PSProvider FileSystem |
Select Name,Used,Free

}

# ---------------------------------------------------------------
# LIST RUNNING PROCESSES
# ---------------------------------------------------------------

function Process-List {

Write-Host ""
Write-Host "TOP CPU PROCESSES"

Get-Process |
Sort CPU -Descending |
Select -First 15 Name,CPU

}

# ---------------------------------------------------------------
# NETWORK DEVICES
# ---------------------------------------------------------------

function Network-Devices {

Write-Host ""
Write-Host "NETWORK DEVICES"

arp -a

}

# ---------------------------------------------------------------
# PORT SCANNER
# ---------------------------------------------------------------

function Port-Scan {

$hostip = Read-Host "Enter Target IP"

$ports = 21,22,23,25,53,80,110,139,143,443,445,3389

foreach ($p in $ports){

$tcp = New-Object Net.Sockets.TcpClient

try{
$tcp.Connect($hostip,$p)
Write-Host "Port $p OPEN"
}
catch{
Write-Host "Port $p closed"
}

}

}

# ---------------------------------------------------------------
# RUNNING SERVICES
# ---------------------------------------------------------------

function Running-Services {

Write-Host ""
Write-Host "RUNNING SERVICES"

Get-Service |
Where {$_.Status -eq "Running"} |
Select -First 20 Name,DisplayName

}

# ---------------------------------------------------------------
# WINDOWS UPDATE CHECK
# ---------------------------------------------------------------

function Check-WindowsUpdate {

Write-Host ""
Write-Host "CHECKING WINDOWS UPDATES"

Install-Module PSWindowsUpdate -Force -ErrorAction SilentlyContinue
Get-WindowsUpdate

}

# ---------------------------------------------------------------
# SYSTEM FILE CHECKER
# ---------------------------------------------------------------

function System-Repair {

Write-Host ""
Write-Host "RUNNING SFC SCAN"

sfc /scannow

}

# ---------------------------------------------------------------
# DISK REPAIR
# ---------------------------------------------------------------

function Disk-Repair {

Write-Host ""
Write-Host "RUNNING CHKDSK"

chkdsk C: /scan

}

# ---------------------------------------------------------------
# NETWORK RESET
# ---------------------------------------------------------------

function Network-Reset {

Write-Host ""
Write-Host "RESETTING NETWORK"

ipconfig /flushdns
netsh winsock reset

}

# ---------------------------------------------------------------
# INSTALLED SOFTWARE
# ---------------------------------------------------------------

function Installed-Programs {

Write-Host ""
Write-Host "INSTALLED PROGRAMS"

Get-WmiObject Win32_Product |
Select Name

}

# ---------------------------------------------------------------
# SOFTWARE INSTALLER
# ---------------------------------------------------------------

function Install-Tools {

Write-Host ""
Write-Host "1 - Google Chrome"
Write-Host "2 - VS Code"
Write-Host "3 - 7zip"
Write-Host "4 - Git"

$choice = Read-Host "Select software"

switch($choice){

1 { winget install Google.Chrome }

2 { winget install Microsoft.VisualStudioCode }

3 { winget install 7zip.7zip }

4 { winget install Git.Git }

}

}

# ---------------------------------------------------------------
# CPU MONITOR
# ---------------------------------------------------------------

function CPU-Monitor {

while($true){

$cpu = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
$cpu = [math]::Round($cpu,2)

Write-Host "CPU Usage : $cpu %"

Start-Sleep 2

}

}

# ---------------------------------------------------------------
# RAM MONITOR
# ---------------------------------------------------------------

function RAM-Monitor {

while($true){

$ram = Get-Counter '\Memory\Available MBytes'

Write-Host "Available RAM : $($ram.CounterSamples.CookedValue) MB"

Start-Sleep 2

}

}

# ---------------------------------------------------------------
# PING TEST
# ---------------------------------------------------------------

function Ping-Test {

$host = Read-Host "Enter host"

ping $host

}

# ---------------------------------------------------------------
# PUBLIC IP
# ---------------------------------------------------------------

function Public-IP {

Write-Host ""
Write-Host "PUBLIC IP ADDRESS"

Invoke-RestMethod ifconfig.me

}

# ---------------------------------------------------------------
# FIREWALL STATUS
# ---------------------------------------------------------------

function Firewall-Status {

Get-NetFirewallProfile |
Select Name,Enabled

}

# ---------------------------------------------------------------
# ACTIVE NETWORK CONNECTIONS
# ---------------------------------------------------------------

function Net-Connections {

netstat -ano

}

# ---------------------------------------------------------------
# USER ACCOUNTS
# ---------------------------------------------------------------

function User-Accounts {

Get-LocalUser

}

# ---------------------------------------------------------------
# EVENT LOG VIEW
# ---------------------------------------------------------------

function Event-Logs {

Get-EventLog -LogName System -Newest 20

}

# ---------------------------------------------------------------
# SERVICES STOP TOOL
# ---------------------------------------------------------------

function Stop-ServiceTool {

$name = Read-Host "Enter Service Name"

Stop-Service $name

}

# ---------------------------------------------------------------
# PROCESS KILL TOOL
# ---------------------------------------------------------------

function Kill-Process {

$name = Read-Host "Enter Process Name"

Stop-Process -Name $name -Force

}

# ---------------------------------------------------------------
# NETWORK ADAPTERS
# ---------------------------------------------------------------

function Network-Adapters {

Get-NetAdapter |
Select Name,Status,MacAddress

}

# ---------------------------------------------------------------
# DNS CACHE VIEW
# ---------------------------------------------------------------

function DNS-Cache {

ipconfig /displaydns

}

# ---------------------------------------------------------------
# HOSTNAME
# ---------------------------------------------------------------

function Show-Hostname {

hostname

}

# ---------------------------------------------------------------
# TIME INFORMATION
# ---------------------------------------------------------------

function Time-Info {

Get-Date

}

# ---------------------------------------------------------------
# MAIN MENU
# ---------------------------------------------------------------

function Main-Menu {

while($true){

Write-Host ""
Write-Host "================ TOOL MENU ================="

Write-Host "1  - System Information"
Write-Host "2  - Network Status"
Write-Host "3  - Internet Speed Test"
Write-Host "4  - Disk Information"
Write-Host "5  - Running Processes"
Write-Host "6  - Network Devices"
Write-Host "7  - Port Scan"
Write-Host "8  - Running Services"
Write-Host "9  - Windows Update Check"
Write-Host "10 - System Repair"
Write-Host "11 - Disk Repair"
Write-Host "12 - Network Reset"
Write-Host "13 - Installed Programs"
Write-Host "14 - Install Software"
Write-Host "15 - CPU Monitor"
Write-Host "16 - RAM Monitor"
Write-Host "17 - Ping Test"
Write-Host "18 - Public IP"
Write-Host "19 - Firewall Status"
Write-Host "20 - Active Connections"
Write-Host "21 - User Accounts"
Write-Host "22 - Event Logs"
Write-Host "23 - Stop Service"
Write-Host "24 - Kill Process"
Write-Host "25 - Network Adapters"
Write-Host "26 - DNS Cache"
Write-Host "27 - Hostname"
Write-Host "28 - System Time"
Write-Host "0  - Exit"

$choice = Read-Host "Select option"

switch($choice){

1 { System-Info }
2 { Network-Status }
3 { Internet-SpeedTest }
4 { Disk-Info }
5 { Process-List }
6 { Network-Devices }
7 { Port-Scan }
8 { Running-Services }
9 { Check-WindowsUpdate }
10 { System-Repair }
11 { Disk-Repair }
12 { Network-Reset }
13 { Installed-Programs }
14 { Install-Tools }
15 { CPU-Monitor }
16 { RAM-Monitor }
17 { Ping-Test }
18 { Public-IP }
19 { Firewall-Status }
20 { Net-Connections }
21 { User-Accounts }
22 { Event-Logs }
23 { Stop-ServiceTool }
24 { Kill-Process }
25 { Network-Adapters }
26 { DNS-Cache }
27 { Show-Hostname }
28 { Time-Info }
0 { break }

default { Write-Host "Invalid option" }

}

}

}

# ---------------------------------------------------------------
# SCRIPT START
# ---------------------------------------------------------------

Show-Banner
Main-Menu