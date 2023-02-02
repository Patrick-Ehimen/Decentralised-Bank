require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */

const PRIVATE_KEY = process.env.PRIVATE_KEY;
const MATIC_RPC_URL = process.env.MATIC_RPC_URL;

module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    mumbai: {
      url: MATIC_RPC_URL,
      accounts: [PRIVATE_KEY],
      chainId: 80001,
    },
  },
  solidity: "0.8.9",
};
