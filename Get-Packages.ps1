$list = (choco list -l -r) | Out-String

([regex]::Matches($list, "\n")).count
