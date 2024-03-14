require('dotenv').config();
require('babel-register');
require('babel-polyfill');

const {HOST, PORT} = process.env;


module.exports = {


    networks: {
        development: {
            host: HOST,
            port: PORT,
            network_id: "*"
        }
    },
    contracts_directory: "./src/contracts/",
    contracts_build_directory: "./src/abis/",

    // Configure your compilers
    compilers: {
        solc: {
            version: "0.8.19",
            optimizer: {
                enabled: true,
                runs: 200
            }
        }
    }
};
