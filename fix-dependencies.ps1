Write-Host "🔧 Fixing DEADMAN Cryptocurrency Dependencies..." -ForegroundColor Yellow
Write-Host ""

Write-Host "📦 Removing old OpenZeppelin contracts..." -ForegroundColor Cyan
npm uninstall @openzeppelin/contracts

Write-Host "📦 Installing compatible OpenZeppelin contracts v4.9.0..." -ForegroundColor Cyan
npm install @openzeppelin/contracts@4.9.0

Write-Host ""
Write-Host "✅ Dependencies fixed! Now try compiling:" -ForegroundColor Green
Write-Host "   npx hardhat compile" -ForegroundColor White
Write-Host ""
Read-Host "Press Enter to continue"