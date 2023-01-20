// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Bank {
    struct CustomerDetails {
        string User;
        address UserAddr;
        string AccountPassword;
        bytes32 myPassowrd;
        uint Balance;
    }

    CustomerDetails public customerDetails;

    //CustomerDetails[] public customerDetails;

    function setPassword(string memory _accountPassword) public {
        customerDetails.AccountPassword = _accountPassword;
        customerDetails.myPassowrd = keccak256(
            abi.encodePacked(_accountPassword)
        );
    }

    function getStruct() public view returns (CustomerDetails memory) {
        return customerDetails;
    }
}
