// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/ShabbatGuard.sol";
import "../src/RewardDistributor.sol";
import "../src/TorahAgentNFT.sol";

contract DeployAll is Script {
    function run() external {
        vm.startBroadcast();

        // Base Sepolia USDC
        address usdc = 0x036CbD53842c5426634e7929541eC2318f3dCF7e;

        // Mainnet USDC: 0x833589fCD6eDb88134D6F6b5B1248e0c58eF4c9f

        ShabbatGuard guard = new ShabbatGuard(usdc);
        RewardDistributor distributor = new RewardDistributor(usdc);

        // ERC-6551 registry & default impl on Base
        address registry = 0x000000006551c19487814612e58FE06813775758;
        address impl = 0x2D2560255C6D0A02a84e3593a9e6dd9a6C265142;

        TorahAgentNFT agentNFT = new TorahAgentNFT(registry, impl);

        // Transfer ownership to multisig (you set later)
        guard.transferOwnership(msg.sender);
        distributor.transferOwnership(msg.sender);

        console.log("ShabbatGuard:", address(guard));
        console.log("RewardDistributor:", address(distributor));
        console.log("TorahAgentNFT:", address(agentNFT));

        vm.stopBroadcast();
    }
}
