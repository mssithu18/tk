# =====================================================
# ENTERPRISE TOOLKIT v4
# Professional IT Infrastructure Admin Toolkit
# Single File Enterprise Edition
# =====================================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms.DataVisualization

# =====================================================
# GLOBAL VARIABLES
# =====================================================

$ToolkitName = "Enterprise Toolkit v4"
$Version = "4.0"
$Author = "Enterprise Admin Toolkit"

# =====================================================
# GUI WINDOW
# =====================================================

$form = New-Object System.Windows.Forms.Form
$form.Text = "$ToolkitName"
$form.Size = New-Object System.Drawing.Size(1400,800)
$form.StartPosition = "CenterScreen"
$form.BackColor = "#1e1e1e"

# =====================================================
# OUTPUT CONSOLE
# =====================================================

$output = New-Object System.Windows.Forms.TextBox
$output.Multiline = $true
$output.ScrollBars = "Vertical"
$output.Size = New-Object System.Drawing.Size(850,650)
$output.Location = New-Object System.Drawing.Point(500,80)
$output.BackColor = "Black"
$output.ForeColor = "Lime"

$form.Controls.Add($output)

function Write-Console($text){

$output.AppendText($text + "`r`n")

}

# =====================================================
# SYSTEM INFORMATION
# =====================================================

function Get-SystemInformation{

$os = Get-CimInstance Win32_OperatingSystem
$cpu = Get-CimInstance Win32_Processor
$ram = Get-CimInstance Win32_PhysicalMemory

$totalram = ($ram.Capacity | Measure-Object -Sum).Sum /1GB

Write-Console "Operating System: $($os.Caption)"
Write-Console "Version: $($os.Version)"
Write-Console "CPU: $($cpu.Name)"
Write-Console "RAM: $([math]::Round($totalram,2)) GB"

}

# =====================================================
# CPU MONITOR
# =====================================================

function Get-CPUUsage{

$cpu = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
Write-Console "CPU Usage: $([math]::Round($cpu,2))%"

}

# =====================================================
# RAM MONITOR
# =====================================================

function Get-RAMUsage{

$ram = Get-Counter '\Memory\Available MBytes'
Write-Console "Available RAM: $($ram.CounterSamples.CookedValue) MB"

}

# =====================================================
# DISK USAGE
# =====================================================

function Get-DiskUsage{

Get-PSDrive -PSProvider FileSystem | ForEach{

Write-Console "$($_.Name) Free: $([math]::Round($_.Free/1GB,2)) GB"

}

}

# =====================================================
# NETWORK INFORMATION
# =====================================================

function Get-IPInformation{

ipconfig | ForEach{

Write-Console $_

}

}

# =====================================================
# NETWORK SCANNER
# =====================================================

function Scan-Network{

$subnet="192.168.1"

Write-Console "Scanning Network..."

1..254 | ForEach{

$ip="$subnet.$_"

if(Test-Connection $ip -Count 1 -Quiet){

Write-Console "Online: $ip"

}

}

}

# =====================================================
# PORT SCANNER
# =====================================================

function Scan-PortRange{

param($target="127.0.0.1")

Write-Console "Scanning Ports..."

for($port=1;$port -le 1024;$port++){

$tcp = New-Object Net.Sockets.TcpClient

try{

$tcp.Connect($target,$port)

Write-Console "OPEN PORT: $port"

$tcp.Close()

}

catch{}

}

}

# =====================================================
# DISK CLEANER
# =====================================================

function Clean-TempFiles{

Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Console "Temp files cleaned"

}

function Clear-Recycle{

Clear-RecycleBin -Force
Write-Console "Recycle bin cleared"

}

# =====================================================
# WINDOWS REPAIR
# =====================================================

function Run-SFC{

Write-Console "Running System File Checker..."
sfc /scannow

}

function Run-DISM{

Write-Console "Running DISM Repair..."
DISM /Online /Cleanup-Image /RestoreHealth

}

# =====================================================
# SECURITY CHECK
# =====================================================

function Get-DefenderStatus{

$status=Get-MpComputerStatus

Write-Console "Antivirus Enabled: $($status.AntivirusEnabled)"
Write-Console "RealTime Protection: $($status.RealTimeProtectionEnabled)"

}

function Get-FirewallStatus{

Get-NetFirewallProfile | ForEach{

Write-Console "$($_.Name) Firewall Enabled: $($_.Enabled)"

}

}

# =====================================================
# SOFTWARE INSTALLER
# =====================================================

function Install-Chrome{

winget install Google.Chrome

}

function Install-VSCode{

winget install Microsoft.VisualStudioCode

}

function Install-Git{

winget install Git.Git

}

# =====================================================
# AI DIAGNOSTICS
# =====================================================

function Invoke-AIDiagnostics{

$cpu=(Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
$ram=(Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue

if($cpu -gt 80){

Write-Console "Warning: High CPU usage detected"

}

if($ram -lt 500){

Write-Console "Warning: Low memory detected"

}

}

# =====================================================
# BUTTON CREATOR
# =====================================================

function Create-Button($text,$x,$y,$action){

$btn=New-Object System.Windows.Forms.Button
$btn.Text=$text
$btn.Size=New-Object System.Drawing.Size(220,40)
$btn.Location=New-Object System.Drawing.Point($x,$y)
$btn.BackColor="#333333"
$btn.ForeColor="White"

$btn.Add_Click($action)

$form.Controls.Add($btn)

}

# =====================================================
# DASHBOARD BUTTONS
# =====================================================

Create-Button "System Info" 20 80 {Get-SystemInformation}
Create-Button "CPU Usage" 20 130 {Get-CPUUsage}
Create-Button "RAM Usage" 20 180 {Get-RAMUsage}
Create-Button "Disk Usage" 20 230 {Get-DiskUsage}

Create-Button "IP Info" 20 300 {Get-IPInformation}
Create-Button "Network Scan" 20 350 {Scan-Network}

Create-Button "Port Scanner" 20 420 {Scan-PortRange}

Create-Button "Temp Cleaner" 260 80 {Clean-TempFiles}
Create-Button "Recycle Cleaner" 260 130 {Clear-Recycle}

Create-Button "Run SFC Repair" 260 200 {Run-SFC}
Create-Button "Run DISM Repair" 260 250 {Run-DISM}

Create-Button "Defender Status" 260 320 {Get-DefenderStatus}
Create-Button "Firewall Status" 260 370 {Get-FirewallStatus}

Create-Button "Install Chrome" 260 440 {Install-Chrome}
Create-Button "Install VSCode" 260 490 {Install-VSCode}
Create-Button "Install Git" 260 540 {Install-Git}

Create-Button "AI Diagnostics" 260 610 {Invoke-AIDiagnostics}

# =====================================================
# START APPLICATION
# =====================================================

$form.ShowDialog()