require("@nomicfoundation/hardhat-verify");
require("@nomiclabs/hardhat-truffle5");
// require("@nomiclabs/hardhat-web3");
// require("@nomiclabs/hardhat-ethers");

require('dotenv').config()

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      accounts: {
        mnemonic: process.env.MNEMONIC,
      },
      chainId: 999,
      forking: {
        url: `https://hyperliquid-mainnet.g.alchemy.com/v2/${process.env.ALCHEMEY_KEY}`,
        // blockNumber: 36568650, // <-- edit here
      },
      // allowUnlimitedContractSize: true,
    },
    mainnet: {
      url: `https://hyperliquid-mainnet.g.alchemy.com/v2/${process.env.ALCHEMEY_KEY}`,
      accounts: {
        mnemonic: process.env.MNEMONIC,
      },
    },
  },
  solidity: {
    compilers: [
      {
        version: "0.8.26",
        settings: {
          optimizer: {
            enabled: true,
            runs: 1,
          },
        },
      },
    ],
  },
  mocha: {
    timeout: 2000000
  },
  etherscan: {
    apiKey: {
      hyperevm: process.env.ETHERSCAN_API_KEY,
    },
    customChains: [
      {
        network: "hyperevm",
        chainId: 999,
        urls: {
          apiURL: "https://api.etherscan.io/v2/api?chainid=999",
          browserURL: "https://hyperevmscan.io",
          chainId: 999,
        }
      }
    ]
  },
  contractSizer: {
    alphaSort: false,
    disambiguatePaths: false,
    runOnCompile: false,
    strict: false,
  },
};
