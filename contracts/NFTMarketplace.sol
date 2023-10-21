//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.20;

import "hardhat/Console.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";   

contract NFTMarketplace is ERC721URIStorage {
    uint256 private _tokenIdCounter;
    uint256 private _itemsSolCounter;
    address payable owner;
    
    constructor() ERC721("NFTMarketplace", "NFTM") {
        owner = payable(msg.sender);
    }
}