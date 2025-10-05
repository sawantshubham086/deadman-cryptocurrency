Write-Host "DEADMAN Custom Blockchain Explorer" -ForegroundColor Red
Write-Host "==========================================" -ForegroundColor Red

# Fix PATH (handle spaces in path properly)
Write-Host "Setting up Node.js PATH..." -ForegroundColor Yellow
$env:PATH = $env:PATH + ";C:\Program Files\nodejs"

# Verify Node.js
try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js not accessible" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Starting DEADMAN blockchain explorer..." -ForegroundColor Yellow
Write-Host "This will start a web server at http://localhost:3001" -ForegroundColor Cyan
Write-Host "Use the web interface to:" -ForegroundColor Red
Write-Host "   • Generate DEAD wallets" -ForegroundColor White
Write-Host "   • Send DEAD transactions" -ForegroundColor White
Write-Host "   • Mine DEAD blocks" -ForegroundColor White
Write-Host "   • Check DEAD balances" -ForegroundColor White
Write-Host ""

# Start the custom blockchain
node blockchain/index.js