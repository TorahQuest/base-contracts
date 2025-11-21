// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/ShabbatGuard.sol";

contract ShabbatGuardTest is Test {
    ShabbatGuard guard;
    address usdc = 0x036CbD53842c5426634e7929541eC2318f3dCF7e;
    address learner = address(0x123);

    function setUp() public {
        guard = new ShabbatGuard(usdc);
        guard.transferOwnership(address(this));
    }

    function testShabbatBlock() public {
        vm.prank(learner);
        guard.setShabbatTimes(block.timestamp - 1 hours, block.timestamp + 1 hours);

        vm.expectRevert("Shabbos Kodesh");
        guard.payLearningReward(learner, 100e6);
    }

    function testRewardAfterHavdala() public {
        vm.prank(learner);
        guard.setShabbatTimes(block.timestamp - 48 hours, block.timestamp - 24 hours);

        guard.payLearningReward(learner, 100e6); // should succeed
    }
}
