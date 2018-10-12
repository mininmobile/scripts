$accent = [ConsoleColor]::Magenta
$colons = $false
# casing options
#	0: ignore
#	1: lower
#	2: upper
$tcase = 1
$ftcase = 2
$fccase = 1

#
# utility functions
#

function Prettify([string] $timestamp) {
	$x = $timestamp.Split(":")

	return "$($x[0]) hours, $($x[1]) minutes"
}

function Set-Casing([string] $text, [int] $case) {
	switch ($case) {
		0 { return $text }
		1 { return $text.ToLower() }
		2 { return $text.ToUpper() }
	}
}

function Get-Colors {
	function c([int] $color) { Write-Host "   " -n -b ([enum]::GetName("ConsoleColor", $color)) }

	ascii; Write-Host "" # new line
	ascii; Write-Host "  " -n # padding
	c 9; c 10; c 11; c 12; c 13; c 14; c 7;  c 15
	Write-Host "" # new line
	ascii; Write-Host "  " -n # padding
	c 1; c 2;  c 3;  c 4;  c 5;  c 6;  c 8;  c 0
	Write-Host "" # new line
	ascii
}

#
# ascii art
#

$art = @{
	 0 = "                              ";
	 1 = "                              ";
	 2 = "                              ";
	 3 = "               #  #  #  #     ";
	 4 = "     #  #  #   #  #  #  #     ";
	 5 = "     #  #  #   #  #  #  #     ";
	 6 = "     #  #  #   #  #  #  #     ";
	 7 = "     #  #  #   #  #  #  #     ";
	 8 = "                              ";
	 9 = "     #  #  #   #  #  #  #     ";
	10 = "     #  #  #   #  #  #  #     ";
	11 = "     #  #  #   #  #  #  #     ";
	12 = "     #  #  #   #  #  #  #     ";
	13 = "               #  #  #  #     ";
	14 = "                              ";
}

$currentAsciiLine = 0

function ascii {
	$cart = [ConsoleColor]::Blue

	$result = $art[$currentAsciiLine]

	if ($result) { Write-Host "$($result) " -n -f $cart } else { Write-Host "                               " -n }

	

	$script:currentAsciiLine++
}

#
# actual text output
#

function title([string] $content) {
	$cacc = $accent
	$creg = [ConsoleColor]::White

	$content = Set-Casing $content $tcase

	ascii; Write-Host $content -f $cacc
	ascii; Write-Host "$("-"*$content.Length)" -f $creg
}

function field([string] $name, [string] $content) {
	$cacc = $accent
	$creg = [ConsoleColor]::White

	$name = Set-Casing $name $ftcase
	$content = Set-Casing $content $fccase

	Write-Host $name -n -f $cacc
	if ($colons) { Write-Host ":" -n -f $cacc }
	Write-Host " $($content)" -f $creg
}

Write-Host "Gathering system information..."

$data = @{
	"OS" =			(Get-OS);
	"Kernel" =		(Get-Kernel);
	"Packages" = 	"Chocolatey not Installed";
	"Uptime" =		(Prettify(Get-Uptime))
	"Shell" =		(Get-Shell);
	"Resolution" =	(Get-Resolution);
	"WM" =			"DWM";
	"CPU" =			(Get-Processor);
	"GPU" =			(Get-GraphicsCard);
	"Memory" =		(Get-RAM);
}

try { $data["Packages"] = (Get-Packages) } catch {}

Clear-Host
title (Get-Computer)
ascii; field "OS"			$data["OS"]
ascii; field "Kernel"		$data["Kernel"]
ascii; field "Packages" $data["Packages"]
ascii; field "Uptime"		$data["Uptime"]
ascii; field "Shell"		$data["Shell"]
ascii; field "Resolution"	$data["Resolution"]
ascii; field "WM"			$data["WM"]
ascii; field "CPU"			$data["CPU"]
ascii; field "GPU"			$data["GPU"]
ascii; field "Memory"		$data["Memory"]
Get-Colors
