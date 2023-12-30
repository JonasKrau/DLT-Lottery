# Ethereum Lottery Smart Contract

## Overview
This project is a simple implementation of a lottery system as a smart contract on the Ethereum blockchain using Solidity. It's designed as a starting point for development and enhancement. The contract should be compiled and deployed using the Remix IDE.

## Features
- **Lottery Entry**: Users can enter the lottery by sending ETH.
- **Random Winner Selection**: Winners are selected based on secret numbers and hash.
- **Security**: Incorporates non-reentrancy pattern and SafeMath library for secure operations.

## Prerequisites
- Ethereum wallet with ETH for deployment.
- Understanding of Solidity, smart contracts and Remix.

## Installation and Usage
1. Clone the repository: git clone https://github.com/JonasKrau/DLT-Lottery.git
2. Open the Remix IDE (https://remix.ethereum.org) and import the contract.
3. Compile and deploy the contract to the Ethereum test network Sepolia using Remix.

## Contract Functions
- `enter(uint256)`: Enter the lottery.
- `pickWinner(uint256)`: Select a winner.
- `validateSecret(uint256, bytes32)`: Validate the secret number.
- `verifyGame(bytes32, uint256, address)`: Verify game integrity.

## Contributing
Contributions are welcome. Please fork the repository and submit a pull request.

## Security
Note: This smart contract has not been audited. Use it at your own risk.

## License
This project is licensed under the MIT License.

