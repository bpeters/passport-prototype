pragma solidity ^0.4.11;

contract Passport {

  uint constant minimumBalance = 40 finney; // Minimum balance .04 ETH ~$12
  uint constant dataCost = 40000000;  // Cost per data byte in wei

  address public owner;

  mapping (address => uint) private balances;
  mapping (address => string) private sims;
  mapping (address => int) private usages;        // Data paid for already
  mapping (string => address) private addresses;  // SIM => address

  event ActivateSIM(string sim);
  event DeactivateSIM(string sim);
  event DepositMade(string sim, uint amount);
  event WithdrawMade(string sim, uint amount);
  event CollectionMade(string sim, uint amount);

  function Passport() {
    owner = msg.sender;
  }

  function register(string sim) payable {
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

  function deposit() payable returns (uint) {
    uint initialBalance = balances[msg.sender];
    uint newBalance = initialBalance + msg.value;

    if (newBalance < minimumBalance) throw; // Deposit more than minimum

    balances[msg.sender] = newBalance;

    DepositMade(sims[msg.sender], msg.value);

    if (initialBalance < minimumBalance) ActivateSIM(sims[msg.sender]);

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

    if (balances[msg.sender] < minimumBalance) DeactivateSIM(sims[msg.sender]);

    return balances[msg.sender];
  }

  function collect(int dataConsumed, string sim) public returns (uint) {
    if (msg.sender != owner) throw;
    if (balances[user] <= 0) throw;

    address user = addresses[sim];
    int usage = usages[user];

    uint payableAmount = uint(dataConsumed - usage) * dataCost;

    if (balances[user] < payableAmount) {                   // if balance can't cover payable
      payableAmount = balances[user];                       // empty balance to cover what it can
      dataConsumed = usage + int(payableAmount / dataCost); // update usage to reflect what's been paid for
    }

    balances[user] -= payableAmount;
    usages[user] = dataConsumed;

    if (!msg.sender.send(payableAmount)) {
      balances[user] += payableAmount;
      usages[user] = usage;
    } else {
      CollectionMade(sim, payableAmount);
    }

    if (balances[user] < minimumBalance) DeactivateSIM(sim);

    return 0;
  }

  // Todo transfer sim to another address

  // Todo manage multiple sim from a single address

  function () {
    throw;
  }
}
