const EarlyBird = artifacts.require("./EarlyBird.sol");

const fixture = {
  stakeAmount: 1000000000000000,
  staker: {},
};

contract('EarlyBird', (accounts) => {
  let contract;

  before(async () => {
    contract = await EarlyBird.deployed();
    fixture.balance = contract.contract._eth.getBalance(accounts[0]);

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
    fixture.staker.balance = contract.contract._eth.getBalance(accounts[0]);

    assert.equal(isStaker, true);
    assert.equal(fixture.staker.amount, fixture.stakeAmount);
    assert.ok(fixture.staker.blockNumber);
    assert.equal(fixture.staker.balance < fixture.balance, true);

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

  it('refundStake should fail if never staked', async () => {
    try {
      await contract.refundStake.call({
        from: accounts[1],
      });
    } catch (err) {
      assert.ok(err);
    }

    return Promise.resolve();
  });

  it('refundStake should refund if staked', async () => {
    await contract.refundStake();

    const staker = await contract.getStaker();
    const refundBalance = contract.contract._eth.getBalance(accounts[0]);

    console.log(fixture.staker.balance - refundBalance);

    fixture.staker.amount = staker[0].toNumber();

    assert.equal(fixture.staker.amount, 0);
    assert.ok(fixture.staker.blockNumber, staker[1].toNumber());

    return Promise.resolve();
  });
});
