pragma solidity ^0.5.0;

import "./Token.sol";

contract EthSwap {
    string public name = "EthSwap Instant Exchange"; // State variable, because "name" is also stored on the blockchain!
    Token public token;
    uint public rate = 100;

    event TokensPurchased(
        address account,
        address token,
        uint amount,
        uint rate
    );

      event TokensSold(
        address account,
        address token,
        uint amount,
        uint rate
    );

    // Solidity constructor, can only be called once for putting in the blockchain. Not usable in tests or whatever!
    constructor(Token _token) public {
        token = _token; // Only local variable, does not get stored on the blockchain unless its assigned like here...
    }

    // Transfer tokens from the ethswap to the buyer, calculating the value
    function buyTokens() public payable {
        // Redemption rate = # of Tokens they receive for one ether
        // Amount of Etherum * Redemption rate
        // Calculate the number of tokens to buy
        uint tokenAmount = msg.value * rate;

        // Stop executing the function, when the limit amount of tokens is full.
        // This is the address of the smart contract, the address of ethSwap
        require(token.balanceOf(address(this)) >= tokenAmount);

        // Transfers tokens to the user.
        token.transfer(msg.sender, tokenAmount);

        // Emit an event, ppl should subscribe to this and know when tokens were purchased
        emit TokensPurchased(msg.sender, address(token), tokenAmount, rate);
    }

    function sellTokens(uint _amount) public {
        // User cant sell more Tokens than they have
        require(token.balanceOf(msg.sender) >= _amount);

        // Calculate the amount of Ether to redeem
        // Amount of Etherum / Redemption rate
        uint etherAmount = _amount / rate;

        // Require that EthSwap has enough Ether.
        require(address(this).balance >= etherAmount);
        
        // Perform sale and spending tokens is possible via transferFrom()
        token.transferFrom(msg.sender, address(this), _amount);
        msg.sender.transfer(etherAmount);

        // Emit an event
        emit TokensSold(msg.sender, address(token), _amount, rate);
    }

}