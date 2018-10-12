$cacc = [ConsoleColor]::Magenta
$colon = ""
# casing options
#	0: ignore
#	1: lower
#	2: upper
$tcase = 1
$ftcase = 2
$fccase = 1

$cart = [ConsoleColor]::Blue
$creg = [ConsoleColor]::White

function Set-Casing([string] $text, [int] $case) {
	switch ($case) {
		0 { return $text }
		1 { return $text.ToLower() }
		2 { return $text.ToUpper() }
	}
}

try { $packages = (Get-Packages) } catch { $packages = "chocolately not installed" }

Write-Host "" # new line
Write-Host "            " -n -f $cart; Write-Host (Set-Casing (Get-Computer) $tcase) -f $cacc;
Write-Host " ###  ###   " -n -f $cart; Write-Host (Set-Casing "OS$($colon)`t`t" $ftcase) -n -f $cacc;			Write-Host (Set-Casing (Get-OS) $fccase) -f $creg
Write-Host " ###  ###   " -n -f $cart; Write-Host (Set-Casing "Kernel$($colon)`t" $ftcase) -n -f $cacc;			Write-Host (Set-Casing (Get-Kernel) $fccase) -f $creg
Write-Host "            " -n -f $cart; Write-Host (Set-Casing "Uptime$($colon)`t" $ftcase) -n -f $cacc;			Write-Host (Set-Casing (Get-Uptime) $fccase) -f $creg
Write-Host " ###  ###   " -n -f $cart; Write-Host (Set-Casing "Packages$($colon)`t" $ftcase) -n -f $cacc;		Write-Host (Set-Casing $packages $fccase) -f $creg
Write-Host " ###  ###   " -n -f $cart; Write-Host (Set-Casing "Shell$($colon)`t" $ftcase) -n -f $cacc;			Write-Host (Set-Casing "powershell" $fccase) -f $creg
Write-Host "            " -n -f $cart; Write-Host (Set-Casing "WM$($colon)`t`t" $ftcase) -n -f $cacc;			Write-Host (Set-Casing "dwm" $fccase) -f $creg
Write-Host "" # new line
