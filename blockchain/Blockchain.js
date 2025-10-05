const crypto = require('crypto');
const EventEmitter = require('events');

/**
 * Individual Transaction class
 */
class Transaction {
    constructor(fromAddress, toAddress, amount, timestamp = Date.now()) {
        this.fromAddress = fromAddress;
        this.toAddress = toAddress;
        this.amount = amount;
        this.timestamp = timestamp;
        this.signature = null;
    }

    /**
     * Calculate hash of the transaction
     */
    calculateHash() {
        return crypto
            .createHash('sha256')
            .update(this.fromAddress + this.toAddress + this.amount + this.timestamp)
            .digest('hex');
    }

    /**
     * Sign transaction with private key (simplified)
     */
    signTransaction(signingKey) {
        const hashTx = this.calculateHash();
        this.signature = crypto
            .createHmac('sha256', signingKey)
            .update(hashTx)
            .digest('hex');
    }

    /**
     * Verify transaction signature
     */
    isValid() {
        if (this.fromAddress === null) return true; // Mining reward transaction

        if (!this.signature || this.signature.length === 0) {
            throw new Error('No signature in this transaction');
        }

        const hashTx = this.calculateHash();
        const expectedSignature = crypto
            .createHmac('sha256', this.fromAddress) // Using address as key (simplified)
            .update(hashTx)
            .digest('hex');

        return this.signature === expectedSignature;
    }
}

/**
 * Individual Block class
 */
class Block {
    constructor(timestamp, transactions, previousHash = '') {
        this.timestamp = timestamp;
        this.transactions = transactions;
        this.previousHash = previousHash;
        this.nonce = 0;
        this.hash = this.calculateHash();
    }

    /**
     * Calculate hash of the block
     */
    calculateHash() {
        return crypto
            .createHash('sha256')
            .update(
                this.previousHash +
                this.timestamp +
                JSON.stringify(this.transactions) +
                this.nonce
            )
            .digest('hex');
    }

    /**
     * Mine block with Proof of Work
     */
    mineBlock(difficulty) {
        const target = Array(difficulty + 1).join('0');
        
        console.log(`⛏️  Mining block with difficulty ${difficulty}...`);
        const startTime = Date.now();
        
        while (this.hash.substring(0, difficulty) !== target) {
            this.nonce++;
            this.hash = this.calculateHash();
            
            // Show progress every 100000 iterations
            if (this.nonce % 100000 === 0) {
                console.log(`   Nonce: ${this.nonce}, Hash: ${this.hash.substring(0, 10)}...`);
            }
        }
        
        const endTime = Date.now();
        console.log(`✅ Block mined in ${endTime - startTime}ms`);
        console.log(`   Final hash: ${this.hash}`);
        console.log(`   Nonce: ${this.nonce}\n`);
    }

    /**
     * Validate all transactions in the block
     */
    hasValidTransactions() {
        for (const tx of this.transactions) {
            if (!tx.isValid()) {
                return false;
            }
        }
        return true;
    }
}

/**
 * Main Blockchain class
 */
class Blockchain extends EventEmitter {
    constructor() {
        super();
        this.chain = [this.createGenesisBlock()];
        this.difficulty = 2; // Mining difficulty
        this.pendingTransactions = [];
        this.miningReward = 100; // Reward for mining a block
        this.balances = new Map(); // Track balances
        
        console.log('🔗 New blockchain created!');
        console.log(`⚙️  Mining difficulty: ${this.difficulty}`);
        console.log(`🎁 Mining reward: ${this.miningReward} coins\n`);
    }

    /**
     * Create the genesis block
     */
    createGenesisBlock() {
        const genesisBlock = new Block(Date.now(), [], '0');
        genesisBlock.hash = genesisBlock.calculateHash();
        console.log('🎯 Genesis block created:', genesisBlock.hash);
        return genesisBlock;
    }

    /**
     * Get the latest block
     */
    getLatestBlock() {
        return this.chain[this.chain.length - 1];
    }

    /**
     * Add transaction to pending pool
     */
    addTransaction(transaction) {
        if (!transaction.fromAddress || !transaction.toAddress) {
            throw new Error('Transaction must include from and to address');
        }

        if (!transaction.isValid()) {
            throw new Error('Cannot add invalid transaction to chain');
        }

        // Check if sender has enough balance
        if (transaction.fromAddress !== null) {
            const balance = this.getBalance(transaction.fromAddress);
            if (balance < transaction.amount) {
                throw new Error('Not enough balance');
            }
        }

        this.pendingTransactions.push(transaction);
        console.log(`📝 Transaction added: ${transaction.fromAddress} → ${transaction.toAddress} (${transaction.amount} coins)`);
        
        this.emit('transactionAdded', transaction);
    }

    /**
     * Mine pending transactions
     */
    minePendingTransactions(miningRewardAddress) {
        // Add mining reward transaction
        const rewardTransaction = new Transaction(null, miningRewardAddress, this.miningReward);
        this.pendingTransactions.push(rewardTransaction);

        // Create new block
        const block = new Block(
            Date.now(),
            this.pendingTransactions,
            this.getLatestBlock().hash
        );

        // Mine the block
        block.mineBlock(this.difficulty);

        console.log('🏆 Block successfully mined!');
        this.chain.push(block);

        // Update balances
        this.updateBalances(block);

        // Reset pending transactions
        this.pendingTransactions = [];
        
        this.emit('blockMined', block);
        return block;
    }

    /**
     * Update balances after mining a block
     */
    updateBalances(block) {
        for (const transaction of block.transactions) {
            // Deduct from sender
            if (transaction.fromAddress !== null) {
                const senderBalance = this.balances.get(transaction.fromAddress) || 0;
                this.balances.set(transaction.fromAddress, senderBalance - transaction.amount);
            }

            // Add to receiver
            const receiverBalance = this.balances.get(transaction.toAddress) || 0;
            this.balances.set(transaction.toAddress, receiverBalance + transaction.amount);
        }
    }

    /**
     * Get balance for an address
     */
    getBalance(address) {
        return this.balances.get(address) || 0;
    }

    /**
     * Get all transactions for an address
     */
    getTransactionsForAddress(address) {
        const transactions = [];

        for (const block of this.chain) {
            for (const tx of block.transactions) {
                if (tx.fromAddress === address || tx.toAddress === address) {
                    transactions.push(tx);
                }
            }
        }

        return transactions;
    }

    /**
     * Validate the entire blockchain
     */
    isChainValid() {
        for (let i = 1; i < this.chain.length; i++) {
            const currentBlock = this.chain[i];
            const previousBlock = this.chain[i - 1];

            // Check if block has valid transactions
            if (!currentBlock.hasValidTransactions()) {
                console.log('❌ Block has invalid transactions');
                return false;
            }

            // Check if current block hash is valid
            if (currentBlock.hash !== currentBlock.calculateHash()) {
                console.log('❌ Block hash is invalid');
                return false;
            }

            // Check if previous hash matches
            if (currentBlock.previousHash !== previousBlock.hash) {
                console.log('❌ Previous hash doesn\'t match');
                return false;
            }
        }

        console.log('✅ Blockchain is valid');
        return true;
    }

    /**
     * Get blockchain statistics
     */
    getStats() {
        const totalBlocks = this.chain.length;
        const totalTransactions = this.chain.reduce((sum, block) => sum + block.transactions.length, 0);
        const totalAddresses = this.balances.size;
        
        return {
            totalBlocks,
            totalTransactions,
            totalAddresses,
            difficulty: this.difficulty,
            miningReward: this.miningReward,
            pendingTransactions: this.pendingTransactions.length
        };
    }

    /**
     * Adjust mining difficulty
     */
    adjustDifficulty(newDifficulty) {
        this.difficulty = Math.max(1, Math.min(6, newDifficulty)); // Between 1-6
        console.log(`⚙️  Mining difficulty adjusted to: ${this.difficulty}`);
        this.emit('difficultyAdjusted', this.difficulty);
    }

    /**
     * Export blockchain data
     */
    exportChain() {
        return {
            chain: this.chain,
            difficulty: this.difficulty,
            pendingTransactions: this.pendingTransactions,
            miningReward: this.miningReward,
            balances: Object.fromEntries(this.balances)
        };
    }
}

module.exports = { Blockchain, Block, Transaction };