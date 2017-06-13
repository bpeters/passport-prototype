var Passport = artifacts.require("./Passport.sol");

contract('Passport', function(accounts) {
  it("logs when message request events are recieved", function(done) {
    Passport.deployed().then(function(passport) {
      console.log('PASSPORT', passport);
      done();
    });
  });
});
