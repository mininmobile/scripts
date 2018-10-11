$TotalRam = ([math]::Truncate((Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory / 1MB));
$UsedRam = $TotalRam - ([math]::Truncate((Get-WmiObject Win32_OperatingSystem).FreePhysicalMemory / 1KB));

$UsedRam.ToString() + "MiB / " + $TotalRam.ToString() + "MiB"
