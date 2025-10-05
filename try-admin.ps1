Write-Host "🔍 Checking for Node.js in different locations..." -ForegroundColor Yellow

# Check common Node.js installation paths
$possiblePaths = @(
    "C:\Program Files\nodejs\",
    "C:\Program Files (x86)\nodejs\",
    "$env:APPDATA\npm\",
    "$env:LOCALAPPDATA\Programs\nodejs\"
)

foreach ($path in $possiblePaths) {
    if (Test-Path $path) {
        Write-Host "✅ Found Node.js at: $path" -ForegroundColor Green
        $env:PATH += ";$path"
    }
}

# Test if commands work now
Write-Host "`n🧪 Testing Node.js commands..." -ForegroundColor Cyan

try {
    $nodeVersion = & node --version 2>$null
    if ($nodeVersion) {
        Write-Host "✅ Node.js version: $nodeVersion" -ForegroundColor Green
    } else {
        Write-Host "❌ Node.js not found" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Node.js not accessible" -ForegroundColor Red
}

try {
    $npmVersion = & npm --version 2>$null
    if ($npmVersion) {
        Write-Host "✅ npm version: $npmVersion" -ForegroundColor Green
    } else {
        Write-Host "❌ npm not found" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ npm not accessible" -ForegroundColor Red
}

Write-Host "`n📋 Next steps:" -ForegroundColor Yellow
Write-Host "1. If Node.js was found above, try running the deployment again" -ForegroundColor White
Write-Host "2. If not found, install Node.js from https://nodejs.org/" -ForegroundColor White
Write-Host "3. Make sure to restart PowerShell after installation" -ForegroundColor White

Read-Host "`nPress Enter to continue"