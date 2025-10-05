#!/usr/bin/env node

const BlockchainServer = require('./BlockchainServer');

// Configuration
const HTTP_PORT = process.env.HTTP_PORT || 3001;
const WS_PORT = process.env.WS_PORT || 8080;

console.log('🚀 Starting Custom Cryptocurrency Blockchain...\n');

// Create and start the blockchain server
const server = new BlockchainServer(HTTP_PORT, WS_PORT);
server.start();

// Handle graceful shutdown
process.on('SIGINT', () => {
    console.log('\n🛑 Shutting down blockchain server...');
    process.exit(0);
});

process.on('SIGTERM', () => {
    console.log('\n🛑 Shutting down blockchain server...');
    process.exit(0);
});