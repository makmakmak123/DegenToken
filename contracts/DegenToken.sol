// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {

    struct Red_Item {
        uint Need_Tokens;
        string item_Name;
        bool Item_Redeemed;
    }

    Red_Item[] private Red_Items;

    constructor()
    ERC20("Degen", "DGN")
    Ownable()
    {
        Red_Items.push(Red_Item(55, "okinawa - Milktea", false));
        Red_Items.push(Red_Item(12, "Taro - Milktea", false));
        Red_Items.push(Red_Item(18, "Pearl - Milktea", false));
        Red_Items.push(Red_Item(26, "Cookies and Cream - Milktea", false));
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount); 
    }

    function decimals() override public pure returns (uint8) {
        return 0;
    }

    function getBalance() external view returns (uint256) {
        return this.balanceOf(msg.sender);
    }

    function transferTokens(address _receive, uint256 _val) external {
        require(balanceOf(msg.sender) >= _val, "The current tokens are not enough to cover the transfer, please check balance!");
        approve(msg.sender, _val);
        transferFrom(msg.sender, _receive, _val);
    }

    function burnTokens(uint256 _val) external {
        require(balanceOf(msg.sender) >= _val, "The current tokens are not enough to cover burn of the requested amount, please check balance!");
        burn(_val);
    }

    function redeemTokens(uint8 input) external payable returns (string memory) {
    if (input >= Red_Items.length) {
        revert("Wrong Input");
    }

    Red_Item storage item = Red_Items[input];
    
    if (item.Item_Redeemed) {
        revert("The item is already redeemed!");
    }
    
    if (balanceOf(msg.sender) < item.Need_Tokens) {
        revert("The current tokens are not enough to cover the redeem, please check balance!");
    }

    approve(msg.sender, item.Need_Tokens);
    transferFrom(msg.sender, owner(), item.Need_Tokens);
    item.Item_Redeemed = true;

    return string.concat(item.item_Name, " has been redeemed!");
}

    function showStoreItems() public view returns (string memory) {
        string memory itemPrintStr = "";

        for (uint i = 0; i < 4; i++) {
            itemPrintStr = string.concat(itemPrintStr, "   ", Strings.toString(i), ". ", Red_Items[i].item_Name);
        }

        return itemPrintStr;
    }
}