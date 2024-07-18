// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract BookRoyalties {
    address public owner;
    uint256 public totalroyaltiesCollected;
    mapping (address => uint256) public royaltiesBalance;
    mapping (address => uint256) public authorShares;
    address[] public authorList;

    event RoyaltiesColelected(address indexed from, uint256 amount);
    event RoyaltiesWithdrawn(address indexed to, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function setAuthorShare(address author, uint256 share) public onlyOwner {
        require(share > 0 && share <= 100, "Share must be between 0 and 100");
        if(authorShares[author] == 0) {
            authorList.push(author);
        }
        authorShares[author] = share;
    }

    function collectRoyalties() public payable {
        require(msg.value > 0, "Some ether must be sent");
        uint256 totalShare = 0;

        for(uint256 i = 0; i < authorList.length; i++) {
            totalShare += authorShares[authorList[i]];
        }

        require(totalShare == 100, "Total share must be 100%");

        totalroyaltiesCollected += msg.value;

        for (uint256 i = 0; i < authorList.length; i++) {
            address author = authorList[i];
            uint256 royalty = (msg.value * authorShares[author]) / 100;
            royaltiesBalance[author] += royalty;
        }

        emit RoyaltiesColelected(msg.sender, msg.value);
    }

    function withdrawRoyalties() public {
        uint256 amount = royaltiesBalance[msg.sender];
        require(amount > 0, "No royalties to withdraw");

        royaltiesBalance[msg.sender] = 0;
        payable(msg.sender).transfer(amount);

        emit RoyaltiesWithdrawn(msg.sender, amount);
    }

    function getAuthor() public view returns (address[] memory) {
        return authorList;
    }

    receive() external payable {
        collectRoyalties();
    }
}