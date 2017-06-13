var EarlyBird = artifacts.require("./EarlyBird.sol");

contract('EarlyBird', (accounts) => {
  it('fails to register sim without correct balance', async () => {
    const contract = await EarlyBird.deployed();

    console.log('EarlyBird', contract);
    
    return Promise.resolve();
  });
});
