pragma solidity ^0.5.8;

import "./Administrationable.sol";

contract Operationable is Administrationable{
    bool private operationable = true;

    function isOperationable() public view returns (bool){
        return operationable;
    }

    modifier requireOperationable{
        require(isOperationable(), "Contract is not in operationable state");
        _;
    }

    function setOperationable() public requireAdministrator{
        operationable = true;
    }

    function setUnoperationable() public requireAdministrator{
        operationable = false;
    }
}