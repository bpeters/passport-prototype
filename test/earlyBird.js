const EarlyBird = artifacts.require("./EarlyBird.sol");

const fixture = {
  stakeAmount: 1000000000000000,
  staker: {},
};

contract('EarlyBird', (accounts) => {
  let contract;

  before(async () => {
    contract = await EarlyBird.deployed();

    return Promise.resolve();
  });

  it('deployed parameters are correct', async () => {
    const owner = await contract.owner();
    const isLocked = await contract.isLocked();
    const stakeAmount = await contract.stakeAmount();

    assert.equal(owner, accounts[0]);
    assert.equal(isLocked, false);
    assert.equal(stakeAmount.toNumber(), fixture.stakeAmount);

    return Promise.resolve();
  });

  it('isStaker should return false if not a staker', async () => {
    const isStaker = await contract.isStaker(accounts[0]);

    assert.equal(isStaker, false);

    return Promise.resolve();
  });

  it('new stake should create staker', async () => {
    await contract.stake({
      from: accounts[0],
      value: fixture.stakeAmount,
    });

    const isStaker = await contract.isStaker(accounts[0]);
    const staker = await contract.getStaker();

    fixture.staker.amount = staker[0].toNumber();
    fixture.staker.blockNumber = staker[1].toNumber();

    assert.equal(isStaker, true);
    assert.equal(fixture.staker.amount, fixture.stakeAmount);
    assert.ok(fixture.staker.blockNumber);

    return Promise.resolve();
  });

  it('stake should fail if already staked', async () => {
    try {
      await contract.stake({
        from: accounts[0],
        value: fixture.stakeAmount,
      });
    } catch (err) {
      assert.ok(err);
    }

    return Promise.resolve();
  });

  // it('refundStake should refund stake amount if staked', async () => {
  //   await contract.isStaker.call();

  //   return Promise.resolve();
  // });
});
