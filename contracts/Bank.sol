// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract Bank {
    struct CustomerDetails {
        address UserAddr;
        uint AcctBalance;
        mapping(address => bytes32) passwords;
    }

    mapping(address => bool) public customerExist;
}
