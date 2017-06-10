var ConvertLib = artifacts.require("./ConvertLib.sol");
var TwilioOracle = artifacts.require("./TwilioOracle.sol");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, TwilioOracle);
  deployer.deploy(TwilioOracle);
};
