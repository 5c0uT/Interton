$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) {
    Write-Error "Python not found"
    exit 1
}
python examples/measure.py --compare
