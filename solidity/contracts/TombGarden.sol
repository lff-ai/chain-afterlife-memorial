// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract TombGarden {
    struct Tomb {
        string name;
        string epitaph;
        address owner;
        uint256 totalRespect;
    }

    uint256 public buryFee = 0.002 ether;
    uint256 public respectFee = 0.001 ether;
    address public immutable owner;
    uint256 public tombCount;
    mapping(uint256 => Tomb) public tombs;

    event TombBuried(uint256 indexed tombId, string name, string epitaph, address indexed owner, uint256 amount);
    event RespectPaid(uint256 indexed tombId, address indexed payer, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function setFees(uint256 newBuryFee, uint256 newRespectFee) external onlyOwner {
        buryFee = newBuryFee;
        respectFee = newRespectFee;
    }

    function bury(string calldata name, string calldata epitaph) external payable returns (uint256 tombId) {
        require(bytes(name).length > 0, "empty name");
        require(bytes(epitaph).length > 0, "empty epitaph");
        require(msg.value >= buryFee, "insufficient bury fee");

        tombId = tombCount;
        tombs[tombId] = Tomb({name: name, epitaph: epitaph, owner: msg.sender, totalRespect: 0});
        tombCount += 1;

        emit TombBuried(tombId, name, epitaph, msg.sender, msg.value);
    }

    function payRespect(uint256 tombId) external payable {
        require(tombId < tombCount, "tomb not found");
        require(msg.value >= respectFee, "insufficient respect fee");

        tombs[tombId].totalRespect += 1;
        emit RespectPaid(tombId, msg.sender, msg.value);
    }

    function withdraw(address payable to) external onlyOwner {
        uint256 bal = address(this).balance;
        require(bal > 0, "empty balance");
        to.transfer(bal);
    }
}
