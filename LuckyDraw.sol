// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
contract LuckyDraw {

    struct Draw {
        bytes32 players;
        uint luckyNumber;
    }

    address public owner;

    mapping(uint => Draw) public draws;

    event DrawFinish(uint id, uint luckyNumber, uint playerCount, bytes32 playersHash);

    constructor() {
        owner = msg.sender;
    }

    function generate(uint id, uint playerCount, bytes32 playersHash) external returns (uint) {
        require(msg.sender == owner, "Only owner can draw.");
        uint randomNumber = random(playerCount);
        Draw storage draw = draws[id];
        draw.players = playersHash;
        draw.luckyNumber = randomNumber;

        emit DrawFinish(id, randomNumber, playerCount, playersHash);

        return randomNumber;
    }

    function random(uint playerCount) private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % playerCount;
    }

    function getLuckyNumber(uint id) public view returns (uint)
    {
        return draws[id].luckyNumber;
    }

    function getPlayersHash(uint id) public view returns (bytes32)
    {
        return draws[id].players;
    }
}