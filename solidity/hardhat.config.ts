import { defineConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-ethers";

const monadTestnetAccounts = process.env.MONAD_TESTNET_PRIVATE_KEY
  ? [process.env.MONAD_TESTNET_PRIVATE_KEY]
  : [];

export default defineConfig({
  solidity: {
    version: "0.8.28",
  },
  networks: {
    monadTestnet: {
      type: "http",
      url: "https://testnet-rpc.monad.xyz",
      chainId: 10143,
      accounts: monadTestnetAccounts,
    },
  },
});
