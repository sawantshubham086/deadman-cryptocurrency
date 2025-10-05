Write-Host "🔍 DEADMAN - Node.js Installation Checker" -ForegroundColor Red
Write-Host "=======================================" -ForegroundColor Red
Write-Host ""

# Function to check if a command exists
function Test-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# Check current PATH
Write-Host "📂 Current PATH directories:" -ForegroundColor Yellow
$env:PATH -split ';' | Where-Object { $_ -like "*node*" } | ForEach-Object {
    Write-Host "   $($_)" -ForegroundColor Gray
}

Write-Host ""

# Check for Node.js in common locations
Write-Host "🔍 Searching for Node.js installations..." -ForegroundColor Yellow
$nodePaths = @(
    "C:\Program Files\nodejs\node.exe",
    "C:\Program Files (x86)\nodejs\node.exe",
    "$env:APPDATA\npm\node.exe",
    "$env:LOCALAPPDATA\Programs\nodejs\node.exe",
    "$env:ProgramFiles\nodejs\node.exe",
    "$env:ProgramFiles(x86)\nodejs\node.exe"
)

$foundNode = $false
foreach ($path in $nodePaths) {
    if (Test-Path $path) {
        Write-Host "✅ Found Node.js at: $path" -ForegroundColor Green
        try {
            $version = & "$path" --version 2>$null
            Write-Host "   Version: $version" -ForegroundColor Cyan
            $foundNode = $true
        } catch {
            Write-Host "   ❌ Cannot execute" -ForegroundColor Red
        }
    }
}

if (-not $foundNode) {
    Write-Host "❌ Node.js not found in common locations" -ForegroundColor Red
}

Write-Host ""

# Check if commands are accessible
Write-Host "🧪 Testing command accessibility..." -ForegroundColor Yellow

$commands = @("node", "npm", "npx")
foreach ($cmd in $commands) {
    if (Test-Command $cmd) {
        try {
            $version = & $cmd --version 2>$null
            Write-Host "✅ $cmd is available - Version: $version" -ForegroundColor Green
        } catch {
            Write-Host "⚠️  $cmd found but cannot get version" -ForegroundColor Yellow
        }
    } else {
        Write-Host "❌ $cmd is not accessible" -ForegroundColor Red
    }
}

Write-Host ""

# Check Windows version for compatibility
Write-Host "💻 System Information:" -ForegroundColor Yellow
$osVersion = [System.Environment]::OSVersion.Version
Write-Host "   Windows Version: $($osVersion.Major).$($osVersion.Minor)" -ForegroundColor Gray

# Check if running as admin
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
Write-Host "   Running as Admin: $isAdmin" -ForegroundColor Gray

Write-Host ""

# Provide recommendations
Write-Host "📋 Recommendations:" -ForegroundColor Cyan

if ($foundNode -and (Test-Command "node")) {
    Write-Host "✅ Node.js is properly installed and accessible!" -ForegroundColor Green
    Write-Host "   You can now run: npx hardhat node" -ForegroundColor White
} elseif ($foundNode) {
    Write-Host "⚠️  Node.js is installed but not in PATH" -ForegroundColor Yellow
    Write-Host "   Solutions:" -ForegroundColor White
    Write-Host "   1. Restart PowerShell as Administrator" -ForegroundColor White
    Write-Host "   2. Add Node.js to PATH manually" -ForegroundColor White
    Write-Host '   3. Reinstall Node.js with "Add to PATH" option' -ForegroundColor White
} else {
    Write-Host "❌ Node.js is not installed" -ForegroundColor Red
    Write-Host "   Solutions:" -ForegroundColor White
    Write-Host "   1. Download from: https://nodejs.org/" -ForegroundColor White
    Write-Host "   2. Install with default settings" -ForegroundColor White
    Write-Host "   3. Restart PowerShell after installation" -ForegroundColor White
    Write-Host ""
    Write-Host "   Alternative quick install (if you have winget):" -ForegroundColor Cyan
    Write-Host "   winget install OpenJS.NodeJS" -ForegroundColor Gray
}

Write-Host ""
Write-Host "🚀 After fixing Node.js, you can deploy DEADMAN:" -ForegroundColor Green
Write-Host "   npx hardhat run scripts/deploy-local.js --network localhost" -ForegroundColor White

Read-Host "`nPress Enter to continue"