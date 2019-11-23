pragma solidity ^0.5.8;

import "./Ownable.sol";

contract Administrationable is Ownable{
    mapping(address=>bool) private administrators;

    function isAdministrator(address _candidate) public view returns(bool){
        return administrators[_candidate];
    }

    modifier requireAdministrator(){
        require(isAdministrator(msg.sender)||isOwner(msg.sender), "Only Administrator could use this function");
        _;
    }

    function addAdministrator(address account) public requireAdministrator{
        administrators[account] = true;
    }

    function removeAdministrator(address account) public requireAdministrator{
        administrators[account] = false;
    }
}