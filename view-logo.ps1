Write-Host "💀 DEADMAN Logo Viewer" -ForegroundColor Red
Write-Host "=====================" -ForegroundColor Red

# Fix PATH
Write-Host "🔧 Setting up Node.js PATH..." -ForegroundColor Yellow
$env:PATH += ";C:\Program Files\nodejs"

Write-Host ""
Write-Host "🌐 Starting DEADMAN frontend with new logo..." -ForegroundColor Cyan
Write-Host "📋 Open your browser and go to:" -ForegroundColor Yellow
Write-Host "   http://localhost:3001" -ForegroundColor White
Write-Host ""
Write-Host "💀 Features to check:" -ForegroundColor Red
Write-Host "• New DEADMAN skull logo in header" -ForegroundColor White
Write-Host "• Glowing red eyes animation" -ForegroundColor White
Write-Host "• Professional dark theme" -ForegroundColor White
Write-Host "• Favicon in browser tab" -ForegroundColor White
Write-Host ""

# Check if custom blockchain is running, if not start frontend server
try {
    # Try to start the custom blockchain (includes frontend)
    node blockchain/index.js
} catch {
    Write-Host "⚠️  Custom blockchain not available, starting simple HTTP server..." -ForegroundColor Yellow
    
    # Start a simple HTTP server for the frontend
    cd frontend
    if (Get-Command python -ErrorAction SilentlyContinue) {
        python -m http.server 3001
    } elseif (Get-Command python3 -ErrorAction SilentlyContinue) {
        python3 -m http.server 3001
    } else {
        Write-Host "❌ Need Python or Node.js server to view the logo" -ForegroundColor Red
        Write-Host "💡 Alternative: Open frontend/index.html directly in browser" -ForegroundColor Yellow
    }
}

Read-Host "`nPress Enter to continue"