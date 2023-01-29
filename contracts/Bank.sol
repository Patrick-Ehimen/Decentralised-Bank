// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract Bank {
    struct CustomerDetails {
        address UserAddr;
        uint AcctBalance;
    }
    address public bank;
    uint internal customerCount;
    uint internal feesBalance;

    CustomerDetails[] private customers;

    mapping(address => bytes32) private passwords;
    mapping(address => bool) private customerExist;
    mapping(address => CustomerDetails) public customerDetails;

    event Withdrawal(uint amount, uint when);

    receive() external payable {}

    fallback() external payable {}

    constructor() {
        bank = msg.sender;
    }

    function createAccount(string memory password) public {
        CustomerDetails storage accountCreated = customers.push();
        require(msg.sender != address(0), "You cannot use a zero address");
        require(!customerExist[msg.sender], "You already have an acoount");
        accountCreated.UserAddr = msg.sender;
        customerExist[msg.sender] = true;

        bytes32 hashedPassword = keccak256(abi.encodePacked(password));
        passwords[msg.sender] = hashedPassword;

        customerCount++;
    }

    function deposit() public payable {
        require(customerExist[msg.sender], "Account does not exist");
        require(msg.value > 0, "Deposit amount must be greater than 0");
        CustomerDetails storage accountCreated = customers.push();
        accountCreated.AcctBalance = msg.value;
        customerDetails[msg.sender] = accountCreated;
    }

    function withdraw(uint amount, string memory password) public {
        bytes32 hashedPassword = keccak256(abi.encodePacked(password));
        require(hashedPassword == passwords[msg.sender], "Incorrect password");
        require(customerExist[msg.sender], "Account does not exist");
        require(amount > 0, "Withdraw amount must be greater than 0");
        require(
            amount <= customerDetails[msg.sender].AcctBalance,
            "Insufficient funds"
        );

        uint bankFee = (amount * 5) / 1000;
        amount -= bankFee;
        feesBalance += bankFee;

        payable(msg.sender).transfer(amount);
        customerDetails[msg.sender].AcctBalance -= amount;

        emit Withdrawal(address(this).balance, block.timestamp);
    }

    function withdrawFees() public {
        require(msg.sender == bank, "You are not the owner of this contract");
        payable(msg.sender).transfer(feesBalance);
        feesBalance = 0;
    }

    function getBalance() public view returns (uint) {
        require(customerExist[msg.sender], "Account does not exist");
        return customerDetails[msg.sender].AcctBalance;
    }

    function getContractBalance() public view returns (uint) {
        require(msg.sender == bank, "You are not the owner of this contract");
        return address(this).balance;
    }

    function lockBalance() public {}
}
