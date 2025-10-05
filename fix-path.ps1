Write-Host "Adding Node.js to PATH temporarily..." -ForegroundColor Yellow

# Add Node.js to PATH for this session
$env:PATH += ";C:\Program Files\nodejs"

Write-Host "Testing Node.js commands..." -ForegroundColor Cyan

try {
    $nodeVersion = node --version
    Write-Host "Node.js version: $nodeVersion" -ForegroundColor Green
    
    $npmVersion = npm --version  
    Write-Host "npm version: $npmVersion" -ForegroundColor Green
    
    Write-Host "`nNode.js is now working!" -ForegroundColor Green
    Write-Host "You can now run your DEADMAN deployment:" -ForegroundColor Cyan
    Write-Host "npx hardhat run scripts/deploy-local.js --network localhost" -ForegroundColor White
    
} catch {
    Write-Host "Still having issues accessing Node.js" -ForegroundColor Red
    Write-Host "You may need to reinstall Node.js" -ForegroundColor Yellow
}

Read-Host "`nPress Enter to continue"