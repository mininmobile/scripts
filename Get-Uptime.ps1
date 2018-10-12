$uptime = ((Get-WmiObject Win32_OperatingSystem).ConvertToDateTime(
			(Get-WmiObject Win32_OperatingSystem).LocalDateTime) - 
			(Get-WmiObject Win32_OperatingSystem).ConvertToDateTime(
			(Get-WmiObject Win32_OperatingSystem).LastBootUpTime))

"$($uptime.Hours.ToString()):$($uptime.Minutes.ToString())"
