// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract DiceGame is VRFConsumerBase {
    uint256 public randomResult;
    uint256 private constant RANGE = 6;
    uint256 private constant OFFSET = 1;
    uint256 private constant FEE = 0.1 * 10**18; // 0.1 LINK
    bytes32 private constant KEY_HASH = 0x1a4c4f84b27e6dddc1578d4a91f9ac8192f24172fa54c8f95e956791c05a0412;

    event DiceRolled(address indexed player, uint256 indexed result);

    constructor(address vrfCoordinator, address link) VRFConsumerBase(vrfCoordinator, link) {}

    function rollDice() public payable {
        require(msg.value >= FEE, "Not enough funds to play");

        bytes32 requestId = requestRandomness(KEY_HASH, FEE);
        emit DiceRolled(msg.sender, (randomResult % RANGE) + OFFSET);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        randomResult = randomness;
    }
}
