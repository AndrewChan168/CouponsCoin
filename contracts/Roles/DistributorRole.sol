pragma solidity ^0.5.8;

import "../../node_modules/openzeppelin-solidity/contracts/access/Roles.sol";
import "../../node_modules/openzeppelin-solidity/contracts/GSN/Context.sol";

contract DistributorRole is Context{
    using Roles for Roles.Role;

    Roles.Role private _distributor;

    constructor() internal{
        _addDistributor(msg.sender);
    }

    function isDistributor(address account) public view returns(bool){
        return _distributor.has(account);
    }

    modifier onlyDistributor(){
        require(isDistributor(msg.sender), "DistributorRole: caller does not have the Distributor role");
        _;
    }

    function _addDistributor(address account) internal {
        _distributor.add(account);
    } 

    function addDistributor(address account) public onlyDistributor{
        _addDistributor(account);
    }

    function _removeDistributor(address account) internal {
        _distributor.remove(account);
    }

    function renounceDistributor(address account) public onlyDistributor{
        _removeDistributor(account);
    }
}