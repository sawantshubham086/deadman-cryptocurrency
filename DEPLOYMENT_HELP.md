# 💀 DEADMAN Deployment Troubleshooting Guide

## Issue: npx/node not recognized

You successfully ran `npx hardhat node` before, but now commands aren't working.

## Solution Options:

### Option 1: Use the Same Terminal
- **Go back to the terminal where you ran `npx hardhat node`**
- **Open a NEW tab/window in that same terminal**
- **Navigate to your project:** `cd C:\Users\sawan\OneDrive\Documents\quoder\cryptocurrency`
- **Run deployment:** `npx hardhat run scripts/deploy-local.js --network localhost`

### Option 2: Fix Node.js PATH
1. **Check if Node.js is installed:**
   - Press `Win + R`, type `cmd`, press Enter
   - Type: `where node`
   - If it shows a path, Node.js is installed

2. **Add to PATH (if needed):**
   - Search "Environment Variables" in Windows
   - Click "Environment Variables"
   - Under "System Variables", find "Path"
   - Add Node.js installation directory (usually `C:\Program Files\nodejs\`)

### Option 3: Fresh Node.js Installation
1. **Download Node.js:** https://nodejs.org/
2. **Install the LTS version**
3. **Restart your terminal**
4. **Test:** `node --version`

### Option 4: Alternative Deployment
If you can access the Hardhat console:
1. **In the terminal running the Hardhat node, press Ctrl+C**
2. **Run:** `npx hardhat console --network localhost`
3. **Copy and paste this deployment code:**

```javascript
const { ethers } = require("hardhat");

async function deployDEADMAN() {
  console.log("💀 Deploying DEADMAN...");
  
  const [deployer] = await ethers.getSigners();
  console.log("Deploying from:", deployer.address);
  
  // Deploy token
  const MyCryptocurrency = await ethers.getContractFactory("MyCryptocurrency");
  const token = await MyCryptocurrency.deploy("DEADMAN", "DEAD");
  await token.deployed();
  console.log("✅ DEADMAN Token:", token.address);
  
  // Deploy staking
  const CryptocurrencyStaking = await ethers.getContractFactory("CryptocurrencyStaking");
  const staking = await CryptocurrencyStaking.deploy(token.address);
  await staking.deployed();
  console.log("✅ DEADMAN Staking:", staking.address);
  
  return { token, staking };
}

deployDEADMAN();
```

## Quick Test:
**Can you run this in PowerShell?**
```powershell
Get-Command node -ErrorAction SilentlyContinue
Get-Command npm -ErrorAction SilentlyContinue  
Get-Command npx -ErrorAction SilentlyContinue
```

## Most Likely Solution:
**Use the same terminal/command prompt where `npx hardhat node` worked!**

Your DEADMAN cryptocurrency is ready to deploy - we just need to use the right environment! 💀