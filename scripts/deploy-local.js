const { ethers } = require("hardhat");

async function main() {
  console.log("🚀 Starting LOCAL deployment of DEADMAN and Staking contracts...\n");

  // Get the deployer account
  const [deployer] = await ethers.getSigners();
  console.log("📝 Deploying contracts with account:", deployer.address);
  
  // Check deployer balance
  const balance = await ethers.provider.getBalance(deployer.address);
  console.log("💰 Account balance:", ethers.formatEther(balance), "ETH\n");

  // Token configuration
  const TOKEN_NAME = "DEADMAN";
  const TOKEN_SYMBOL = "DEAD";

  try {
    // Deploy the token contract
    console.log("💀 Deploying DEADMAN token...");
    const MyCryptocurrency = await ethers.getContractFactory("MyCryptocurrency");
    const token = await MyCryptocurrency.deploy(TOKEN_NAME, TOKEN_SYMBOL);
    await token.waitForDeployment();
    
    console.log("✅ DEADMAN deployed to:", await token.getAddress());
    console.log("🔗 Transaction hash:", token.deploymentTransaction().hash);

    // Deploy the staking contract
    console.log("\n🏦 Deploying DEADMAN Staking contract...");
    const CryptocurrencyStaking = await ethers.getContractFactory("CryptocurrencyStaking");
    const staking = await CryptocurrencyStaking.deploy(await token.getAddress());
    await staking.waitForDeployment();
    
    console.log("✅ DEADMAN Staking deployed to:", await staking.getAddress());
    console.log("🔗 Transaction hash:", staking.deploymentTransaction().hash);

    // Get token info
    const name = await token.name();
    const symbol = await token.symbol();
    const decimals = await token.decimals();
    const totalSupply = await token.totalSupply();
    const maxSupply = await token.MAX_SUPPLY();

    console.log("\n📊 DEADMAN Token Information:");
    console.log("├─ Name:", name);
    console.log("├─ Symbol:", symbol);
    console.log("├─ Decimals:", decimals);
    console.log("├─ Initial Supply:", ethers.formatEther(totalSupply));
    console.log("└─ Max Supply:", ethers.formatEther(maxSupply));

    // Fund the staking contract with rewards (10% of initial supply)
    const rewardAmount = totalSupply / 10n; // 10% for rewards
    console.log("\n💸 Funding staking contract with rewards...");
    console.log("└─ Reward amount:", ethers.formatEther(rewardAmount), TOKEN_SYMBOL);
    
    // Approve staking contract to spend tokens
    const approveTx = await token.approve(await staking.getAddress(), rewardAmount);
    await approveTx.wait();
    console.log("✅ Approved staking contract to spend tokens");
    
    // Fund the reward pool
    const fundTx = await staking.fundRewardPool(rewardAmount);
    await fundTx.wait();
    console.log("✅ Reward pool funded successfully");

    // Contract addresses for easy access
    console.log("\n🎯 Contract Addresses (Save these!):");
    console.log("├─ DEADMAN Token:", await token.getAddress());
    console.log("└─ DEADMAN Staking:", await staking.getAddress());

    console.log("\n🔧 Next Steps:");
    console.log("1. Add tokens to MetaMask:");
    console.log("   └─ Contract Address:", await token.getAddress());
    console.log("   └─ Symbol:", TOKEN_SYMBOL);
    console.log("   └─ Decimals:", decimals);
    console.log("2. Start custom blockchain: npm run start-blockchain");
    console.log("3. Test staking functionality");

    // Save deployment info
    const deploymentInfo = {
      network: "localhost",
      deployer: deployer.address,
      contracts: {
        token: {
          address: await token.getAddress(),
          name: TOKEN_NAME,
          symbol: TOKEN_SYMBOL,
          txHash: token.deploymentTransaction().hash
        },
        staking: {
          address: await staking.getAddress(),
          txHash: staking.deploymentTransaction().hash
        }
      },
      timestamp: new Date().toISOString()
    };

    // Write deployment info to file
    const fs = require('fs');
    const path = require('path');
    
    // Ensure docs directory exists
    const docsDir = path.join(__dirname, '..', 'docs');
    if (!fs.existsSync(docsDir)) {
      fs.mkdirSync(docsDir, { recursive: true });
    }
    
    const deploymentPath = path.join(docsDir, 'deployment-local.json');
    fs.writeFileSync(deploymentPath, JSON.stringify(deploymentInfo, null, 2));
    console.log("\n📋 Local deployment info saved to: docs/deployment-local.json");

    console.log("\n🎉 LOCAL DEPLOYMENT SUCCESSFUL!");
    console.log("💀 Your DEADMAN cryptocurrency is ready to use!");

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