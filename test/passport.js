const Passport = artifacts.require("./Passport.sol");

contract('Passport', (accounts) => {
  it('fails to register sim without correct balance', async () => {
    const contract = await Passport.deployed();

    console.log('PASSPORT', contract);
    
    return Promise.resolve();
  });
});
