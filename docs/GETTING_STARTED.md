# 🚀 Getting Started with DEADMAN Cryptocurrency

## Prerequisites

Before you begin, make sure you have the following installed:
- **Node.js** (v16 or higher) - [Download here](https://nodejs.org/)
- **Git** - [Download here](https://git-scm.com/)
- **Code Editor** (VS Code recommended)

## 📋 Quick Setup Guide

### 1. Install Dependencies

```bash
# Navigate to project directory
cd cryptocurrency

# Install all dependencies
npm install
```

### 2. Environment Setup

```bash
# Copy environment template
cp .env.example .env

# Edit .env file with your configuration
# For testing, you can leave most values as default
```

### 3. Compile Smart Contracts

```bash
# Compile contracts
npm run compile
```

### 4. Run Tests

```bash
# Run all tests
npm run test
```

## 🚀 Running the Project

### Option 1: ERC-20 Token on Testnet (Recommended for beginners)

1. **Get Test ETH:**
   - Visit [Sepolia Faucet](https://sepoliafaucet.com/)
   - Enter your wallet address to get free test ETH

2. **Deploy to Testnet:**
   ```bash
   # Make sure you have test ETH in your wallet
   npm run deploy-testnet
   ```

3. **Verify Deployment:**
   - Check [Sepolia Etherscan](https://sepolia.etherscan.io/)
   - Search for your contract address

### Option 2: Custom Blockchain (Advanced)

1. **Start the Blockchain:**
   ```bash
   npm run start-blockchain
   ```

2. **Open the Web Interface:**
   - Go to http://localhost:3001
   - Use the interface to create wallets and send transactions

## 🛠️ Development Workflow

### Testing Smart Contracts

```bash
# Run tests
npm run test

# Run tests with coverage
npx hardhat coverage

# Run specific test file
npx hardhat test test/MyCryptocurrency.test.js
```

### Local Development

```bash
# Start local Hardhat network
npx hardhat node

# Deploy to local network (new terminal)
npx hardhat run scripts/deploy.js --network localhost
```

### Contract Interaction

```bash
# Open Hardhat console
npx hardhat console --network sepolia

# Example interactions:
# const token = await ethers.getContractAt("MyCryptocurrency", "CONTRACT_ADDRESS");
# await token.balanceOf("WALLET_ADDRESS");
```

## 🔧 Configuration

### Network Configuration

Edit `hardhat.config.js` to add new networks:

```javascript
networks: {
  myNetwork: {
    url: "RPC_URL",
    accounts: [PRIVATE_KEY],
    chainId: CHAIN_ID
  }
}
```

### Token Configuration

Edit deployment script `scripts/deploy.js`:

```javascript
const TOKEN_NAME = "DEADMAN";
const TOKEN_SYMBOL = "DEAD";
```

## 📊 Using the Web Interface

### Custom Blockchain Features:

1. **Generate Wallet:**
   - Click "Generate New Wallet"
   - Save your private key securely!

2. **Send Transactions:**
   - Fill in from/to addresses
   - Enter amount and private key
   - Click "Send Transaction"

3. **Mine Blocks:**
   - Enter your wallet address as miner
   - Click "Mine Block" to earn rewards

4. **Check Balances:**
   - Enter any wallet address
   - View current balance

## 🏦 Staking System

### How to Stake (on testnet):

1. **Approve Tokens:**
   ```javascript
   await token.approve(stakingAddress, amount);
   ```

2. **Stake Tokens:**
   ```javascript
   await staking.stake(amount, period); // 0=Daily, 1=Weekly, 2=Monthly
   ```

3. **Claim Rewards:**
   ```javascript
   await staking.claimReward(stakeIndex);
   ```

4. **Unstake:**
   ```javascript
   await staking.unstake(stakeIndex);
   ```

### Staking Periods & Rewards:

- **Daily:** 0.27% daily (≈10% annual)
- **Weekly:** 2% weekly (≈104% annual)
- **Monthly:** 9% monthly (≈108% annual)

## 🔍 Troubleshooting

### Common Issues:

#### "Insufficient funds for gas"
- Make sure you have enough ETH for gas fees
- Get more test ETH from faucets

#### "Transaction reverted"
- Check contract address is correct
- Ensure you have enough token balance
- Verify function parameters

#### "Network error"
- Check your internet connection
- Verify RPC URL is working
- Try switching networks

#### "Private key error"
- Ensure private key is 64 characters (32 bytes in hex)
- Don't include '0x' prefix in .env file
- Make sure private key matches the address

### Debug Commands:

```bash
# Check contract on testnet
npx hardhat verify --network sepolia CONTRACT_ADDRESS "TokenName" "SYMBOL"

# Check gas prices
npx hardhat run scripts/check-gas.js --network sepolia

# Check account balance
npx hardhat run scripts/check-balance.js --network sepolia
```

## 📱 MetaMask Integration

### Add Custom Token:

1. Open MetaMask
2. Click "Import Tokens"
3. Enter contract address
4. Symbol and decimals should auto-fill

### Add Testnet Networks:

**Sepolia:**
- Network Name: Sepolia
- RPC URL: https://sepolia.infura.io/v3/YOUR_KEY
- Chain ID: 11155111
- Symbol: ETH
- Explorer: https://sepolia.etherscan.io

## 🌐 Deployment to Mainnet

⚠️ **WARNING:** Mainnet deployment costs real money!

### Before Mainnet:

1. **Thorough Testing:**
   ```bash
   npm run test
   npx hardhat coverage
   ```

2. **Security Audit:**
   - Review all smart contracts
   - Check for common vulnerabilities
   - Consider professional audit

3. **Gas Optimization:**
   ```bash
   npx hardhat gas-reporter
   ```

### Mainnet Deployment:

```bash
# Deploy to Ethereum mainnet
npm run deploy --network mainnet

# Deploy to Polygon
npm run deploy --network polygon

# Deploy to BSC
npm run deploy --network bsc
```

## 🔐 Security Best Practices

### Private Key Management:
- Never commit private keys to code
- Use hardware wallets for mainnet
- Consider multi-sig wallets for important contracts

### Smart Contract Security:
- Always use latest OpenZeppelin contracts
- Implement proper access controls
- Add circuit breakers (pause functionality)
- Test edge cases thoroughly

### Environment Security:
- Use environment variables
- Rotate API keys regularly
- Limit access to production systems

## 📈 Next Steps

### Enhancements to Consider:

1. **Advanced Features:**
   - Governance tokens
   - Liquidity pools
   - NFT integration
   - Cross-chain bridges

2. **Infrastructure:**
   - IPFS integration
   - Oracle integration
   - Layer 2 solutions

3. **Frontend Improvements:**
   - React/Vue.js interface
   - Mobile app
   - Real-time updates

4. **Business Features:**
   - Token vesting
   - Airdrops
   - Revenue sharing

## 🆘 Support

### Getting Help:

1. **Documentation:** Read all README files
2. **Tests:** Look at test files for usage examples
3. **Community:** Join blockchain developer communities
4. **Stack Overflow:** Search for Hardhat/Solidity questions

### Useful Resources:

- [Hardhat Documentation](https://hardhat.org/docs/)
- [OpenZeppelin Docs](https://docs.openzeppelin.com/)
- [Ethereum Development](https://ethereum.org/en/developers/)
- [Solidity Documentation](https://docs.soliditylang.org/)

## 🎯 Project Structure Summary

```
cryptocurrency/
├── contracts/              # Smart contracts
│   ├── MyCryptocurrency.sol     # ERC-20 token
│   └── CryptocurrencyStaking.sol # Staking contract
├── blockchain/             # Custom blockchain
│   ├── Blockchain.js            # Core blockchain logic
│   ├── BlockchainServer.js      # API server
│   └── index.js                 # Entry point
├── frontend/               # Web interface
│   └── index.html              # Blockchain explorer
├── scripts/                # Deployment scripts
│   └── deploy.js               # Contract deployment
├── test/                   # Test files
│   ├── MyCryptocurrency.test.js
│   └── CryptocurrencyStaking.test.js
├── docs/                   # Documentation
├── hardhat.config.js       # Hardhat configuration
├── package.json           # Project dependencies
└── README.md              # Main documentation
```

---

**🎉 Congratulations!** You now have a complete cryptocurrency project with ERC-20 token, custom blockchain, and staking features. Start with the testnet deployment and explore all the features!