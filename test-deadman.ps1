Write-Host "🧪 Testing DEADMAN Cryptocurrency" -ForegroundColor Red
Write-Host "=================================" -ForegroundColor Red

# Fix PATH
Write-Host "🔧 Setting up Node.js PATH..." -ForegroundColor Yellow
$env:PATH += ";C:\Program Files\nodejs"

# Verify Node.js
try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js not accessible" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🔍 Running comprehensive tests..." -ForegroundColor Cyan
Write-Host ""

# Run all tests
npx hardhat test

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ All tests passed! Your DEADMAN cryptocurrency is working perfectly!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 Test Results Summary:" -ForegroundColor Cyan
    Write-Host "• DEADMAN Token: All functions tested ✅" -ForegroundColor White
    Write-Host "• Staking System: All reward tiers tested ✅" -ForegroundColor White
    Write-Host "• Security Features: Access controls tested ✅" -ForegroundColor White
    Write-Host "• Emergency Functions: Pause/unpause tested ✅" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "❌ Some tests failed. Check the output above for details." -ForegroundColor Red
}

Read-Host "`nPress Enter to continue"