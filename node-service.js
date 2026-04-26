const axios = require('axios');
const { ethers } = require('ethers');

const ORACLE_ABI = ["function fulfillRequest(uint256 _requestId, uint256 _data) external"];

async function runNode(oracleAddress, privateKey, rpcUrl) {
    const provider = new ethers.JsonRpcProvider(rpcUrl);
    const wallet = new ethers.Wallet(privateKey, provider);
    const oracle = new ethers.Contract(oracleAddress, ORACLE_ABI, wallet);

    console.log("Oracle node started. Listening for requests...");

    // Mock listener logic
    const fetchPrice = async () => {
        const response = await axios.get('https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT');
        return Math.floor(parseFloat(response.data.price));
    };

    // In production, use event listeners: oracle.on("DataRequested", ...)
}

module.exports = { runNode };
