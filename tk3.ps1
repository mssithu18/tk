# ================================
# PowerShell Network Monitor
# ================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms.DataVisualization

$basePath = "$env:USERPROFILE\Documents\NetworkMonitor"
$csv = "$basePath\data.csv"
$html = "$basePath\dashboard.html"

if (!(Test-Path $basePath)) {
    New-Item -ItemType Directory $basePath | Out-Null
}

if (!(Test-Path $csv)) {
    "Date,Time,Download,Upload,Latency" | Out-File $csv
}

$server="8.8.8.8"
$speedThreshold=20

function Get-Speed {

    $json = speedtest -f json | ConvertFrom-Json

    $download=[math]::Round($json.download.bandwidth/125000,2)
    $upload=[math]::Round($json.upload.bandwidth/125000,2)

    return @($download,$upload)
}

function Get-Ping {

    $ping=Test-Connection $server -Count 4
    return ($ping | Measure-Object ResponseTime -Average).Average
}

function Send-Alert($speed){

$smtp="smtp.gmail.com"

Send-MailMessage `
-To "admin@email.com" `
-From "monitor@email.com" `
-Subject "Internet Speed Alert" `
-Body "Speed dropped to $speed Mbps" `
-SmtpServer $smtp
}

function Update-HTML {

$data=Import-Csv $csv | Select-Object -Last 20

$htmlContent=@"
<html>
<head>
<title>Network Dashboard</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>

<body>

<h2>Network Speed Dashboard</h2>

<canvas id="speedChart"></canvas>

<script>

var ctx=document.getElementById('speedChart');

var chart=new Chart(ctx,{
type:'line',
data:{
labels:[ $(($data.Time -join "','") -replace "^","'" -replace "$","'") ],
datasets:[
{
label:'Download Mbps',
data:[ $($data.Download -join ",") ]
},
{
label:'Upload Mbps',
data:[ $($data.Upload -join ",") ]
}
]
}
});

</script>

</body>
</html>
"@

$htmlContent | Out-File $html
}

function Run-Test {

$date=Get-Date -Format "yyyy-MM-dd"
$time=Get-Date -Format "HH:mm:ss"

$s=Get-Speed
$d=$s[0]
$u=$s[1]

$lat=Get-Ping

"$date,$time,$d,$u,$lat" | Add-Content $csv

if($d -lt $speedThreshold){
Send-Alert $d
}

Update-HTML

Write-Host "Download:$d Upload:$u Ping:$lat"
}

# GUI
$form=New-Object Windows.Forms.Form
$form.Text="Network Monitor"
$form.Width=300
$form.Height=200

$btn=New-Object Windows.Forms.Button
$btn.Text="Run Speed Test"
$btn.Width=200
$btn.Height=40
$btn.Top=50
$btn.Left=40

$btn.Add_Click({Run-Test})

$form.Controls.Add($btn)

$form.ShowDialog()