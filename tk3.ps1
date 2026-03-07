# =========================================
# PowerShell Network Monitoring Toolkit
# Logs saved in Documents folder
# =========================================

$logFolder = "$env:USERPROFILE\Documents\NetworkMonitor"
$logFile = "$logFolder\network_data.csv"

$server = "8.8.8.8"
$speedThreshold = 20

# Create folder
if (!(Test-Path $logFolder)) {
    New-Item -ItemType Directory -Path $logFolder | Out-Null
}

# Create CSV
if (!(Test-Path $logFile)) {
    "Date,Time,Download,Upload,Latency,PacketLoss" | Out-File $logFile
}

function Get-SpeedTest {

    $result = speedtest --simple

    $download = ($result | Select-String "Download").ToString().Split(" ")[1]
    $upload = ($result | Select-String "Upload").ToString().Split(" ")[1]

    return @($download,$upload)
}

function Get-PingStats {

    $ping = Test-Connection $server -Count 4

    $latency = ($ping | Measure-Object ResponseTime -Average).Average
    $loss = (4 - $ping.Count)

    return @($latency,$loss)
}

function Run-Monitor {

    $date = Get-Date -Format "yyyy-MM-dd"
    $time = Get-Date -Format "HH:mm:ss"

    $speed = Get-SpeedTest
    $download = $speed[0]
    $upload = $speed[1]

    $pingStats = Get-PingStats
    $latency = $pingStats[0]
    $loss = $pingStats[1]

    "$date,$time,$download,$upload,$latency,$loss" | Add-Content $logFile

    Write-Host "Download: $download Mbps | Upload: $upload Mbps | Ping: $latency ms"
}

while ($true) {

    $now = Get-Date
    $start = Get-Date -Hour 8 -Minute 45 -Second 0
    $end = Get-Date -Hour 9 -Minute 0 -Second 0

    if ($now -ge $start -and $now -le $end) {

        for ($i=1;$i -le 10;$i++) {

            Run-Monitor

            Start-Sleep -Seconds 90
        }

        Start-Sleep -Seconds 86400
    }

    Start-Sleep -Seconds 60
}