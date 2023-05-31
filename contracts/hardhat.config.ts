import * as dotenv from "dotenv";
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-gas-reporter";
import "@nomiclabs/hardhat-etherscan";
// import '@nomiclabs/hardhat-waffle';
import "@typechain/hardhat";
import "solidity-coverage";
import "hardhat-deploy";
import "@nomiclabs/hardhat-ethers";

dotenv.config();

function getEnvVariable(name: string, optional = false) {
  if (!optional && !process.env[name]) {
    throw new Error(`Please set your ${name} in an .env file`);
  }
  return process.env[name] ?? "";
}

const privateKey = (() => {
  const key = getEnvVariable("PRIVATE_KEY");
  if (!key.startsWith("0x")) {
    throw new Error('PRIVATE_KEY has to start with "0x"');
  }
  return key;
})();

const accounts = [privateKey];

const config: HardhatUserConfig = {
  solidity: "0.8.9",
  networks: {
    thetaTestnet: {
      chainId:  365,
      url: "https://eth-rpc-api-testnet.thetatoken.org/rpc",
      accounts,
    },
  },
  namedAccounts: {
    deployer: 0,
    owner: {
      bsc: "0xbCA20F7c73c1937432D33E148c206516d12093D6"
    },
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "TFUEL",
  },
};
export default config;