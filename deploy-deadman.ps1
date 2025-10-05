Write-Host "💀 DEADMAN Deployment Script" -ForegroundColor Red
Write-Host "============================" -ForegroundColor Red

# Fix PATH
Write-Host "🔧 Setting up Node.js PATH..." -ForegroundColor Yellow
$env:PATH += ";C:\Program Files\nodejs"

# Verify Node.js
try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js not accessible. Run fix-path.ps1 first" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🚀 Deploying DEADMAN to local blockchain..." -ForegroundColor Yellow
Write-Host "📋 Make sure the blockchain is running in another window!" -ForegroundColor Cyan
Write-Host ""

try {
    # Deploy to localhost
    npx hardhat run scripts/deploy-local.js --network localhost
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "🎉 DEADMAN DEPLOYED SUCCESSFULLY!" -ForegroundColor Green
        Write-Host "💀 Your cryptocurrency is ready!" -ForegroundColor Red
        Write-Host ""
        Write-Host "📋 Next steps:" -ForegroundColor Cyan
        Write-Host "1. Check docs/deployment-local.json for contract addresses" -ForegroundColor White
        Write-Host "2. Add DEADMAN to MetaMask:" -ForegroundColor White
        Write-Host "   - Network: Localhost 8545" -ForegroundColor Gray
        Write-Host "   - Chain ID: 1337" -ForegroundColor Gray
        Write-Host "3. Import test account to MetaMask:" -ForegroundColor White
        Write-Host "   - Address: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" -ForegroundColor Gray
        Write-Host "   - Private Key: 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80" -ForegroundColor Gray
        Write-Host ""
        Write-Host "💡 To start custom blockchain explorer:" -ForegroundColor Yellow
        Write-Host "   node blockchain/index.js" -ForegroundColor White
    }
} catch {
    Write-Host "❌ Deployment failed: $($_.Exception.Message)" -ForegroundColor Red
}

Read-Host "`nPress Enter to continue"