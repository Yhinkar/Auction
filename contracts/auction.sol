//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract auction{
    // an auction contraction for swift bid..
    // State variables..

    address payable public bidder;
    address public highestbidder;
    uint public highestbid;
    uint public auctionEndtime;
    bool hasItend = false;
    address public owner;

    mapping(address => uint) public Returns;
    event highestbidincrease(address indexed bidder, uint indexed amount);
    event auctionEnd(address indexed winner, uint indexed amount);

    constructor(address payable _bidder, uint bidtime){
        owner = msg.sender;
        bidder = _bidder;
        auctionEndtime = block.timestamp + bidtime * 60;

    }

    modifier onlyOwner (){
        owner == msg.sender;
        _;
    }

    function bidAuction() public payable {
        require(block.timestamp < auctionEndtime, "auction has ended...");
        require(msg.value > highestbid, "you need enough funds!");
        Returns[highestbidder] += highestbid;
        highestbidder = msg.sender;
        highestbid = msg.value;
        emit highestbidincrease(msg.sender, msg.value);
    }

    function autionEnd() public onlyOwner returns(bool) {
        require(block.timestamp > auctionEndtime, "auction hasn't end!");
        require(!hasItend, "has been called");

        hasItend = true;

        emit auctionEnd(highestbidder, highestbid);
        (bool sent, ) = bidder.call{value : highestbid}("");
        return sent;

      
    }

    function checkBid() public view returns(uint){
        return Returns[msg.sender];
    }

    function withdraw() public returns(bool){
        uint _amount = Returns[msg.sender];

        if(_amount > 0){
            Returns[msg.sender] = 0;
            (bool sent, ) = msg.sender.call{value : _amount}("");
            if(!sent){
                Returns[msg.sender] = _amount;
                return false;
            }
        }
        return true;
    }

    receive() external payable{
        
    }
 }
