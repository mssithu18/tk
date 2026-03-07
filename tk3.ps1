# ============================================
# Enterprise Terminal Toolkit v3
# Author : mssithu18
# Mode   : Terminal Only (No GUI)
# ============================================

Clear-Host

function Show-Banner {

Write-Host ""
Write-Host "==============================================="
Write-Host "        ENTERPRISE TERMINAL TOOLKIT v3"
Write-Host "==============================================="
Write-Host ""

}

# ------------------------------------------------
# SYSTEM INFORMATION
# ------------------------------------------------

function System-Info {

Write-Host ""
Write-Host "SYSTEM INFORMATION"
Write-Host "-------------------"

$cpu = (Get-CimInstance Win32_Processor).Name
$ram = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB,2)
$os = (Get-CimInstance Win32_OperatingSystem).Caption
$boot = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime

Write-Host "CPU           : $cpu"
Write-Host "RAM           : $ram GB"
Write-Host "Operating Sys : $os"
Write-Host "Last Boot     : $boot"

}

# ------------------------------------------------
# NETWORK STATUS
# ------------------------------------------------

function Network-Status {

Write-Host ""
Write-Host "NETWORK STATUS"
Write-Host "---------------"

Get-NetIPAddress | Where AddressFamily -eq IPv4 |
Select InterfaceAlias,IPAddress

}

# ------------------------------------------------
# INTERNET SPEED TEST
# ------------------------------------------------

function Internet-SpeedTest {

Write-Host ""
Write-Host "RUNNING INTERNET SPEED TEST..."
Write-Host "------------------------------"

$server = "http://speedtest.tele2.net/10MB.zip"
$temp = "$env:TEMP\speedtest.tmp"

$time = Measure-Command {
Invoke-WebRequest $server -OutFile $temp -UseBasicParsing
}

Remove-Item $temp -ErrorAction SilentlyContinue

$speed = 80 / $time.TotalSeconds
$speed = [math]::Round($speed,2)

Write-Host "Estimated Download Speed : $speed Mbps"

}

# ------------------------------------------------
# DISK INFORMATION
# ------------------------------------------------

function Disk-Info {

Write-Host ""
Write-Host "DISK INFORMATION"
Write-Host "----------------"

Get-PSDrive -PSProvider FileSystem |
Select Name,Used,Free

}

# ------------------------------------------------
# RUNNING PROCESSES
# ------------------------------------------------

function Process-List {

Write-Host ""
Write-Host "TOP CPU PROCESSES"
Write-Host "------------------"

Get-Process |
Sort CPU -Descending |
Select -First 10 Name,CPU

}

# ------------------------------------------------
# NETWORK DEVICES
# ------------------------------------------------

function Network-Devices {

Write-Host ""
Write-Host "NETWORK DEVICES"
Write-Host "---------------"

arp -a

}

# ------------------------------------------------
# PORT SCAN
# ------------------------------------------------

function Port-Scan {

$hostip = Read-Host "Enter Target IP"

Write-Host ""
Write-Host "Scanning common ports..."

$ports = 21,22,23,25,53,80,110,139,143,443,445,3389

foreach ($p in $ports){

$tcp = New-Object Net.Sockets.TcpClient

try{
$tcp.Connect($hostip,$p)
Write-Host "Port $p OPEN"
}
catch{}

}

}

# ------------------------------------------------
# WINDOWS SERVICES
# ------------------------------------------------

function Running-Services {

Write-Host ""
Write-Host "RUNNING SERVICES"
Write-Host "----------------"

Get-Service |
Where {$_.Status -eq "Running"} |
Select -First 15 Name,DisplayName

}

# ------------------------------------------------
# WINDOWS UPDATE CHECK
# ------------------------------------------------

function Check-WindowsUpdate {

Write-Host ""
Write-Host "CHECKING WINDOWS UPDATE"

Install-Module PSWindowsUpdate -Force -ErrorAction SilentlyContinue

Get-WindowsUpdate

}

# ------------------------------------------------
# SYSTEM FILE REPAIR
# ------------------------------------------------

function System-Repair {

Write-Host ""
Write-Host "Running SFC Scan..."

sfc /scannow

}

# ------------------------------------------------
# DISK REPAIR
# ------------------------------------------------

function Disk-Repair {

Write-Host ""
Write-Host "Running CHKDSK..."

chkdsk C: /scan

}

# ------------------------------------------------
# NETWORK RESET
# ------------------------------------------------

function Network-Reset {

Write-Host ""
Write-Host "RESETTING NETWORK"

ipconfig /flushdns
netsh winsock reset

}

# ------------------------------------------------
# INSTALLED PROGRAMS
# ------------------------------------------------

function Installed-Programs {

Write-Host ""
Write-Host "INSTALLED SOFTWARE"

Get-WmiObject Win32_Product |
Select Name

}

# ------------------------------------------------
# SOFTWARE INSTALLER
# ------------------------------------------------

function Install-Tools {

Write-Host ""
Write-Host "1 - Google Chrome"
Write-Host "2 - VS Code"
Write-Host "3 - 7zip"
Write-Host "4 - Git"

$ch = Read-Host "Select"

switch($ch){

1 { winget install Google.Chrome }

2 { winget install Microsoft.VisualStudioCode }

3 { winget install 7zip.7zip }

4 { winget install Git.Git }

}

}

# ------------------------------------------------
# CPU MONITOR
# ------------------------------------------------

function CPU-Monitor {

Write-Host ""
Write-Host "CPU LIVE MONITOR"

while($true){

$cpu = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
$cpu = [math]::Round($cpu,2)

Write-Host "CPU Usage : $cpu %"

Start-Sleep 2

}

}

# ------------------------------------------------
# MEMORY MONITOR
# ------------------------------------------------

function RAM-Monitor {

Write-Host ""
Write-Host "RAM LIVE MONITOR"

while($true){

$ram = Get-Counter '\Memory\Available MBytes'
Write-Host "Available RAM : $($ram.CounterSamples.CookedValue) MB"

Start-Sleep 2

}

}

# ------------------------------------------------
# NETWORK PING TEST
# ------------------------------------------------

function Ping-Test {

$host = Read-Host "Enter Host"

ping $host

}

# ------------------------------------------------
# MENU
# ------------------------------------------------

function Main-Menu {

while($true){

Write-Host ""
Write-Host "================ TOOL MENU ================"

Write-Host "1  - System Information"
Write-Host "2  - Network Status"
Write-Host "3  - Internet Speed Test"
Write-Host "4  - Disk Information"
Write-Host "5  - Running Processes"
Write-Host "6  - Network Devices"
Write-Host "7  - Port Scan"
Write-Host "8  - Running Services"
Write-Host "9  - Windows Update Check"
Write-Host "10 - System Repair (SFC)"
Write-Host "11 - Disk Repair"
Write-Host "12 - Network Reset"
Write-Host "13 - Installed Programs"
Write-Host "14 - Install Software"
Write-Host "15 - CPU Monitor"
Write-Host "16 - RAM Monitor"
Write-Host "17 - Ping Test"
Write-Host "0  - Exit"

Write-Host "==========================================="

$choice = Read-Host "Select Option"

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

0 { break }

}

}

}

# ------------------------------------------------
# SCRIPT START
# ------------------------------------------------

Show-Banner
System-Info
Network-Status
Internet-SpeedTest
Main-Menu