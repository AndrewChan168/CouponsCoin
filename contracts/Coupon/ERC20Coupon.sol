pragma solidity ^0.5.8;

//import "../../node_modules/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "../../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./../Admin/Authorizable.sol";

contract ERC20Coupon is Authorizable{
    using SafeMath for uint256;
    address private _distributor;

    mapping (address => uint256) private _balances;
    mapping (address => bool) private _existList;
    address[] private _nameList;

    //mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    function distributorOf() public view returns(address){
        return _distributor;
    }

    function isDistributor(address account) public view returns(bool){
        return _distributor==account;
    }

    function setDistributor(address account) public requireAdministrator{
        require(distributorOf()==address(0), "This coupon has distributor before");
        require(account!=address(0), "Could not set distributor as 0x address");
        _distributor = account;
        //_addCouponOwner(_distributor);
    }

    modifier requireDistributor(){
        require(distributorOf()!=address(0), "Distributor of Coupon is not set");
        _;
    }

    function _addCouponOwner(address account) internal{
        _existList[account] = true;
        _nameList.push(account);
    }

    function hasCouponOwner(address account) public view returns(bool){
        return _existList[account];
    }

    function allCouponOwners() public requireAdministrator view returns(address[] memory){
        return _nameList;
    }

    function totalSupply() public view returns(uint256){
        return _totalSupply;
    }

    function balanceOf(address account) public view returns(uint256){
        return _balances[account];
    }

    function _transfer(address sender, address recipient, uint256 amount) internal{
        require(sender != address(0), "Transfer from the zero address");
        require(recipient != address(0), "Transfer to the zero address");
        require(_balances[sender]>=amount, "Transfering amounts exceeds than balance of sender");
        _balances[sender] = _balances[sender].sub(amount, "Transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
    }

    modifier checkCouponOwner(address recipient){
        if(!hasCouponOwner(recipient)){
            _addCouponOwner(recipient);
        }

        _;
    }

    function transfer(address recipient, uint256 amount) public 
    requireOperationable checkCouponOwner(recipient) returns (bool) {
        require(msg.sender==_distributor, "Owner distributor could use transfer()");
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public
    requireAuthorizedCaller requireOperationable checkCouponOwner(to) returns(bool){
        require(hasCouponOwner(from)||isDistributor(from), "Token sender is not in the list");
        _transfer(from, to, amount);
        return true;
    }

    function _mint(uint256 amount) internal{
        //require(account==_distributor, "Only allow mint for distributor");
        _totalSupply = _totalSupply.add(amount);
        _balances[_distributor] = _balances[_distributor].add(amount);
    }

    function mint(uint256 amount) public 
    requireAuthorizedCaller requireOperationable returns(bool){
        require(_distributor!=address(0), "Distributor of coupon has not set yet");
        _mint(amount);
        return true;
    }
}