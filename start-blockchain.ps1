Write-Host "💀 DEADMAN Cryptocurrency - Complete Deployment" -ForegroundColor Red
Write-Host "=============================================" -ForegroundColor Red

# Fix PATH
Write-Host "🔧 Setting up Node.js PATH..." -ForegroundColor Yellow
$env:PATH += ";C:\Program Files\nodejs"

# Verify Node.js
try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js still not accessible" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🚀 Starting local blockchain..." -ForegroundColor Yellow
Write-Host "📋 This will show account information and keep running" -ForegroundColor Cyan
Write-Host "📋 After you see accounts listed, open a NEW PowerShell window" -ForegroundColor Cyan
Write-Host "📋 In the new window, run: .\deploy-deadman.ps1" -ForegroundColor Green
Write-Host ""

# Start Hardhat node
npx hardhat node