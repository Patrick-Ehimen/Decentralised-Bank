// SPDX-Linense-Identifier: MIT

pragma solidity ^0.8.9;

contract DeBank {
    // Mapping address to balance
    mapping(address => uint) public balance;

    // Deposit Ether
    function deposit() public payable {
        // Increase balance
        balance[msg.sender] += msg.value;
    }

    // Withdraw Ether
    function withdraw(uint _amount) public {
        // Check if user has enough balance
        require(balance[msg.sender] >= _amount);

        // Decrease balance
        balance[msg.sender] -= _amount;

        // Send Ether to user
        payable(msg.sender).transfer(_amount);
    }
}
