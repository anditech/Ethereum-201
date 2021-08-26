// SPDX-Licence-Identifier: UNLICENSED
pragma solidity 0.7.5;

contract Ownable {
    address internal owner;
    
    modifier onlyOwner {
      require(msg.sender == owner);
      _; //run the fx
  }
  
  constructor(){
      owner = msg.sender;
  }
    
}
