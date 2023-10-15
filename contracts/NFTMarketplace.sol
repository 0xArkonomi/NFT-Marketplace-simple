//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/Console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extentions/ERC721URISotrage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTMarketplace is ERC721URIStorage {
    
    constructor() ERC721("NFRMarketplace", "NFTM") {
        
    }
}