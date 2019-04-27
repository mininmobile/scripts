$architecture = (Get-WmiObject Win32_OperatingSystem).OSArchitecture.Split("-")[0]
$version = (Get-WmiObject Win32_OperatingSystem).Version

"Windows $($version) x$($architecture)"
