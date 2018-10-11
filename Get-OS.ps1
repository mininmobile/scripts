$architecture = (Get-WmiObject Win32_OperatingSystem).OSArchitecture.Split("-")[0] + " Bit"
$caption = (Get-WmiObject Win32_OperatingSystem).Caption

"$($architecture) $($caption)"
