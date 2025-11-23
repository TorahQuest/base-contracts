// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/ShabbatGuard.sol";
import "../src/RewardDistributor.sol";
import "../src/TorahAgentNFT.sol";

contract DeployAll is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        // Load config from .env via vm.envAddress
        address usdc = vm.envAddress("USDC_ADDRESS");
        address registry = vm.envAddress("ERC6551_REGISTRY");
        address impl = vm.envAddress("ERC6551_IMPL");

        ShabbatGuard guard = new ShabbatGuard(usdc);
        RewardDistributor distributor = new RewardDistributor(usdc);

        TorahAgentNFT agentNFT = new TorahAgentNFT(registry, impl);

        // Transfer ownership to multisig (set in .env or hardcode multisig later)
        guard.transferOwnership(msg.sender);
        distributor.transferOwnership(msg.sender);

        console.log("=== TORAH QUEST DEPLOYED ===");
        console.log("ShabbatGuard:", address(guard));
        console.log("RewardDistributor:", address(distributor));
        console.log("TorahAgentNFT:", address(agentNFT));
        console.log("USDC used:", usdc);
        console.log("Chain ID:", block.chainid);

        vm.stopBroadcast();
    }
}
