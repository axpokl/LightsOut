param(
    [string]$APath = (Join-Path $PSScriptRoot 'all_results_a.txt'),
    [string]$BPath = (Join-Path $PSScriptRoot 'all_results_b.txt'),
    [string]$OutputPath = (Join-Path $PSScriptRoot 'all_results.txt')
)

$ErrorActionPreference = 'Stop'
$number = '[0-9]+(?:\.[0-9]+)?'
$rowPattern = "^\s*\d+\s+($number)\s+m\s+($number)\s+c\s+($number)\s+q\s+($number)\s+z\s+($number)\s+d\s+$number(?:\s+x\s+($number))?\s+g(?:TRUE|FALSE)"

function Get-Median {
    param([double[]]$Values)

    if ($null -eq $Values -or $Values.Count -eq 0) {
        return $null
    }

    [double[]]$sorted = $Values | Sort-Object
    $middle = [int][math]::Floor(($sorted.Count - 1) / 2)
    return $sorted[$middle]
}

function New-Block {
    param([string]$Version)

    return [ordered]@{
        Version = $Version
        Mak = $null
        Q = [System.Collections.Generic.List[double]]::new()
        Z = [System.Collections.Generic.List[double]]::new()
        X = [System.Collections.Generic.List[double]]::new()
        Gen = [System.Collections.Generic.List[double]]::new()
        RowCount = 0
    }
}

function Save-Block {
    param(
        [hashtable]$Blocks,
        $Block
    )

    if ($null -ne $Block -and $Block.RowCount -gt 0) {
        $Blocks[$Block.Version] = $Block
    }
}

function Read-ResultFile {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        throw "Input file does not exist: $Path"
    }

    $blocks = @{}
    $current = $null

    foreach ($line in Get-Content -LiteralPath $Path) {
        if ($line -match '^=+\s+.*_H(\d+)\.exe\s+=+') {
            Save-Block -Blocks $blocks -Block $current
            $current = New-Block -Version ('H' + [int]$Matches[1])
            continue
        }

        if ($null -eq $current -or $line -notmatch $rowPattern) {
            continue
        }

        if ($current.RowCount -eq 0) {
            $current.Mak = [double]$Matches[2]
        }
        else {
            $current.Gen.Add([double]$Matches[1])
        }

        $current.Q.Add([double]$Matches[4])
        $current.Z.Add([double]$Matches[5])
        if (-not [string]::IsNullOrEmpty($Matches[6])) {
            $current.X.Add([double]$Matches[6])
        }
        $current.RowCount++
    }

    Save-Block -Blocks $blocks -Block $current
    return $blocks
}

function Format-Value {
    param($Value)

    if ($null -eq $Value) {
        return ''
    }

    return ([double]$Value).ToString('0.00', [Globalization.CultureInfo]::InvariantCulture)
}

function Write-Section {
    param(
        [System.Collections.Generic.List[string]]$Lines,
        [string]$Title,
        [hashtable]$Blocks
    )

    $Lines.Add("$Title`tmak`tq`tz`tx`tgen")
    $versions = $Blocks.Keys | Sort-Object { [int]($_ -replace '^H', '') }
    foreach ($version in $versions) {
        $block = $Blocks[$version]
        $values = @(
            Format-Value $block.Mak
            Format-Value (Get-Median $block.Q)
            Format-Value (Get-Median $block.Z)
            Format-Value (Get-Median $block.X)
            Format-Value (Get-Median $block.Gen)
        )
        $Lines.Add("$version`t$($values -join "`t")")
    }
}

$aBlocks = Read-ResultFile -Path $APath
$bBlocks = Read-ResultFile -Path $BPath
$lines = [System.Collections.Generic.List[string]]::new()
Write-Section -Lines $lines -Title 'A' -Blocks $aBlocks
$lines.Add('')
Write-Section -Lines $lines -Title 'B' -Blocks $bBlocks

$encoding = [Text.Encoding]::Default
[IO.File]::WriteAllText($OutputPath, (($lines -join "`r`n") + "`r`n"), $encoding)
Write-Host "Wrote $OutputPath"
