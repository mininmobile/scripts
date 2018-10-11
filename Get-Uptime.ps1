$uptime = ((Get-WmiObject Win32_OperatingSystem).ConvertToDateTime(
			(Get-WmiObject Win32_OperatingSystem).LocalDateTime) - 
			(Get-WmiObject Win32_OperatingSystem).ConvertToDateTime(
			(Get-WmiObject Win32_OperatingSystem).LastBootUpTime))

$uptime.Days.ToString() + " days, " + $uptime.Hours.ToString() + " hours, " + $uptime.Minutes.ToString() + " minutes"
