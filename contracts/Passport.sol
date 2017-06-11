pragma solidity ^0.4.4;

contract Passport {

  uint constant minimumBalance = 40 finney; // Minimum balance .04 ETH ~$12
  uint constant dataCost = 40000000; // Cost per data byte in wei

  address public owner;

  mapping (address => uint) private balances;
  mapping (address => string) private sims;
  mapping (address => int) private usages;
  mapping (string => address) private addresses;

  event ActivateSIM(string sim);
  event DeactivateSIM(string sim);
  event DepositMade(string sim, uint amount);
  event WithdrawMade(string sim, uint amount);
  event PayableMade(string sim, uint amount);

  function Passport() {
    owner = msg.sender;
  }

  function register(string sim) {
    if (msg.value < minimumBalance) throw;

    sims[msg.sender] = sim;
    addresses[sim] = msg.sender;
    balances[msg.sender] = msg.value;
    usages[msg.sender] = 0;

    ActivateSIM(sim);
  }

  function balance() constant returns (uint) {
    return balances[msg.sender];
  }

  function sim() constant returns (string) {
    return sims[msg.sender];
  }

  function usage() constant returns (int) {
    return usages[msg.sender];
  }

  function deposit() public returns (uint) {
    uint initialBalance = balances[msg.sender];
    uint newBalance = initialBalance + msg.value;

    if (newBalance < minimumBalance) throw;

    balances[msg.sender] = newBalance;

    DepositMade(sims[msg.sender], msg.value);

    if (initialBalance < minimumBalance) {
      ActivateSIM(sim);
    }

    return newBalance;
  }

  function withdraw(uint withdrawAmount) public returns (uint) {
    if (balances[msg.sender] >= withdrawAmount) {
      balances[msg.sender] -= withdrawAmount;

      if (!msg.sender.send(withdrawAmount)) {
        balances[msg.sender] += withdrawAmount;
      } else {
        WithdrawMade(sims[msg.sender], withdrawAmount);
      }
    }

    if (balances[msg.sender] < minimumBalance) {
      DeactivateSIM(sims[msg.sender]);
    }

    return balances[msg.sender];
  }

  function payable(int dataConsumed, string sim) returns (uint) {
    if (msg.sender != owner) throw;

    address user = addresses[sim];
    int usage = usages[user];
    uint payableAmount = (dataConsumed - usage) * dataCost;

    // if balance can't cover payable
    // empty balance to cover what is can
    // update usage to reflect what's been paid for
    // sim will be deactivated
    if (balances[user] < payableAmount) {
      payableAmount = balances[user];
      dataConsumed = usage + (payableAmount / dataCost);
    }

    balances[user] -= payableAmount;
    usages[user] = dataConsumed;

    if (!msg.sender.send(payableAmount)) {
      balances[user] += payableAmount;
      usages[user] = usage;
    } else {
      PayableMade(sim, payableAmount);
    }

    if (balances[user] < minimumBalance) {
      DeactivateSIM(sim);
    }

    return balances[user];
  }

  function () {
    throw;
  }
}
