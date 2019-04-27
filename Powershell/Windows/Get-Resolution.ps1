Add-Type -AssemblyName System.Windows.Forms
$res = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize

"$($res.Width)x$($res.Height)"
