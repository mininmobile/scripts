$cacc = [ConsoleColor]::Magenta

$cart = [ConsoleColor]::Blue
$creg = [ConsoleColor]::White

try { $packages = (Get-Packages) } catch { $packages = "chocolately not installed" }

Write-Host "" # new line
Write-Host "  ----=  =====### " -n -f $cart; Write-Host (Get-Computer).ToLower() -f $cacc;
Write-Host "-=#####  ######## " -n -f $cart; Write-Host "OS:`t`t" -n -f $cacc;				Write-Host (Get-OS) -f $creg
Write-Host "-######  ######## " -n -f $cart; Write-Host "Kernel:`t" -n -f $cacc;		Write-Host (Get-Kernel) -f $creg
Write-Host "                  " -n -f $cart; Write-Host "Uptime:`t" -n -f $cacc;		Write-Host (Get-Uptime) -f $creg
Write-Host "-######  ######## " -n -f $cart; Write-Host "Packages:`t" -n -f $cacc;		Write-Host $packages -f $creg
Write-Host "-=#####  ######## " -n -f $cart; Write-Host "Shell:`t" -n -f $cacc;		Write-Host "powershell" -f $creg
Write-Host "  ----=  =====### " -n -f $cart; Write-Host "WM:`t`t" -n -f $cacc;			Write-Host "dwm" -f $creg
Write-Host "" # new line
