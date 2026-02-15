param(
    [string]$IntertonRoot,
    [string]$IntertoncPath,
    [string]$IdePath,
    [string]$InstallDir = "C:\Interton\bin",
    [switch]$RegisterIt,
    [switch]$SkipCopy,
    [switch]$SkipShaCheck,
    [switch]$SkipHelloSmoke
)

$ErrorActionPreference = "Stop"

function Write-Status {
    param(
        [string]$Code,
        [string]$Message
    )
    Write-Host "[status] $Code | $Message"
}

function Resolve-IntertonRoot {
    if ($IntertonRoot) {
        return (Resolve-Path $IntertonRoot).Path
    }
    return (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
}

function Find-LatestIdeExe {
    param([string]$root)
    $dist = Join-Path $root "ide\desktop\dist"
    if (!(Test-Path $dist)) {
        return $null
    }
    $exe = Get-ChildItem -Path $dist -Filter "Interton IDE*.exe" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    return $exe?.FullName
}

function Resolve-IntertoncPath {
    param([string]$root, [string]$provided)
    if ($provided -and (Test-Path $provided)) {
        return (Resolve-Path $provided).Path
    }

    $candidates = @(
        (Join-Path $root "build\artifacts\windows\dist\bin\intertonc.exe"),
        (Join-Path $root "build\compiler\compiler\Release\intertonc.exe"),
        (Join-Path $root "build\compiler\compiler\Release\interton_compiler.exe")
    )
    foreach ($candidate in $candidates) {
        if (Test-Path $candidate) {
            return (Resolve-Path $candidate).Path
        }
    }
    return $null
}

function Parse-ExpectedSha256 {
    param([string]$shaFile)
    if (-not (Test-Path $shaFile)) {
        return $null
    }
    $line = (Get-Content $shaFile -TotalCount 1).Trim()
    if (-not $line) {
        return $null
    }
    $parts = $line -split '\s+'
    if ($parts.Count -lt 1) {
        return $null
    }
    return $parts[0].ToUpperInvariant()
}

function Ensure-UserPathContains {
    param([string]$pathEntry)
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ([string]::IsNullOrEmpty($userPath)) {
        [Environment]::SetEnvironmentVariable("Path", $pathEntry, "User")
        return
    }
    if ($userPath -notmatch [Regex]::Escape($pathEntry)) {
        [Environment]::SetEnvironmentVariable("Path", "$userPath;$pathEntry", "User")
    }
}

try {
    Write-Status -Code "INSTALL_PROGRESS" -Message "Starting Windows installation flow."

    $root = Resolve-IntertonRoot
    $resolvedIntertonc = Resolve-IntertoncPath -root $root -provided $IntertoncPath
    if (-not $resolvedIntertonc) {
        throw "intertonc.exe not found. Pass -IntertoncPath explicitly."
    }

    if (-not $IdePath) {
        $IdePath = Find-LatestIdeExe -root $root
    }

    $effectiveInstallDir = $InstallDir
    try {
        New-Item -ItemType Directory -Force -Path $effectiveInstallDir | Out-Null
    } catch {
        $fallback = Join-Path $env:LOCALAPPDATA "Interton\bin"
        Write-Warning "Cannot create '$effectiveInstallDir'. Falling back to '$fallback'."
        $effectiveInstallDir = $fallback
        New-Item -ItemType Directory -Force -Path $effectiveInstallDir | Out-Null
    }

    $installedExe = $resolvedIntertonc
    if (-not $SkipCopy) {
        $installedExe = Join-Path $effectiveInstallDir "intertonc.exe"
        Copy-Item -Force $resolvedIntertonc $installedExe
    }

    $installedExe = (Resolve-Path $installedExe).Path
    $installedIcon = Join-Path $effectiveInstallDir "interton.ico"
    $repoIconPath = Join-Path $root "interton.ico"
    if (Test-Path $repoIconPath) {
        try {
            Copy-Item -Force $repoIconPath $installedIcon
            $installedIcon = (Resolve-Path $installedIcon).Path
            Write-Host "Copied icon: $installedIcon"
        } catch {
            Write-Warning "Failed to copy icon to install dir: $($_.Exception.Message)"
        }
    }

    if (-not $SkipShaCheck) {
        $shaCandidates = @(
            "$resolvedIntertonc.sha256",
            (Join-Path (Split-Path -Parent $resolvedIntertonc) "intertonc.exe.sha256")
        )
        $shaFile = $shaCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
        if ($shaFile) {
            $expected = Parse-ExpectedSha256 -shaFile $shaFile
            if ($expected) {
                $actual = (Get-FileHash -Algorithm SHA256 -Path $installedExe).Hash.ToUpperInvariant()
                if ($actual -ne $expected) {
                    Write-Status -Code "CHECK_FAILED" -Message "SHA256 mismatch for installed binary."
                    throw "SHA256 mismatch for '$installedExe'. Expected '$expected', got '$actual'."
                }
                Write-Host "SHA256 verified for installed binary."
            } else {
                Write-Warning "SHA file found but could not parse: $shaFile"
            }
        } else {
            Write-Warning "SHA256 sidecar not found; skipped hash verification."
        }
    } else {
        Write-Status -Code "CHECK_SKIPPED" -Message "Checksum verification skipped by -SkipShaCheck."
    }

    Write-Host "INTERTONC_PATH = $installedExe"
    setx INTERTONC_PATH $installedExe | Out-Null
    Ensure-UserPathContains -pathEntry $effectiveInstallDir

    if ($IdePath) {
        Write-Host "IDE_PATH = $IdePath"
        setx IDE_PATH $IdePath | Out-Null
    }

    $llvmPath = "C:\Program Files\LLVM\bin"
    if (Test-Path $llvmPath) {
        Ensure-UserPathContains -pathEntry $llvmPath
        Write-Host "Ensured LLVM in PATH: $llvmPath"
    }

    if ($RegisterIt) {
        $assocScript = Join-Path $root "scripts\register_it_association.ps1"
        if (Test-Path $assocScript) {
            if (Test-Path $installedIcon) {
                & $assocScript -IntertoncPath $installedExe -IdePath $IdePath -IconPath $installedIcon
            } else {
                & $assocScript -IntertoncPath $installedExe -IdePath $IdePath
            }
        } else {
            Write-Warning "register_it_association.ps1 not found."
        }
    }

    if (-not $SkipHelloSmoke) {
        $smokeDir = Join-Path $env:TEMP ("interton_install_smoke_{0}" -f (Get-Date -Format "yyyyMMdd_HHmmss"))
        New-Item -ItemType Directory -Force -Path $smokeDir | Out-Null
        $helloFile = Join-Path $smokeDir "hello_world.it"
        @'
adding std.io

call main() -> int {
    inscribe("Hello, Interton")
    return 0
}
'@ | Out-File -FilePath $helloFile -Encoding utf8

        Write-Host "Running hello_world smoke test..."
        & $installedExe --run $helloFile
        if ($LASTEXITCODE -ne 0) {
            Write-Status -Code "CHECK_FAILED" -Message "hello_world smoke test failed."
            throw "hello_world smoke test failed with exit code $LASTEXITCODE"
        }
        Write-Host "hello_world smoke test passed."
    } else {
        Write-Status -Code "CHECK_SKIPPED" -Message "hello_world smoke test skipped by -SkipHelloSmoke."
    }

    Write-Status -Code "INSTALL_SUCCESS" -Message "Interton installation completed."
    Write-Host "Install complete."
} catch {
    Write-Status -Code "INSTALL_PROBLEM" -Message $_.Exception.Message
    throw
}
