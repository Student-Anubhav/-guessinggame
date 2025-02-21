// guessinggame
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NumberGuessingGame {
    address public owner;
    uint256 private winningNumber;
    uint256 public minBet = 0.01 ether;
    uint256 public maxGuessRange = 10;

    mapping(address => uint256) public lastGuess;
    mapping(address => bool) public isWinner;

    event GamePlayed(address indexed player, uint256 guess, bool won, uint256 prize);

    function setWinningNumber(uint256 _number) public {
        require(msg.sender == owner, "Only owner can set winning number");
        require(_number >= 1 && _number <= maxGuessRange, "Number out of range");
        winningNumber = _number;
    }

    function play(uint256 guess) public payable {
        require(msg.value >= minBet, "Minimum bet required");
        require(guess >= 1 && guess <= maxGuessRange, "Guess out of range");

        lastGuess[msg.sender] = guess;
        bool won = (guess == winningNumber);

        if (won) {
            uint256 prize = address(this).balance;
            isWinner[msg.sender] = true;
            payable(msg.sender).transfer(prize);
            emit GamePlayed(msg.sender, guess, true, prize);
        } else {
            emit GamePlayed(msg.sender, guess, false, 0);
        }
    }

    function fundContract() public payable {
        require(msg.sender == owner, "Only owner can fund");
    }

    function withdrawFunds(uint256 amount) public {
        require(msg.sender == owner, "Only owner can withdraw");
        require(amount <= address(this).balance, "Insufficient balance");
        payable(owner).transfer(amount);
    }
}
