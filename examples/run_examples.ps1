$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Resolve-Path (Join-Path $root "..")
$resultsDir = Join-Path $repoRoot "test_results"
New-Item -ItemType Directory -Force -Path $resultsDir | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $repoRoot "build\\outputs") | Out-Null

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$resultsFile = Join-Path $resultsDir ("examples_run_{0}.md" -f $timestamp)
"# Examples Run - $(Get-Date)" | Out-File -FilePath $resultsFile -Encoding utf8
"" | Out-File -FilePath $resultsFile -Append -Encoding utf8

$compiler = Join-Path $repoRoot "build\compiler\compiler\Release\interton_compiler.exe"
if (-not (Test-Path $compiler)) {
    $compiler = Join-Path $repoRoot "build\artifacts\windows\dist\bin\intertonc.exe"
}
if (-not (Test-Path $compiler)) { throw "Compiler not found." }

function Resolve-CommandPath([string[]]$names) {
    foreach ($name in $names) {
        $cmd = Get-Command -Name $name -ErrorAction SilentlyContinue
        if ($cmd) { return $cmd.Source }
    }
    return $null
}

function Ensure-EnvPath([string]$envName, [string[]]$commandNames) {
    if (-not [Environment]::GetEnvironmentVariable($envName)) {
        $resolved = Resolve-CommandPath $commandNames
        if ($resolved) {
            [Environment]::SetEnvironmentVariable($envName, $resolved, "Process")
        }
    }
}

Ensure-EnvPath "INTERTON_PY" @("python", "python3", "py")
Ensure-EnvPath "INTERTON_NODE" @("node")
Ensure-EnvPath "INTERTON_TS" @("ts-node", "node")
Ensure-EnvPath "INTERTON_C" @("clang", "gcc")
Ensure-EnvPath "INTERTON_CPP" @("clang++", "g++")
Ensure-EnvPath "INTERTON_CSHARP" @("csc", "mcs", "dotnet", "interton-ffi-csharp", "interton_csharp_runner")
Ensure-EnvPath "INTERTON_JAVA" @("javac", "interton-ffi-java", "interton_java_runner")

function Get-ForeignLangs([string]$path) {
    $content = Get-Content -Path $path -Raw
    $matches = [regex]::Matches($content, "adding\s*<(?<lang>[A-Za-z_][\w]*)>")
    $langs = @()
    foreach ($m in $matches) {
        $langs += $m.Groups["lang"].Value
    }
    return $langs | Select-Object -Unique
}

function Get-LangEnv([string]$lang) {
    switch ($lang) {
        "py" { return "INTERTON_PY" }
        "js" { return "INTERTON_NODE" }
        "ts" { return "INTERTON_TS" }
        "c" { return "INTERTON_C" }
        "cpp" { return "INTERTON_CPP" }
        "cs" { return "INTERTON_CSHARP" }
        "j" { return "INTERTON_JAVA" }
        default { return "" }
    }
}

$examples = Get-ChildItem -Path (Join-Path $repoRoot "examples") -Recurse -Filter "*.it" |
    Where-Object { $_.FullName -notmatch "\\modules\\" } |
    Sort-Object FullName

$passed = 0
$failed = 0
$skipped = 0

foreach ($example in $examples) {
    $langs = Get-ForeignLangs $example.FullName
    $missing = @()
    foreach ($lang in $langs) {
        $envName = Get-LangEnv $lang
        if ($envName -and -not [Environment]::GetEnvironmentVariable($envName)) {
            $missing += "$lang ($envName)"
        }
    }

    if ($missing.Count -gt 0) {
        "- SKIP: $($example.FullName) (missing: $($missing -join ", "))" | Out-File -FilePath $resultsFile -Append -Encoding utf8
        $skipped++
        continue
    }

    "- RUN: $($example.FullName)" | Out-File -FilePath $resultsFile -Append -Encoding utf8
    $prevErrorAction = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    & $compiler --run $example.FullName 2>&1 | Tee-Object -FilePath $resultsFile -Append | Out-Null
    $exitCode = $LASTEXITCODE
    $ErrorActionPreference = $prevErrorAction
    if ($exitCode -ne 0) {
        "  Status: FAILED" | Out-File -FilePath $resultsFile -Append -Encoding utf8
        $failed++
    } else {
        "  Status: PASSED" | Out-File -FilePath $resultsFile -Append -Encoding utf8
        $passed++
    }
    "" | Out-File -FilePath $resultsFile -Append -Encoding utf8
}

"" | Out-File -FilePath $resultsFile -Append -Encoding utf8
"## Summary" | Out-File -FilePath $resultsFile -Append -Encoding utf8
"- Passed: $passed" | Out-File -FilePath $resultsFile -Append -Encoding utf8
"- Failed: $failed" | Out-File -FilePath $resultsFile -Append -Encoding utf8
"- Skipped: $skipped" | Out-File -FilePath $resultsFile -Append -Encoding utf8

Write-Host "Examples run completed. Summary: $resultsFile"
