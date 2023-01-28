// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract Bank {
    struct CustomerDetails {
        address UserAddr;
        uint AcctBalance;
    }

    mapping(address => bytes32) public passwords;

    CustomerDetails[] private customers;

    mapping(address => bool) public customerExist;
    mapping(address => CustomerDetails) public customerDetails;

    receive() external payable {}

    function createAccount(string memory password) public {
        CustomerDetails storage accountCreated = customers.push();
        require(msg.sender != address(0), "You cannot use a zero address");
        require(!customerExist[msg.sender], "You already have an acoount");
        accountCreated.UserAddr = msg.sender;
        customerExist[msg.sender] = true;

        bytes32 hashedPassword = keccak256(abi.encodePacked(password));
        passwords[msg.sender] = hashedPassword;
    }

    function deposit() public payable {
        require(customerExist[msg.sender], "Account does not exist");
        require(msg.value > 0, "Deposit amount must be greater than 0");
        CustomerDetails storage accountCreated = customers.push();
        accountCreated.AcctBalance = msg.value;
        customerDetails[msg.sender] = accountCreated;
    }

    function getBalance() public view returns (uint) {
        require(customerExist[msg.sender], "Account does not exist");
        return customerDetails[msg.sender].AcctBalance;
    }
}
