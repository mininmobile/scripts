$accent = [ConsoleColor]::Magenta
$colons = $false
# casing options
#	0: ignore
#	1: lower
#	2: upper
$tcase = 1
$ftcase = 2
$fccase = 1

function Set-Casing([string] $text, [int] $case) {
	switch ($case) {
		0 { return $text }
		1 { return $text.ToLower() }
		2 { return $text.ToUpper() }
	}
}

function Get-Colors {
	function c([int] $color) { Write-Host "   " -n -b ([enum]::GetName("ConsoleColor", $color)) }

	Write-Host "" # new line
	Write-Host "  " -n # padding
	c 1; c 2; c 3; c 4; c 5; c 6; c 7; c 0
	Write-Host "`n  " -n # padding
	c 9; c 10; c 11; c 12; c 13; c 14; c 15; c 8
	Write-Host "" # new line
}

function title([string] $content) {
	$cacc = $accent
	$creg = [ConsoleColor]::White

	$content = Set-Casing $content $tcase

	Write-Host $content -f $cacc
	Write-Host "$("-"*$content.Length)" -f $creg
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
	"Uptime" =		(Get-Uptime)
	"Shell" =		(Get-Shell);
	"Resolution" =	(Get-Resolution);
	"WM" =			"DWM";
	"CPU" =			(Get-Processor);
	"GPU" =			(Get-GraphicsCard);
	"Memory" =		(Get-RAM);
}

try { $data.Add("Packages", (Get-Packages)) } catch {}

Clear-Host
title (Get-Computer)
field "OS"			$data["OS"]
field "Kernel"		$data["Kernel"]
if ($data["Packages"]) { field "Packages" $data["Packages"] }
field "Uptime"		$data["Uptime"]
field "Shell"		$data["Shell"]
field "Resolution"	$data["Resolution"]
field "WM"			$data["WM"]
field "CPU"			$data["CPU"]
field "GPU"			$data["GPU"]
field "Memory"		$data["Memory"]
Get-Colors
