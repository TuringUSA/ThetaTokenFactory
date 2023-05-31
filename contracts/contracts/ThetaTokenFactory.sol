// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./TNT20.sol";

contract ThetaTokenFactory is Ownable{
    using SafeERC20 for IERC20;
    using SafeERC20 for TNT20;

    uint256 public price;
    uint256 public id;

    mapping(uint256 => TNT20) public TokenToId;

    constructor(uint256 price_){
        price = price_;
    }

    function createToken(
        string memory name,
        string memory symbol,
        uint256 amount
    ) external payable{
        require(
            msg.value >= price,
            "ThetaTokenFactory: you didn't pay for token creation"
        );

        TNT20 token = new TNT20(name,symbol,amount);

        TokenToId[++id] = token;
        token.transferOwnership(_msgSender());
        token.safeTransfer(_msgSender(),amount * 10 ** 18);
    }

    function changePrice(uint256 price_) external onlyOwner{
        price = price_;
    }

    function withdrawToken(address to,address token_) external onlyOwner {
        IERC20 tokenToWithdraw = IERC20(token_);

        tokenToWithdraw.safeTransfer(
            to,
            tokenToWithdraw.balanceOf(address(this))
        );
    }

    function withdrawTFuel(address payable to) external onlyOwner {
        to.transfer(address(this).balance);
    }

    receive() external payable {}
}