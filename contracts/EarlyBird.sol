pragma solidity ^0.4.4;

contract EarlyBird {

  uint constant cost = 10 finney; // Stake Amount .01 ether

  address public owner;
  bool public isLocked;

  struct Staker {
    uint index;
    uint amount;
    uint blockNumber;
  }

  mapping(address => Staker) public stakers;
  address[] public stakersList;

  event StakeCompleted(uint blockNumber);
  event StakeRefunded(uint amount);

  function EarlyBird() {
    owner = msg.sender;
    isLocked = false;
  }

  function isStaker(address staker) public constant returns (bool) {
    if (stakersList.length == 0) return false;
    return stakersList[stakers[staker].index] == staker;
  }

  function getStaker() public returns (uint amount, uint blockNumber) {
    return (stakers[msg.sender].amount, stakers[msg.sender].blockNumber);
  }

  function stake() payable {
    if (isLocked) throw;
    if (msg.value != cost) throw;

    if (!isStaker(msg.sender)) {
      stakers[msg.sender] = Staker({
        index: stakersList.push(msg.sender) -1,
        amount: msg.value,
        blockNumber: block.number,
      });
    } else if (stakers[msg.sender].amount == 0) {
      stakers[msg.sender].amount = msg.value;
      stakers[msg.sender].blockNumber = block.number;
    } else {
      throw;
    }

    StakeCompleted(block.number);
  }

  function refundStake() public {
    if (!isStaker(msg.sender)) throw;
    if (stakers[msg.sender].amount == 0) throw;

    uint refund = stakers[msg.sender].amount;
    stakers[msg.sender].amount = 0;

    if (!msg.sender.send(refund)) {
      stakers[msg.sender].amount += refund;
    } else {
      StakeRefunded(refund);
    }
  }

  function lockEarlyBird() public {
    if (msg.sender != owner) throw;

    isLocked = true;
  }

  function () {
    throw;
  }
}
