// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract Bank {
    struct CustomerDetails {
        address UserAddr;
        uint AcctBalance;
    }
    struct LockedBalance {
        uint amount;
        uint unlockTime;
    }

    address public bank;
    uint internal customerCount;
    uint internal feesBalance;

    CustomerDetails[] private customers;

    mapping(address => bytes32) private passwords;
    mapping(address => bool) private customerExist;
    mapping(address => CustomerDetails) public customerDetails;
    mapping(address => LockedBalance[]) public lockedBalances;

    event Withdrawal(uint amount, uint when);
    event Locked(uint amount, uint unlockTime);
    event Unlocked(uint amount, uint unlockTime);

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

    function lockBalance(
        uint amount,
        uint unlockTime,
        string memory password
    ) public {
        bytes32 hashedPassword = keccak256(abi.encodePacked(password));
        require(hashedPassword == passwords[msg.sender], "Incorrect password");
        require(customerExist[msg.sender], "Account does not exist");
        require(amount > 0, "Lock amount must be greater than 0");
        require(
            amount <= customerDetails[msg.sender].AcctBalance,
            "Insufficient funds"
        );
        require(
            unlockTime > block.timestamp,
            "Unlock time should be in the future"
        );

        LockedBalance storage locked = lockedBalances[msg.sender].push();
        locked.amount = amount;
        locked.unlockTime = unlockTime;

        uint bankFee = (amount * 1) / 1000;
        amount -= bankFee;
        feesBalance += bankFee;

        customerDetails[msg.sender].AcctBalance -= amount;

        emit Locked(amount, unlockTime);
    }

    // function unlockeBalance() public {
    //     require(customerExist[msg.sender], "Account does not exist");
    //     LockedBalance[] storage locked = lockedBalances[msg.sender];
    //     for (uint i = 0; i < locked.length; i++) {
    //         if (locked[i].unlockTime <= block.timestamp) {
    //             customerDetails[msg.sender].AcctBalance += locked[i].amount;
    //             locked[i].amount = 0;
    //             locked[i].unlockTime = 0;
    //         }
    //     }
    // }

    function unlockBalance(uint amount) public {
        require(customerExist[msg.sender], "Account does not exist");
        require(
            lockedBalances[msg.sender].length > 0,
            "No locked balances found"
        );
        uint totalUnlocked = 0;
        for (uint i = 0; i < lockedBalances[msg.sender].length; i++) {
            if (
                lockedBalances[msg.sender][i].unlockTime <= block.timestamp &&
                lockedBalances[msg.sender][i].amount > 0
            ) {
                if (
                    lockedBalances[msg.sender][i].amount >=
                    amount - totalUnlocked
                ) {
                    customerDetails[msg.sender].AcctBalance +=
                        amount -
                        totalUnlocked;
                    lockedBalances[msg.sender][i].amount -=
                        amount -
                        totalUnlocked;
                    break;
                } else {
                    totalUnlocked += lockedBalances[msg.sender][i].amount;
                    customerDetails[msg.sender].AcctBalance += lockedBalances[
                        msg.sender
                    ][i].amount;
                    lockedBalances[msg.sender][i].amount = 0;
                }
            }
        }
        require(
            totalUnlocked == amount,
            "Amount to be unlocked exceeds available balance"
        );

        emit Unlocked(amount, block.timestamp);
    }

    function transfer(
        address recipient,
        uint amount,
        string memory password
    ) public {
        bytes32 hashedPassword = keccak256(abi.encodePacked(password));
        require(hashedPassword == passwords[msg.sender], "Incorrect password");
        require(customerExist[msg.sender], "Account does not exist");
        require(amount > 0, "Transfer amount must be greater than 0");
        require(
            amount <= customerDetails[msg.sender].AcctBalance,
            "Insufficient funds"
        );
        uint bankFee = (amount * 2) / 1000;
        amount -= bankFee;
        feesBalance += bankFee;

        customerDetails[msg.sender].AcctBalance -= amount;
        customerDetails[recipient].AcctBalance += amount;
    }

    function interTransfer(
        address recipient,
        uint amount,
        string memory password
    ) public payable {
        bytes32 hashedPassword = keccak256(abi.encodePacked(password));
        require(hashedPassword == passwords[msg.sender], "Incorrect password");
        require(customerExist[msg.sender], "Account does not exist");
        require(amount > 0, "Transfer amount must be greater than 0");
        require(
            amount <= customerDetails[msg.sender].AcctBalance,
            "Insufficient funds"
        );
        uint bankFee = (amount * 2) / 1000;
        amount -= bankFee;
        feesBalance += bankFee;

        require(customerExist[recipient], "Recipient account does not exist");

        customerDetails[msg.sender].AcctBalance -= amount;
        customerDetails[recipient].AcctBalance += amount;

        payable(recipient).transfer(msg.value);
    }

    function changePassword(
        string memory password,
        string memory newPassword
    ) public {
        bytes32 hashedPassword = keccak256(abi.encodePacked(password));
        require(hashedPassword == passwords[msg.sender], "Incorrect password");
        require(customerExist[msg.sender], "Account does not exist");
        bytes32 newHashedPassword = keccak256(abi.encodePacked(newPassword));
        passwords[msg.sender] = newHashedPassword;
    }

    function deleteAccount(string memory password) public {
        bytes32 hashedPassword = keccak256(abi.encodePacked(password));
        require(hashedPassword == passwords[msg.sender], "Incorrect password");
        require(customerExist[msg.sender], "Account does not exist");
        require(
            customerDetails[msg.sender].AcctBalance == 0,
            "Please withdraw all funds before deleting account"
        );
        // Remove customer data
        customerDetails[msg.sender].AcctBalance = 0;
        passwords[msg.sender] = 0x0;
        customerExist[msg.sender] = false;
    }
}
