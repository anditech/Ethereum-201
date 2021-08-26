// SPDX-Licence-Identifier: UNLICENSED
pragma solidity 0.7.5;

import "./Ownable.sol";

contract Destroyable is Ownable {

 function destroy() public onlyOwner {
    address payable receiver = msg.sender;
    selfdestruct(receiver);
 }
}
