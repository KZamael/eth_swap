require('babel-register');
require('babel-polyfill');

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id.
    },
  },
  contracts_directory: './src/contracts/', // Where the smart contracts live in our project
  contracts_build_directory: './src/abis/', // It points to this place, cuz we want use the smart contracts with out client side app defined in this project.
  compilers: { // Which compiler to use
    solc: {
      optimizer: {
        enabled: true,
        runs: 200
      },
      evmVersion: "petersburg"
    }
  }
}
