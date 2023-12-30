// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// Lottery Smart Contract
contract Lottery {
    using SafeMath for uint256;

    address public manager; // Contract Manager
    address[] public players; // List of players
    mapping(address => uint256) public playerNumbers; // Player number associated with each address
    bytes32 public lastSecretHash; // Hash of the last secret
    uint256 public lastWinnerNumber; // Number of the last winner
    address public lastWinner; // Address of the last winner

    event Winner(address winner, uint256 winnerNumber); // Event for the winner

    // Restricts access to the manager
    modifier restricted() {
        require(msg.sender == manager, "Only the manager can call this");
        _;
    }

    // Constructor sets the manager to the contract creator
    constructor() {
        manager = msg.sender;
    }

    // Protection against reentrancy attacks
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    // Functions for nonReentrant modifier
    function _nonReentrantBefore() private {
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        _status = _NOT_ENTERED;
    }

    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;
    uint256 private _status = _NOT_ENTERED;

    // Allows a player to enter the lottery
    function enter(uint256 playerSecretNumber) public payable nonReentrant {
        require(msg.value > .01 ether, "Minimum ETH required is 0.01");
        if(playerNumbers[msg.sender] == 0) {
            players.push(msg.sender); 
        }
        playerNumbers[msg.sender] = playerSecretNumber; 
    }

    // Sets the secret hash
    function setSecretHash(bytes32 _secretHash) public restricted {
        lastSecretHash = _secretHash;
    }

    // Picks the lottery winner
    function pickWinner(uint256 secretSum) public restricted nonReentrant {
        require(players.length > 0, "No players in the lottery");

        lastWinnerNumber = (secretSum) % players.length;
        lastWinner = players[lastWinnerNumber];

        uint256 balance = address(this).balance;
        payable(lastWinner).transfer(balance);

        emit Winner(lastWinner, lastWinnerNumber);

        for (uint256 i = 0; i < players.length; i++) {
            delete playerNumbers[players[i]];
        }
        players = new address[](0);
    }

    // Validates the secret against the hash
    function validateSecret(uint256 _secret, bytes32 _secretHash) public pure returns (bool) {
        return keccak256(abi.encodePacked(_secret)) == _secretHash;
    }

    // Verifies the integrity of the game
    function verifyGame(bytes32 _secretHash, uint256 _secret, address _winner) public view returns (bool) {
        require(validateSecret(_secret, _secretHash), "The secret number does not match the secret hash");

        uint256 playerNumSum = 0;
        for (uint256 i = 0; i < players.length; i++) {
            playerNumSum = playerNumSum.add(playerNumbers[players[i]]);
        }

        require(_winner == players[(_secret + playerNumSum) % players.length], "The winner is not correct");

        return true;
    }
}

// SafeMath library to prevent overflow and underflow
library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }
}
