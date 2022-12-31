pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Ediz721 is ERC721{

    uint256 maxSupply;

    constructor(string memory _name, string memory _symbol, uint256 _maxSupply) ERC721(_name, _symbol){
        
        _maxSupply = maxSupply;
    }

    function mint(address receiver, uint256 tokenId) external{
        require(tokenId < maxSupply, "Over take");
        _mint(receiver, tokenId);
    }
}
