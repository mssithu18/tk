Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms.DataVisualization

# Folder
$folder="$env:USERPROFILE\Documents\NetworkMonitor"
$csv="$folder\speed_log.csv"

if(!(Test-Path $folder)){
New-Item -ItemType Directory $folder | Out-Null
}

if(!(Test-Path $csv)){
"Time,Download,Upload,Ping" | Out-File $csv
}

# Form
$form=New-Object Windows.Forms.Form
$form.Text="Network Monitoring Dashboard"
$form.Width=900
$form.Height=500

# Chart
$chart=New-Object System.Windows.Forms.DataVisualization.Charting.Chart
$chart.Width=850
$chart.Height=300
$chart.Left=20
$chart.Top=20

$chartArea=New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
$chart.ChartAreas.Add($chartArea)

$downloadSeries=New-Object System.Windows.Forms.DataVisualization.Charting.Series
$downloadSeries.Name="Download"
$downloadSeries.ChartType="Line"

$uploadSeries=New-Object System.Windows.Forms.DataVisualization.Charting.Series
$uploadSeries.Name="Upload"
$uploadSeries.ChartType="Line"

$chart.Series.Add($downloadSeries)
$chart.Series.Add($uploadSeries)

$form.Controls.Add($chart)

# Status Label
$status=New-Object Windows.Forms.Label
$status.Width=800
$status.Height=30
$status.Top=330
$status.Left=40
$form.Controls.Add($status)

# Run Button
$button=New-Object Windows.Forms.Button
$button.Text="Run Speed Test"
$button.Width=200
$button.Height=40
$button.Top=380
$button.Left=350
$form.Controls.Add($button)

# Ping Server
$server="8.8.8.8"
$speedThreshold=20

function Run-Test{

$time=Get-Date -Format "HH:mm:ss"

$json=speedtest -f json | ConvertFrom-Json

$download=[math]::Round($json.download.bandwidth/125000,2)
$upload=[math]::Round($json.upload.bandwidth/125000,2)

$ping=(Test-Connection $server -Count 4 | Measure-Object ResponseTime -Average).Average

"$time,$download,$upload,$ping" | Add-Content $csv

$downloadSeries.Points.AddXY($time,$download)
$uploadSeries.Points.AddXY($time,$upload)

$status.Text="Download: $download Mbps | Upload: $upload Mbps | Ping: $ping ms"

# Email Alert
if($download -lt $speedThreshold){

$smtp="smtp.gmail.com"

Send-MailMessage `
-To "admin@email.com" `
-From "monitor@email.com" `
-Subject "Internet Speed Alert" `
-Body "Download speed dropped to $download Mbps" `
-SmtpServer $smtp
}

}

$button.Add_Click({Run-Test})

# Scheduler
$timer=New-Object Windows.Forms.Timer
$timer.Interval=60000

$timer.Add_Tick({

$now=Get-Date
$start=Get-Date -Hour 8 -Minute 45 -Second 0
$end=Get-Date -Hour 9 -Minute 0 -Second 0

if($now -ge $start -and $now -le $end){

for($i=1;$i -le 10;$i++){

Run-Test
Start-Sleep -Seconds 90

}

}

})

$timer.Start()

$form.ShowDialog()