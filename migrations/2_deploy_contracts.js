var Passport = artifacts.require("./Passport.sol");

module.exports = function(deployer) {
  deployer.deploy(Passport);
};
