pragma solidity ^0.4.4;

contract EarlyBird {

  uint constant cost = 10 finney; // Stake Amount .01 ether

  address public owner;

  struct Staker {
    uint amount;
    uint blockNumber;
  }

  mapping(address => Staker) public stakers;
  address[] public stakersList;

  event StakeCompleted(uint blockNumber);
  event StakeRefunded(address recipient, uint amount);

  function EarlyBird() {
    owner = msg.sender;
  }

  function getStaker() public returns (bool) {
    return stakers[msg.sender];
  }

  function stake() payable {
    if (msg.value != cost) throw;

    if (!stakers[msg.sender]) {
      stakers[msg.sender] = Staker({
        amount: msg.value,
        blockNumber: block.number,
      });

      stakersList.push(msg.sender);
    } else if (stakers[msg.sender].amount == 0) {
      stakers[msg.sender].amount = msg.value;
      stakers[msg.sender].blockNumber = block.number;
    } else {
      throw;
    }

    StakeCompleted(block.number);
  }

  function refundStake() public {
    if (!stakers[msg.sender]) throw;
    if (stakers[msg.sender].amount > 0) throw;

    uint refund = stakers[msg.sender].amount;
    stakers[msg.sender].amount = 0;

    if (!msg.sender.send(refund)) {
      stakers[msg.sender].amount += refund;
    } else {
      StakeRefunded();
    }
  }

  function () {
    throw;
  }
}
