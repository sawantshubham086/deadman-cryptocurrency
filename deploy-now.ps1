Write-Host "💀 DEADMAN Cryptocurrency - Local Deployment" -ForegroundColor Red
Write-Host "==========================================" -ForegroundColor Red
Write-Host ""

Write-Host "🚀 Deploying DEADMAN to your local blockchain..." -ForegroundColor Yellow
Write-Host "📋 Make sure your Hardhat node is running in another terminal!" -ForegroundColor Cyan
Write-Host ""

try {
    # Deploy to localhost network
    & npx hardhat run scripts/deploy-local.js --network localhost
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✅ DEADMAN deployment successful!" -ForegroundColor Green
        Write-Host "💀 Your cryptocurrency is ready to use!" -ForegroundColor Red
        Write-Host ""
        Write-Host "📋 Next steps:" -ForegroundColor Cyan
        Write-Host "1. Check docs/deployment-local.json for contract addresses" -ForegroundColor White
        Write-Host "2. Add DEADMAN token to MetaMask using the contract address" -ForegroundColor White
        Write-Host "3. Import one of the test accounts to MetaMask:" -ForegroundColor White
        Write-Host "   Account #0: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" -ForegroundColor Gray
        Write-Host "   Private Key: 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80" -ForegroundColor Gray
        Write-Host "4. Start testing your cryptocurrency!" -ForegroundColor White
        Write-Host ""
        Write-Host "💡 To start the custom blockchain explorer:" -ForegroundColor Yellow
        Write-Host "   npx node blockchain/index.js" -ForegroundColor White
    } else {
        Write-Host ""
        Write-Host "❌ Deployment failed. Check the error messages above." -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Error occurred during deployment: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Read-Host 'Press Enter to continue'