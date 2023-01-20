// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract DeBank {
    // struct to hold user details
    struct User {
        string nameOfBank;
        uint balance;
        uint createdAt;
        address userAddress;
        string accountType;
    }

    // struct to hold transaction details
    struct Transactions {
        uint amount;
        uint date;
        address destination;
    }

    // struct to hold interest details
    struct InterestTime {
        uint date;
    }

    // string to hold the name of the bank
    string bankName;

    // mapping to hold user details
    mapping(address => User) public usersDetails;
    // mapping to hold transaction details
    mapping(address => Transactions) public _latesttransactions;
    // mapping to hold interest details
    mapping(address => InterestTime) private _dueInterest;
    // mapping to hold user passwords
    mapping(address => bytes32) private passwords;
    // mapping to hold time details
    mapping(address => bool) private time;

    User[] private users;
    Transactions[] private transaction;
    InterestTime[] private interestTime;

    modifier onlyBank() {
        require(
            keccak256(abi.encodePacked(bankName)) ==
                keccak256(
                    abi.encodePacked(usersDetails[msg.sender].nameOfBank)
                ),
            "Only the bank can call this function"
        );
        _;
    }

    modifier restricted() {
        require(msg.sender != address(0), "You can't use a zero address");
        require(accountExist(msg.sender), "Account address does not exist");
        _;
    }

    constructor() {
        bankName = "Ethereum Bank";
    }

    receive() external payable {}

    fallback() external payable {}

    function createAccount(bytes32 password) public payable {
        require(msg.sender != address(0), "You  can't use a zero address");
        require(msg.sender != 0, "You can't deposit 0 amount");
        require(msg.value >= 0.1 ether, "Insufficient amount");
        require(!accountExist(msg.sender), "You already have an acoount");

        User storage createdUser = users.push();
        createdUser.nameOfBank = bankName;
        createdUser.userAddress = msg.sender;
        createdUser.createdAt = block.timestamp;

        passwords[msg.sender] = password;

        if (msg.value >= 0.1 ether) {
            createdUser.accountType = "Savings Account";
        }

        if (msg.value >= 0.5 ether) {
            createdUser.accountType = "Current Account";
        }

        if (msg.value >= 10 ether) {
            createdUser.accountType = "Off-shore Acoount";
        }

        createdUser.balance = msg.value;
        usersDetails[msg.sender] = createdUser;

        updateTransaction();

        eligibleInterest();
    }
}
