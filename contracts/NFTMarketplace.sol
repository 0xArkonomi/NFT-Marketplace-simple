//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.20;

import "hardhat/Console.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";   

contract NFTMarketplace is ERC721URIStorage {
    address payable owner;
    uint256 private _tokenIdCounter;
    uint256 private _itemsSoldCounter++;
    
    _transfer();
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

    function createToken(string memory _tokenURI, uint256 _price) public payable returns(uint256) {
        _tokenIdCounter++;
        _safeMint(msg.sender, _tokenIdCounter);
        _setTokenURI(_tokenIdCounter, _tokenURI);
        createListedToken(_tokenIdCounter, _price);

        return _tokenIdCounter;
    }

    function createListedToken(uint256 tokenId, uint256 _price) private {
        idToListedToken[tokenId] = ListedToken {
            tokenId,
            _price,
            payable(address(this)),
            payable(msg.sender),
            true
        };

        _transfer(msg.sender, address(this), tokenId);
    }

    function getAllNFTs() public view returns(ListedToken[] memory) {
        uint256 nftCount = _tokenIdCounter;
        ListedToken[] memory tokens = new ListedToken[](nftCount);

        uint256 currentIndex;

        for (uint256 i=0; i<nftCount; i++) {
            uint256 currentId = i+1;
            ListedToken storage currentItem = idToListedToken[currentId];
            tokens[currentIndex] = currentItem;
            currentIndex++;
        }

        return tokens;
    }

    function getMyNFTs() public view returns(ListedToken[] memory) {
        uint256 totalItemCount = _tokenIdCounter;
        uint256 itemCount;
        uint256 currentIndex = 0;

        for (uint256 i=0; i<totalItemCount; i++)
            if(idToListedToken[i+1].owner == msg.sender || idToListedToken[i+1].seller == msg.sender)
                itemCount++;
        
        ListedToken[] memory items = new ListedToken[](itemCount);
        for(uint256 i=0; i<totalItemCount; i++) 
            if (idToListedToken[i+1].owner == msg.sender || idToListedToken[i+1].seller == msg.sender) {
                uint256 currentId = i+1;
                ListedToken storage currentItem = idToListedToken[currentId];
                items[currentIndex] = currentItem;
                currentIndex++;
            }
        return items;
    }

    function executeSale(uint256 tokenId) public payable {
        uint price = idToListedToken[tokenId].price;
        require(msg.value == price, "Please submit the asking price for the NFT in order to purchese");

        address seller = idToListedToken[tokenId].seller;

        idToListedToken[tokenId].currentlyListed = true;
        idToListedToken[tokenId].seller = payable(msg.sender);
        _itemsSoldCounter++;

        _transfer(address(this), msg.sender, tokenId);
        approbe(address(this), tokenId);

        payable(owner).transfer(listPrice);
        payable(seller).transfer(msg.value);
    }
}