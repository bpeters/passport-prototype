const Passport = artifacts.require("./Passport.sol");
const EarlyBird = artifacts.require("./EarlyBird.sol");

module.exports = function(deployer) {
  deployer.deploy(Passport);
  deployer.deploy(EarlyBird);
};
