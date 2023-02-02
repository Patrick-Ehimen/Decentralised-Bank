# Decentralised Bank

Decentralised Bank is a decentralised banking platform that allows users to create accounts, deposit funds, securely store, transfer, withdraw funds, transfer funds, lock and unlock balances, change passwords and delete accounts.

## Features

- Create Accounts: Allows users to create an account with a password.
- Deposit Funds: Allows users to deposit funds into their account.
- Withdraw Funds: Allows users to withdraw funds from their account.
- Transfer Funds: Allows users to transfer funds from one account to another.
- Lock and Unlock Balances: Allows users to lock and unlock balances in their account.
- Change Passwords: Allows users to change the password associated with their account.
- Delete Accounts: Allows users to delete their accounts if they no longer wish to use the service.

##

- Secure storage of funds
- Transfer of funds between users
- Management of funds through smart contracts
- Transparency of transactions
- Reliability of transactions

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Requirements

- Node.js v10+
- Hardhat v2.12.6+
- @nomicfoundation/hardhat-toolbox v1.0.2+

## Prerequisites

To use this smart contract, you will need the following:

- Knowledge of Solidity programming language
- A local blockchain network (e.g. ganache) or a test network (e.g. Goerli)
- A development environment for smart contract development (e.g. Remix)

## Installation

- To get started, clone this forked repository to your local machine

```
git clone https://github.com/Patrick-Ehimen/Decentralised-Bank.git
```

- install all dependencies with

```
npm install
```

- Open the smart contract in your development environment

- run the following command to deploy the smart contract on your local blockchain network or test network

```
npx hardhat run scripts/deploy.js --network <network-name>
```

- Interact with the smart contract using its functions

## Functions

`createAccount(string memory password)`
This function allows a user to create an account. The user provides a password which is hashed and stored in the smart contract.

deposit()
This function allows a user to deposit funds into their account.

withdraw(uint amount, string memory password)
This function allows a user to withdraw funds from their account. The user provides the amount to be withdrawn and their password. The smart contract will check if the provided password is correct and if the user has sufficient funds before processing the withdrawal.

withdrawFees()
This function allows the owner of the smart contract to withdraw the fees collected from withdrawals.

getBalance()
This function returns the balance of the user's account.

getContractBalance()
This function returns the balance of the smart contract. Only the owner of the contract can access this function.

lockBalance(uint amount, uint unlockTime, string memory password)
This function allows a user to lock a portion of their funds for a specified period of time. The user provides the amount to be locked, the unlock time and their password. The smart contract will check if the provided password is correct and if the user has sufficient funds before processing the lock.

unlockBalance(string memory password)
This function allows a user to unlock the funds they have locked. The user provides their password. The smart contract will check if the provided password is correct and if the unlock time has passed before processing the unlock.
