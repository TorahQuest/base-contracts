// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@erc6551/ERC6551Registry.sol";
import "@erc6551/interfaces/IERC6551Account.sol";

contract TorahAgentNFT is ERC721 {
    ERC6551Registry public registry;
    address public implementation; // TBA implementation

    uint256 public nextTokenId;

    constructor(address _registry, address _implementation) ERC721("Torah Agent", "TORA") {
        registry = ERC6551Registry(_registry);
        implementation = _implementation;
    }

    function mint(address to) external returns (address) {
        uint256 tokenId = ++nextTokenId;
        _safeMint(to, tokenId);

        address tba = registry.createAccount(implementation, block.chainid, address(this), tokenId, 0, "");

        return tba; // this is the agent's smart wallet
    }
}
