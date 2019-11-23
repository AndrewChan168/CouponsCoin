pragma solidity ^0.5.8;

import "../../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract InterfaceCouponData{
    function createERC20Coupon(address _couponAddress, string calldata _couponName, address _distributorAddress, address _logicAddress) external;
    function createERC721Coupon(address _couponAddress, string calldata _couponName, address _distributorAddress, address _logicAddress) external;
    function getCouponInfo(uint16 _couponsID) external returns(address couponAddress, string memory couponName, address distributorAddress, address logicAddress);
    function getCouponAddress(uint16 _couponsID) external returns(address);
    function getCouponDistributorAddress(uint16 _couponsID) external returns(address);
    function getCouponPrice(uint16 _couponsID) external returns(uint256);
} 

contract InterfaceERC20Coupon{
    function transfer(address recipient, uint256 amount) external returns(bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns(bool);
    function approve(address spender, uint256 amount) external returns(bool);
    function mint(address account, uint256 amount) external returns(bool);
    function increaseAllowance(address spender, uint256 addedValue) external returns(bool);
    function decreaseAllowance(address spender, uint256 addedValue) external returns(bool);
}

contract CouponControl{
    using SafeMath for uint256;

    InterfaceCouponData couponData;

    constructor(address _couponDataAddr) public{
        setCouponData(_couponDataAddr);
    }

    function setCouponData(address _couponDataAddr) public{
        couponData = InterfaceCouponData(_couponDataAddr);
    }

    function isDistributorOfCoupon(address _candidate, uint16 _couponsID) public returns(bool){
        address _distributorAddress = couponData.getCouponDistributorAddress(_couponsID);
        bool result = _distributorAddress==_candidate;
        return result;
    }

    modifier requireDistributorOfCoupon(address _candidate, uint16 _couponsID){
        require(isDistributorOfCoupon(_candidate, _couponsID), "Only distributor of coupon could call this function");
        _;
    }

    function applyCoupons(uint16 qponAmount, uint16 _couponsID) public payable requireDistributorOfCoupon(msg.sender, _couponsID){
        uint256 totalPrice = couponData.getCouponPrice(_couponsID) * qponAmount;
        require(msg.value>=totalPrice, "Payment is not enough to apply the amount of coupons");
        address qponAddress = couponData.getCouponAddress(_couponsID);
        InterfaceERC20Coupon qpon = InterfaceERC20Coupon(qponAddress);
        qpon.mint(msg.sender, qponAmount);
    }
}