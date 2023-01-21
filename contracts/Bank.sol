// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Bank {
    struct CustomerDetails {
        string UserName;
        address UserAddr;
        //string AccountPassword;
        bytes32 myPassowrd;
        uint Balance;
        string AccountType;
    }
    string bank;
    string public constant ACCT_TYPE_1 = "Savings";
    string public constant ACCT_TYPE_2 = "Current";
    string public constant ACCT_TYPE_3 = "Fixed_Depost";

    //CustomerDetails public customerDetails;
    CustomerDetails[] public customers;

    mapping(address => bool) public customerExist;

    constructor() {
        bank = "De_Bank DAO";
    }

    // function setPassword(string memory _accountPassword) public {
    //     //customerDetails.AccountPassword = _accountPassword;
    //     customerDetails.myPassowrd = keccak256(
    //         abi.encodePacked(_accountPassword)
    //     );
    // }

    function createAccount(
        string memory name,
        string memory _accountPassword
    ) public {
        CustomerDetails storage accountCreated = customers.push();
        accountCreated.UserName = name;
        require(!customerExist[msg.sender], "You already have an acoount");
        accountCreated.UserAddr = msg.sender;
        customerExist[msg.sender] = true;
        accountCreated.myPassowrd = keccak256(
            abi.encodePacked(_accountPassword)
        );
        //return "You already have an acoount";
    }
}
