var ConvertLib = artifacts.require("./ConvertLib.sol");
var Passport = artifacts.require("./Passport.sol");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, Passport);
  deployer.deploy(Passport);
};
