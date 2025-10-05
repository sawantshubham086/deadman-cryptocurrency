const express = require('express');
const { Blockchain, Transaction } = require('./Blockchain');
const WebSocket = require('ws');
const crypto = require('crypto');

class BlockchainServer {
    constructor(port = 3001, wsPort = 8080) {
        this.app = express();
        this.port = port;
        this.wsPort = wsPort;
        
        // Initialize blockchain
        this.blockchain = new Blockchain();
        
        // Connected peers (WebSocket connections)
        this.peers = new Set();
        
        // Setup middleware
        this.app.use(express.json());
        this.app.use(express.static('frontend'));
        
        // Setup routes
        this.setupRoutes();
        
        // Setup WebSocket server
        this.setupWebSocket();
        
        // Setup blockchain events
        this.setupBlockchainEvents();
        
        console.log('🚀 Blockchain server initialized');
    }

    setupRoutes() {
        // Get blockchain info
        this.app.get('/api/blockchain', (req, res) => {
            res.json({
                chain: this.blockchain.chain,
                stats: this.blockchain.getStats()
            });
        });

        // Get specific block
        this.app.get('/api/block/:index', (req, res) => {
            const index = parseInt(req.params.index);
            if (index >= 0 && index < this.blockchain.chain.length) {
                res.json(this.blockchain.chain[index]);
            } else {
                res.status(404).json({ error: 'Block not found' });
            }
        });

        // Get balance for address
        this.app.get('/api/balance/:address', (req, res) => {
            const balance = this.blockchain.getBalance(req.params.address);
            res.json({ address: req.params.address, balance });
        });

        // Get transactions for address
        this.app.get('/api/transactions/:address', (req, res) => {
            const transactions = this.blockchain.getTransactionsForAddress(req.params.address);
            res.json({ address: req.params.address, transactions });
        });

        // Create new transaction
        this.app.post('/api/transaction', (req, res) => {
            try {
                const { fromAddress, toAddress, amount, privateKey } = req.body;
                
                if (!fromAddress || !toAddress || !amount) {
                    return res.status(400).json({ error: 'Missing required fields' });
                }

                const transaction = new Transaction(fromAddress, toAddress, parseFloat(amount));
                
                // Sign transaction if private key provided
                if (privateKey) {
                    transaction.signTransaction(privateKey);
                }

                this.blockchain.addTransaction(transaction);
                
                // Broadcast to peers
                this.broadcast({
                    type: 'NEW_TRANSACTION',
                    data: transaction
                });

                res.json({ 
                    success: true, 
                    message: 'Transaction added to pending pool',
                    transactionHash: transaction.calculateHash()
                });
            } catch (error) {
                res.status(400).json({ error: error.message });
            }
        });

        // Mine pending transactions
        this.app.post('/api/mine', (req, res) => {
            try {
                const { minerAddress } = req.body;
                
                if (!minerAddress) {
                    return res.status(400).json({ error: 'Miner address required' });
                }

                const block = this.blockchain.minePendingTransactions(minerAddress);
                
                // Broadcast new block to peers
                this.broadcast({
                    type: 'NEW_BLOCK',
                    data: block
                });

                res.json({ 
                    success: true, 
                    message: 'Block mined successfully',
                    block: block,
                    reward: this.blockchain.miningReward
                });
            } catch (error) {
                res.status(500).json({ error: error.message });
            }
        });

        // Validate blockchain
        this.app.get('/api/validate', (req, res) => {
            const isValid = this.blockchain.isChainValid();
            res.json({ valid: isValid });
        });

        // Get blockchain stats
        this.app.get('/api/stats', (req, res) => {
            res.json(this.blockchain.getStats());
        });

        // Adjust difficulty
        this.app.post('/api/difficulty', (req, res) => {
            try {
                const { difficulty } = req.body;
                this.blockchain.adjustDifficulty(parseInt(difficulty));
                res.json({ 
                    success: true, 
                    newDifficulty: this.blockchain.difficulty 
                });
            } catch (error) {
                res.status(400).json({ error: error.message });
            }
        });

        // Generate new wallet address
        this.app.get('/api/wallet/new', (req, res) => {
            const address = crypto.randomBytes(20).toString('hex');
            const privateKey = crypto.randomBytes(32).toString('hex');
            
            res.json({
                address: address,
                privateKey: privateKey,
                note: 'Save your private key securely! You will need it to sign transactions.'
            });
        });

        // Get pending transactions
        this.app.get('/api/pending', (req, res) => {
            res.json({
                pendingTransactions: this.blockchain.pendingTransactions,
                count: this.blockchain.pendingTransactions.length
            });
        });

        // Export blockchain data
        this.app.get('/api/export', (req, res) => {
            const data = this.blockchain.exportChain();
            res.json(data);
        });

        // Health check
        this.app.get('/api/health', (req, res) => {
            res.json({ 
                status: 'healthy', 
                uptime: process.uptime(),
                timestamp: new Date().toISOString()
            });
        });
    }

    setupWebSocket() {
        this.wss = new WebSocket.Server({ port: this.wsPort });
        
        this.wss.on('connection', (ws) => {
            console.log('👥 New peer connected');
            this.peers.add(ws);
            
            // Send current blockchain state to new peer
            ws.send(JSON.stringify({
                type: 'BLOCKCHAIN_STATE',
                data: {
                    chain: this.blockchain.chain,
                    stats: this.blockchain.getStats()
                }
            }));

            ws.on('close', () => {
                console.log('👋 Peer disconnected');
                this.peers.delete(ws);
            });

            ws.on('message', (message) => {
                try {
                    const data = JSON.parse(message);
                    this.handlePeerMessage(data, ws);
                } catch (error) {
                    console.error('❌ Invalid message from peer:', error.message);
                }
            });
        });

        console.log(`🔗 WebSocket server listening on port ${this.wsPort}`);
    }

    setupBlockchainEvents() {
        this.blockchain.on('blockMined', (block) => {
            console.log('📢 Broadcasting new block to peers');
            this.broadcast({
                type: 'NEW_BLOCK',
                data: block
            });
        });

        this.blockchain.on('transactionAdded', (transaction) => {
            this.broadcast({
                type: 'NEW_TRANSACTION',
                data: transaction
            });
        });

        this.blockchain.on('difficultyAdjusted', (difficulty) => {
            this.broadcast({
                type: 'DIFFICULTY_CHANGED',
                data: { difficulty }
            });
        });
    }

    handlePeerMessage(message, sender) {
        switch (message.type) {
            case 'REQUEST_BLOCKCHAIN':
                sender.send(JSON.stringify({
                    type: 'BLOCKCHAIN_STATE',
                    data: {
                        chain: this.blockchain.chain,
                        stats: this.blockchain.getStats()
                    }
                }));
                break;
                
            case 'NEW_TRANSACTION':
                // Relay transaction to other peers
                this.broadcast(message, sender);
                break;
                
            case 'NEW_BLOCK':
                // Relay block to other peers
                this.broadcast(message, sender);
                break;
                
            default:
                console.log('🤷 Unknown message type:', message.type);
        }
    }

    broadcast(message, sender = null) {
        const messageStr = JSON.stringify(message);
        
        this.peers.forEach(peer => {
            if (peer !== sender && peer.readyState === WebSocket.OPEN) {
                peer.send(messageStr);
            }
        });
    }

    start() {
        // Start HTTP server
        this.app.listen(this.port, () => {
            console.log(`\n🌐 Blockchain HTTP server running on port ${this.port}`);
            console.log(`📊 API endpoints available at http://localhost:${this.port}/api/`);
            console.log(`🔗 WebSocket server running on port ${this.wsPort}`);
            console.log('\n📋 Available API endpoints:');
            console.log('├─ GET  /api/blockchain     - Get full blockchain');
            console.log('├─ GET  /api/stats          - Get blockchain statistics');
            console.log('├─ GET  /api/balance/:addr  - Get balance for address');
            console.log('├─ POST /api/transaction    - Create new transaction');
            console.log('├─ POST /api/mine           - Mine pending transactions');
            console.log('├─ GET  /api/validate       - Validate blockchain');
            console.log('└─ GET  /api/wallet/new     - Generate new wallet');
            console.log('\n🎯 Ready to process transactions and mine blocks!\n');
        });

        // Create initial test transactions
        this.createInitialTransactions();
    }

    createInitialTransactions() {
        // Skip if environment variable is set
        if (process.env.SKIP_TEST_TRANSACTIONS) {
            console.log('📋 Skipping test transactions - blockchain ready for manual use!');
            return;
        }
        
        setTimeout(() => {
            console.log('🎁 Creating initial test transactions...');
            
            // Generate test addresses
            const alice = crypto.randomBytes(20).toString('hex');
            const bob = crypto.randomBytes(20).toString('hex');
            const charlie = crypto.randomBytes(20).toString('hex');
            
            // Mine initial block to give Alice some coins
            console.log('⛏️  Mining initial block...');
            this.blockchain.minePendingTransactions(alice);
            
            // Create test transactions with proper signing
            const tx1 = new Transaction(alice, bob, 30);
            tx1.signTransaction(alice); // Sign with alice's key
            const tx2 = new Transaction(alice, charlie, 20);
            tx2.signTransaction(alice); // Sign with alice's key
            
            this.blockchain.addTransaction(tx1);
            this.blockchain.addTransaction(tx2);
            
            console.log('✅ Initial transactions created');
            console.log(`📝 Test addresses:`);
            console.log(`   Alice: ${alice} (Balance: ${this.blockchain.getBalance(alice)})`);
            console.log(`   Bob: ${bob} (Balance: ${this.blockchain.getBalance(bob)})`);
            console.log(`   Charlie: ${charlie} (Balance: ${this.blockchain.getBalance(charlie)})`);
            
        }, 1000);
    }
}

module.exports = BlockchainServer;