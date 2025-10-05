Write-Host "DEADMAN Blockchain - Simple Start" -ForegroundColor Red
Write-Host "=================================" -ForegroundColor Red

# Fix PATH
$env:PATH = $env:PATH + ";C:\Program Files\nodejs"

# Verify Node.js
try {
    $nodeVersion = node --version
    Write-Host "Node.js: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "Node.js not accessible" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Starting DEADMAN blockchain..." -ForegroundColor Yellow
Write-Host "Visit: http://localhost:3001" -ForegroundColor Cyan
Write-Host ""

# Start without complex test transactions
$env:SKIP_TEST_TRANSACTIONS = "true"
node blockchain/index.js