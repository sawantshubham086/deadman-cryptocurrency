@echo off
echo 💀 DEADMAN Cryptocurrency - Local Deployment
echo ==========================================
echo.

echo 🚀 Deploying DEADMAN to your local blockchain...
echo 📋 Make sure your Hardhat node is running in another terminal!
echo.

npx hardhat run scripts/deploy-local.js --network localhost

echo.
if %errorlevel% equ 0 (
    echo ✅ DEADMAN deployment successful!
    echo 💀 Your cryptocurrency is ready to use!
    echo.
    echo 📋 Next steps:
    echo 1. Check docs/deployment-local.json for contract addresses
    echo 2. Add DEADMAN token to MetaMask using the contract address
    echo 3. Import one of the test accounts to MetaMask
    echo 4. Start testing your cryptocurrency!
) else (
    echo ❌ Deployment failed. Check the error messages above.
)

echo.
pause