require("@nomicfoundation/hardhat-toolbox");

// Replace with your private key (use environment variables in production)
const PRIVATE_KEY = process.env.PRIVATE_KEY || "your_private_key_here";
const INFURA_API_KEY = process.env.INFURA_API_KEY || "your_infura_api_key";

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.19",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  networks: {
    // Local development network
    hardhat: {
      chainId: 1337
    },
    // Ethereum Sepolia testnet (FREE)
    sepolia: {
      url: `https://sepolia.infura.io/v3/${INFURA_API_KEY}`,
      accounts: PRIVATE_KEY !== "your_private_key_here" ? [PRIVATE_KEY] : [],
      chainId: 11155111,
      gasPrice: 20000000000, // 20 gwei
    },
    // Polygon Mumbai testnet (FREE)
    mumbai: {
      url: "https://rpc-mumbai.maticvigil.com",
      accounts: PRIVATE_KEY !== "your_private_key_here" ? [PRIVATE_KEY] : [],
      chainId: 80001,
      gasPrice: 20000000000,
    },
    // BSC Testnet (FREE)
    bscTestnet: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545",
      accounts: PRIVATE_KEY !== "your_private_key_here" ? [PRIVATE_KEY] : [],
      chainId: 97,
      gasPrice: 20000000000,
    }
  },
  etherscan: {
    apiKey: {
      sepolia: process.env.ETHERSCAN_API_KEY || "",
      polygonMumbai: process.env.POLYGONSCAN_API_KEY || "",
      bscTestnet: process.env.BSCSCAN_API_KEY || ""
    }
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  }
};