pragma solidity ^0.5.8;

contract Ownable{
    address private owner;

    constructor () public{
        owner = msg.sender;
    }

    function isOwner(address _candidater) public view returns(bool){
        return _candidater == owner;
    }

    modifier requireContractOwner(){
        require(isOwner(msg.sender), "Sender is not the owner of contract");
        _;
    }

    function getOwner() public view returns(address){
        return owner;
    }
}