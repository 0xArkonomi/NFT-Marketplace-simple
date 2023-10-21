//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.20;

import "hardhat/Console.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";   

contract NFTMarketplace is ERC721URIStorage {
    address payable owner;
    uint256 private _tokenIdCounter;
    uint256 private _itemsSolCounter;
    uint256 listPrice = 0.01 ether;
    
    constructor() ERC721("NFTMarketplace", "NFTM") {
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only owner can update the listing price!"
        );
        _;
    }

    struct ListedToken {
        uint256 tokenId;
        uint256 price;
        address payable owner;
        address payable seller;
        bool currentlyListed;
    }

    mapping(uint256 => ListedToken) idToListedToken;

    function updateListPrice(uint256 _listPrice) public payable onlyOwner {
        listPrice = _listPrice;
    }

    function getListPrice() public view returns(uint256) {
        return listPrice;
    }

    function  getLatestIdToListedToken() public view returns(ListedToken memory) {
        
        return idToListedToken[_tokenIdCounter];
    }

    function getlistedForTokenId(uint256 tokenId) public view returns(ListedToken memory) {
        return idToListedToken[tokenId];
    }

    function getCurrentTokenId() public view returns(uint256) {
        return _tokenIdCounter;
    }
}