var TwillioOracle = artifacts.require("./TwillioOracle.sol");

contract('TwillioOracle', function(accounts) {
  it("logs when message request events are recieved", function(done) {
    TwillioOracle.deployed().then(function(twillio) {
      var events = twillio.Message().watch(function(error, result) {
        assert.equal(result.args.to, "+1555-555-5555");
        assert.equal(result.args.body, "Test");
        events.stopWatching();
        done();
      });

      twillio.createMessage("+1555-555-5555", "Test");
    })
  });
});
