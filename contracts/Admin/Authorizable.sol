pragma solidity ^0.5.8;

import "./Operationable.sol";

contract Authorizable is Operationable{
    mapping(address=>bool) authorizedCallers;
    bool authorizable;
    
    function isAuthorizedCaller(address _candidate) public view returns(bool){
        return authorizedCallers[_candidate];
    }

    modifier requireAuthorizedCaller(){
        require((isAuthorizedCaller(msg.sender))||(isAdministrator(msg.sender)), "Only authorized callers could call this function");
        _;
    }

    function addAuthorizedCaller(address _candidate) public requireAdministrator requireOperationable{
        authorizedCallers[_candidate] = true;
    }

    function setAuthorizable(bool _setting) public requireAdministrator requireOperationable{
        authorizable = _setting;
    }
}