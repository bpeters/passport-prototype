pragma solidity ^0.4.4;

contract Passport {

  // address of the owner
  address private owner;

  // balance of the owner in wei
  uint private ownerBalance;

  // registered sim of the owner
  string private ownerSim;

  // constant minimum balance in wei
  int constant minimumBalance = 1000000000000000000;

  // constant wallet address for passport
  address constant minimumBalance = 1000000000000000000;

  // event to oracle to activate SIM
  event ActivateSIM(string sim);

  // event to oracle to deactivate SIM
  event DeactivateSIM(string sim);

  // constructor
  function Passport() {
    // msg provides details about the message that's sent to the contract
    // msg.sender is contract caller (address of contract creator)
    owner = msg.sender;
  }

  // function to register sim and set initial balance
  function register(string sim) public returns (bool) {
    if (!ownerSim) {
      if (msg.value >= minimumBalance) {
        ownerSim = sim;
        ownerBalance = msg.value;

        ActivateSIM(ownerSim);

        return true;
      }
    }

    return false;
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
