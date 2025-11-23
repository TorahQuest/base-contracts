// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ShabbatGuard is Ownable {
    IERC20 public usdc;

    mapping(address => uint256) public shabbatStart;
    mapping(address => uint256) public shabbatEnd;

    uint256 constant BUFFER = 600; // 10 minutes

    event ShabbatTimesSet(address indexed user, uint256 start, uint256 end);
    event RewardBlocked(address indexed user);
    event RewardPaid(address indexed user, uint256 learnerAmount, uint256 tzedakahAmount);

    constructor(address _usdc) {
        usdc = IERC20(_usdc);
    }

    modifier notShabbat(address user) {
        uint256 start = shabbatStart[user];
        uint256 end = shabbatEnd[user];
        if (start == 0 || end == 0) revert("Set zmanim first");

        if (block.timestamp >= (start - BUFFER) && block.timestamp <= (end + BUFFER)) {
            emit RewardBlocked(user);
            revert("Shabbos Kodesh - transaction blocked. Gut Shabbos!");
        }
        _;
    }

    function setShabbatTimes(uint256 startUnix, uint256 endUnix) external {
        require(endUnix > startUnix + 24 hours, "Invalid window");
        shabbatStart[msg.sender] = startUnix;
        shabbatEnd[msg.sender] = endUnix;
        emit ShabbatTimesSet(msg.sender, startUnix, endUnix);
    }

    function payLearningReward(address learner, uint256 amount) external onlyOwner notShabbat(learner) {
        uint256 learnerAmount = amount * 90 / 100;
        uint256 tzedakahAmount = amount - learnerAmount;

        usdc.transfer(learner, learnerAmount);
        usdc.transfer(owner(), tzedakahAmount); // owner = Tzedakah multisig

        emit RewardPaid(learner, learnerAmount, tzedakahAmount);
    }
}
