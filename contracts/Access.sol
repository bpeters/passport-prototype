pragma solidity ^0.4.4;

contract Access {

  uint constant cost = 10 finney; // Minimum balance .01 ETH ~$3

  address public owner;

  mapping(address => funder) public funders;
  address[] public funderList;

  struct funder {
    uint paid;
    uint refunded;
    uint pointer;
  }

  event PaymentReceived(address sender, uint amount);
  event PaymentRefunded(address recipient, uint amount);

  function Access() {
    owner = msg.sender;
  }

  function isFunder(address funder) public constant returns (bool) {
    if (funderList.length == 0) return false;
    return funderList[funders[funder].pointer] == funder;
  }

  function makePayment() payable public returns (bool) {
    if (!isFunder(msg.sender)) {
      funders[msg.sender].pointer = funderList.push(msg.sender) - 1;

      funders[msg.sender].paid += msg.value;

      PaymentReceived(msg.sender, msg.value);

      return true;
    } else {
      return false;
    }
  }

  function refundPayment() public returns (bool) {
    if (!isFunder(msg.sender)) throw;

    uint amountOwed = funders[msg.sender].paid - funders[msg.sender].refunded;

    if (cost > amountOwed) throw;

    funders[msg.sender].refunded += cost;

    PaymentRefunded(msg.sender, cost);

    if (!msg.sender.send(cost)) throw;

    return true;
  }

  function () {
    throw;
  }
}
