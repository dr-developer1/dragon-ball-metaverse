const DBMetaverse = artifacts.require("./DBMetaverse.sol");

module.exports = function(deployer) {
    deployer.deploy(DBMetaverse);
}