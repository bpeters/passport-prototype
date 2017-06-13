var Passport = artifacts.require("./Passport.sol");
var EarlyBird = artifacts.require("./EarlyBird.sol");

module.exports = function(deployer) {
  deployer.deploy(Passport);
  deployer.deploy(EarlyBird);
};
