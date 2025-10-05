# 💀 DEADMAN - Node.js Installation Guide

## Current Issue
Your system doesn't recognize `node`, `npm`, or `npx` commands, which means Node.js is not installed or not in your PATH.

## Solution: Install Node.js

### Step 1: Download Node.js
1. **Visit:** https://nodejs.org/
2. **Download the LTS version** (Long Term Support)
3. **Choose Windows Installer (.msi)**

### Step 2: Install
1. **Run the downloaded installer**
2. **Accept all default settings**
3. **Make sure "Add to PATH" is checked**
4. **Complete the installation**

### Step 3: Verify Installation
**Restart your PowerShell/Command Prompt and run:**
```powershell
node --version
npm --version
npx --version
```

**You should see version numbers like:**
```
v18.17.0
9.6.7
9.6.7
```

### Step 4: Navigate to Project and Install Dependencies
```powershell
cd "C:\Users\sawan\OneDrive\Documents\quoder\cryptocurrency"
npm install
```

### Step 5: Deploy DEADMAN
```powershell
# Start local blockchain (in one terminal)
npx hardhat node

# Deploy DEADMAN (in another terminal)
npx hardhat run scripts/deploy-local.js --network localhost
```

## Alternative: Use Online Development Environment

If you prefer not to install Node.js locally, you can use:

1. **GitHub Codespaces** (Free with GitHub account)
2. **Replit** (Free online IDE)
3. **Gitpod** (Free online workspace)

## Quick Test After Installation

Run this to verify everything works:
```powershell
# Check versions
node --version
npm --version

# Navigate to project
cd "C:\Users\sawan\OneDrive\Documents\quoder\cryptocurrency"

# Install dependencies
npm install

# Compile contracts
npx hardhat compile

# Run tests
npx hardhat test
```

## Your DEADMAN cryptocurrency is waiting! 💀

Once Node.js is installed, your deployment should work perfectly.