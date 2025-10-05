Write-Host "💀 DEADMAN Cryptocurrency Quick Start" -ForegroundColor Red
Write-Host "=====================================" -ForegroundColor Red
Write-Host ""

Write-Host "🔧 Step 1: Compiling smart contracts..." -ForegroundColor Yellow
npx hardhat compile

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Compilation successful!" -ForegroundColor Green
    Write-Host ""
    
    Write-Host "🚀 Step 2: Running tests..." -ForegroundColor Yellow
    npx hardhat test
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ All tests passed!" -ForegroundColor Green
        Write-Host ""
        
        Write-Host "📋 Choose your deployment option:" -ForegroundColor Cyan
        Write-Host "1. 🏠 Local deployment (Recommended for testing)" -ForegroundColor White
        Write-Host "2. 🌐 Custom blockchain" -ForegroundColor White
        Write-Host "3. ⚡ Testnet deployment (requires API keys)" -ForegroundColor White
        Write-Host ""
        
        $choice = Read-Host "Enter your choice (1, 2, or 3)"
        
        switch ($choice) {
            "1" {
                Write-Host ""
                Write-Host "🏠 Starting local Hardhat network..." -ForegroundColor Yellow
                Write-Host "📋 This will start a local blockchain node. Keep this terminal open!" -ForegroundColor Cyan
                Write-Host "💡 In a NEW terminal, run: npm run deploy-local" -ForegroundColor Green
                Write-Host ""
                npx hardhat node
            }
            "2" {
                Write-Host ""
                Write-Host "🌐 Starting DEADMAN custom blockchain..." -ForegroundColor Yellow
                Write-Host "📋 Visit http://localhost:3001 to use the blockchain explorer!" -ForegroundColor Cyan
                Write-Host ""
                npm run start-blockchain
            }
            "3" {
                Write-Host ""
                Write-Host "⚡ For testnet deployment, you need to:" -ForegroundColor Yellow
                Write-Host "1. Get a free Infura API key from https://infura.io" -ForegroundColor White
                Write-Host "2. Create a wallet and save your private key" -ForegroundColor White
                Write-Host "3. Get test ETH from https://sepoliafaucet.com" -ForegroundColor White
                Write-Host "4. Update .env file with your keys" -ForegroundColor White
                Write-Host "5. Run: npm run deploy-testnet" -ForegroundColor White
                Write-Host ""
            }
            default {
                Write-Host "❌ Invalid choice. Please run the script again." -ForegroundColor Red
            }
        }
    } else {
        Write-Host "❌ Tests failed. Please check the error messages above." -ForegroundColor Red
    }
} else {
    Write-Host "❌ Compilation failed. Please check the error messages above." -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit"