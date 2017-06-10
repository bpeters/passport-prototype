pragma solidity ^0.4.4;

contract Passport {

  // constant minimum balance in wei
  int constant minimumBalance = 1000000000000000000;

  // contract owner
  address public owner;

  // balances of the addresses in wei
  mapping (address => uint) private balances;

  // sims of the addresses
  mapping (address => string) private sims;

  // event to activate SIM
  event ActivateSIM(string sim);

  // event to deactivate SIM
  event DeactivateSIM(string sim);

  // event to notify deposit has been made
  event DepositMade(string sim);

  // constructor
  function Passport() {
    owner = msg.sender;
  }

  // register sim and set initial balance
  // initial balance must be above minimum balance amount
  // activiate sim afterwards
  function register(string sim) {
    if (msg.value < minimumBalance) throw;

    sims[msg.sender] = sim;
    balances[msg.sender] = msg.value;

    ActivateSIM(sim);
  }

  // add eth to balance
  // balance must be above minimum balance
  // if deposit bumps the balance above minimum balance, activate sim
  function deposit() public returns (uint) {
    uint initialBalance = balances[msg.sender];
    uint newBalance = initialBalance + msg.value;

    if (newBalance < minimumBalance) throw;

    balances[msg.sender] = newBalance;

    DepositMade(sims[msg.sender]);

    if (initialBalance < minimumBalance) {
      ActivateSIM(sim);
    }

    return newBalance;
  }

  // Fallback function - Called if other functions don't match call or
  // sent ether without data
  // Typically, called when invalid data is sent
  // Added so ether sent to this contract is reverted if the contract fails
  // otherwise, the sender's money is transferred to contract
  function () {
    throw; // throw reverts state to before call
  }
}
