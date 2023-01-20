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

    //CustomerDetails public customerDetails;
    CustomerDetails[] public customers;

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
        accountCreated.UserAddr = msg.sender;
        accountCreated.myPassowrd = keccak256(
            abi.encodePacked(_accountPassword)
        );
    }
}
