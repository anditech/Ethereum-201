// SPDX-Licence-Identifier: UNLICENSED
pragma solidity 0.7.5;

import "./Ownable.sol";
import "./Destroyable.sol";

interface GovernmentInterface{
    function addTransaction(address _from, address _to, uint _amount) external;
}

contract Bank is Ownable, Destroyable {
    
  GovernmentInterface governmentInstance = GovernmentInterface(0x8a7644191756a1122A63C0CA7238A8f15706f825);
    
  mapping(address => uint) balance;
  
  event depositDone(uint amount, address depositedTo);
  event balanceTransferred(address indexed from, address indexed to, uint amount);
 
  
  function deposit() public payable returns (uint) {
      balance[msg.sender] += msg.value; // balance[msg.sender] = balance[msg.sender] + msg.value;
      emit depositDone(msg.value, msg.sender);
      return balance[msg.sender];
  }
  
  function withdraw(uint amount) public returns (uint){
      require(balance[msg.sender] >= amount);
      balance[msg.sender] -= amount;
      msg.sender.transfer(amount);
      return balance[msg.sender];
  }
  
  
  function getBalance() public view returns (uint){
      return balance[msg.sender];
  }
  
  function transfer(address recipient, uint amount) public {
      // check balance of msg.sender, require for valid conditions, checks inputs & reverts Txs if caller makes an error
      require(balance[msg.sender] >= amount, "Not enough balance");
      require(msg.sender != recipient, "Can't transfer money to yourself");
      
      uint previousSenderBalance = balance[msg.sender];
      
      _transfer(msg.sender, recipient, amount);
      
      governmentInstance.addTransaction(msg.sender, recipient, amount);
      
      emit balanceTransferred(msg.sender, recipient, amount);
      // assert stament, checks for internal errors (in the code), checks for invariants
      assert(balance[msg.sender] == previousSenderBalance - amount);
      
      // event longs and further checks
  }
  
  function _transfer(address from, address to, uint amount) private {
      balance[from] -= amount;
      balance[to] += amount;
      
  }
  
} 
