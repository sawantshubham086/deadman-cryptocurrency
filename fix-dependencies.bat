@echo off
echo 🔧 Fixing DEADMAN Cryptocurrency Dependencies...
echo.

echo 📦 Removing old OpenZeppelin contracts...
npm uninstall @openzeppelin/contracts

echo 📦 Installing compatible OpenZeppelin contracts v4.9.0...
npm install @openzeppelin/contracts@4.9.0

echo.
echo ✅ Dependencies fixed! Now try compiling:
echo    npx hardhat compile
echo.
pause