require('dotenv').config();
const HDWalletProvider = require('@truffle/hdwallet-provider');

const privateKey = process.env.PRIVATE_KEY;
const alchemyApiUrl = process.env.ALCHEMY_API_URL;

module.exports = {
  networks: {
    sepolia: {
      provider: () => new HDWalletProvider({
        privateKeys: [privateKey],
        providerOrUrl: alchemyApiUrl
      }),
      network_id: 11155111, 
      gas: 4500000,
      gasPrice: 10000000000
    }
  },

  compilers: {
    solc: {
      version: "0.8.0" 
    }
  }
};