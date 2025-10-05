Write-Host "Checking Node.js installation..." -ForegroundColor Yellow

# Check if commands exist
$nodeExists = Get-Command node -ErrorAction SilentlyContinue
$npmExists = Get-Command npm -ErrorAction SilentlyContinue
$npxExists = Get-Command npx -ErrorAction SilentlyContinue

if ($nodeExists) {
    Write-Host "Node.js: FOUND" -ForegroundColor Green
    try {
        $nodeVersion = node --version
        Write-Host "Version: $nodeVersion" -ForegroundColor Cyan
    } catch {
        Write-Host "Cannot get version" -ForegroundColor Red
    }
} else {
    Write-Host "Node.js: NOT FOUND" -ForegroundColor Red
}

if ($npmExists) {
    Write-Host "npm: FOUND" -ForegroundColor Green
} else {
    Write-Host "npm: NOT FOUND" -ForegroundColor Red
}

if ($npxExists) {
    Write-Host "npx: FOUND" -ForegroundColor Green
} else {
    Write-Host "npx: NOT FOUND" -ForegroundColor Red
}

# Check common installation paths
Write-Host "`nChecking installation paths..." -ForegroundColor Yellow
$paths = @(
    "C:\Program Files\nodejs",
    "C:\Program Files (x86)\nodejs"
)

foreach ($path in $paths) {
    if (Test-Path $path) {
        Write-Host "Found directory: $path" -ForegroundColor Green
    }
}

Write-Host "`nResult:" -ForegroundColor Cyan
if ($nodeExists -and $npmExists -and $npxExists) {
    Write-Host "Node.js is properly installed!" -ForegroundColor Green
    Write-Host "You can now deploy DEADMAN cryptocurrency!" -ForegroundColor Green
} else {
    Write-Host "Node.js needs to be installed" -ForegroundColor Red
    Write-Host "Download from: https://nodejs.org" -ForegroundColor Yellow
}

Read-Host "`nPress Enter to continue"