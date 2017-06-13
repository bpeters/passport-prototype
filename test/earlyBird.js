var EarlyBird = artifacts.require("./EarlyBird.sol");

contract('EarlyBird', (accounts) => {
  it('deployed parameters are correct', async () => {
    const contract = await EarlyBird.deployed();
    const owner = await contract.owner();
    const isLocked = await contract.isLocked();

    assert.equal(owner, accounts[0]);
    assert.equal(isLocked, false);

    return Promise.resolve();
  });
});
