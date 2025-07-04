# Sort-ByKeywords.ps1
# Iterate through all subfolders of the script’s directory to sort files
# - Move matching files into "Sorted\<folder>" (grouped via keywordMap)
# - Move all other files into "Unsorted"
# - Do not move the script itself
# - Re-scan the "Unsorted" folder on each run
# - Remove empty folders (except "Sorted" and "Unsorted")
# - Prevent the console from closing so you can read the logs

$ErrorActionPreference = 'Stop'

try {
    # 1) Full path to the script and root directory
    $scriptFullPath = $MyInvocation.MyCommand.Path
    if ($PSScriptRoot) {
        $root = $PSScriptRoot
        Set-Location $root
    }
    else {
        $root = Get-Location
    }

    # 2) Create "Sorted" and "Unsorted" if they don’t already exist
    $sortedRoot   = Join-Path $root 'Sorted'
    if (-not (Test-Path $sortedRoot))   { New-Item -ItemType Directory -Path $sortedRoot   | Out-Null }
    $unsortedRoot = Join-Path $root 'Unsorted'
    if (-not (Test-Path $unsortedRoot)) { New-Item -ItemType Directory -Path $unsortedRoot | Out-Null }

    # 3) Keyword-to-folder mapping table (modifiable)
    $keywordMap = @{
        'ARP'   = 'ARP'
        'KEY'   = 'KEY'
        'SYNTH' = 'SYNTH'
        'BASS'  = 'BASS'
        'BS_'   = 'BASS'
        'BA_'   = 'BASS'
        'BA'    = 'BASS'
        'GROWL' = 'GROWL'
        'STAB'  = 'STAB'
        'FX'    = 'FX'
        'PLUCK' = 'PLUCK'
    }

    # 4) Get all files under $root
    #    Exclude only the "Sorted" folder and the script itself
    $files = Get-ChildItem -Path $root -File -Recurse |
             Where-Object {
                 $_.DirectoryName -notlike "$sortedRoot*" -and
                 $_.FullName       -ne $scriptFullPath
             }

    foreach ($file in $files) {
        $moved = $false

        foreach ($kw in $keywordMap.Keys) {
            if ($file.Name.IndexOf($kw, [StringComparison]::InvariantCultureIgnoreCase) -ge 0) {
                $folderName = $keywordMap[$kw]
                $target     = Join-Path $sortedRoot $folderName

                if (-not (Test-Path $target)) {
                    New-Item -ItemType Directory -Path $target | Out-Null
                }

                Move-Item -Path $file.FullName -Destination $target
                $moved = $true
                break
            }
        }

        if (-not $moved) {
            Move-Item -Path $file.FullName -Destination $unsortedRoot
        }
    }

    # 5) Remove empty directories (excluding "Sorted" and "Unsorted")
    Get-ChildItem -Path $root -Directory -Recurse |
        Sort-Object FullName -Descending |
        ForEach-Object {
            if ($_.FullName -in @($sortedRoot, $unsortedRoot)) { return }
            if (-not (Get-ChildItem -Path $_.FullName -Force)) {
                Remove-Item -Path $_.FullName
            }
        }
}
catch {
    Write-Host "Une erreur est survenue : $($_.Exception.Message)" -ForegroundColor Red
}
finally {
    Read-Host -Prompt 'Press Enter to close the console'
}
