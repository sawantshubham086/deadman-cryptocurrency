const { ethers } = require("hardhat");

async function main() {
  console.log("🚀 Starting deployment of MyCryptocurrency and Staking contracts...\n");

  // Get the deployer account
  const [deployer] = await ethers.getSigners();
  console.log("📝 Deploying contracts with account:", deployer.address);
  
  // Check deployer balance
  const balance = await deployer.getBalance();
  console.log("💰 Account balance:", ethers.utils.formatEther(balance), "ETH\n");

  // Token configuration
  const TOKEN_NAME = "DEADMAN";
  const TOKEN_SYMBOL = "DEAD";

  try {
    // Deploy the token contract
    console.log("🪙 Deploying MyCryptocurrency token...");
    const MyCryptocurrency = await ethers.getContractFactory("MyCryptocurrency");
    const token = await MyCryptocurrency.deploy(TOKEN_NAME, TOKEN_SYMBOL);
    await token.deployed();
    
    console.log("✅ MyCryptocurrency deployed to:", token.address);
    console.log("🔗 Transaction hash:", token.deployTransaction.hash);

    // Deploy the staking contract
    console.log("\n🏦 Deploying CryptocurrencyStaking contract...");
    const CryptocurrencyStaking = await ethers.getContractFactory("CryptocurrencyStaking");
    const staking = await CryptocurrencyStaking.deploy(token.address);
    await staking.deployed();
    
    console.log("✅ CryptocurrencyStaking deployed to:", staking.address);
    console.log("🔗 Transaction hash:", staking.deployTransaction.hash);

    // Get token info
    const name = await token.name();
    const symbol = await token.symbol();
    const decimals = await token.decimals();
    const totalSupply = await token.totalSupply();
    const maxSupply = await token.MAX_SUPPLY();

    console.log("\n📊 Token Information:");
    console.log("├─ Name:", name);
    console.log("├─ Symbol:", symbol);
    console.log("├─ Decimals:", decimals);
    console.log("├─ Initial Supply:", ethers.utils.formatEther(totalSupply));
    console.log("└─ Max Supply:", ethers.utils.formatEther(maxSupply));

    // Fund the staking contract with rewards (10% of initial supply)
    const rewardAmount = totalSupply.div(10); // 10% for rewards
    console.log("\n💸 Funding staking contract with rewards...");
    console.log("└─ Reward amount:", ethers.utils.formatEther(rewardAmount), TOKEN_SYMBOL);
    
    // Approve staking contract to spend tokens
    const approveTx = await token.approve(staking.address, rewardAmount);
    await approveTx.wait();
    console.log("✅ Approved staking contract to spend tokens");
    
    // Fund the reward pool
    const fundTx = await staking.fundRewardPool(rewardAmount);
    await fundTx.wait();
    console.log("✅ Reward pool funded successfully");

    // Contract addresses for easy access
    console.log("\n🎯 Contract Addresses (Save these!):");
    console.log("├─ Token Contract:", token.address);
    console.log("└─ Staking Contract:", staking.address);

    console.log("\n🔧 Next Steps:");
    console.log("1. Add tokens to MetaMask:");
    console.log("   └─ Contract Address:", token.address);
    console.log("   └─ Symbol:", TOKEN_SYMBOL);
    console.log("   └─ Decimals:", decimals);
    console.log("2. Get testnet ETH from faucets");
    console.log("3. Interact with contracts using frontend or Etherscan");

    // Save deployment info
    const deploymentInfo = {
      network: hre.network.name,
      deployer: deployer.address,
      contracts: {
        token: {
          address: token.address,
          name: TOKEN_NAME,
          symbol: TOKEN_SYMBOL,
          txHash: token.deployTransaction.hash
        },
        staking: {
          address: staking.address,
          txHash: staking.deployTransaction.hash
        }
      },
      timestamp: new Date().toISOString()
    };

    // Write deployment info to file
    const fs = require('fs');
    const path = require('path');
    const deploymentPath = path.join(__dirname, '..', 'docs', 'deployment.json');
    fs.writeFileSync(deploymentPath, JSON.stringify(deploymentInfo, null, 2));
    console.log("\n📋 Deployment info saved to: docs/deployment.json");

  } catch (error) {
    console.error("\n❌ Deployment failed:", error.message);
    process.exitCode = 1;
  }
}

// Handle errors
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});