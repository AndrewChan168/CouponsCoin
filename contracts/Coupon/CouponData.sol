pragma solidity ^0.5.8;

import "../Admin/Authorizable.sol";

contract CouponData is Authorizable{
    uint16 private couponsID = 1;
    struct CouponInfo{
        address couponAddress;
        string couponName;
        address distributorAddress;
        address logicAddress;
        //CouponType couponType;
        uint8 couponType;
        bool isExist;
        uint256 price;
    }
    //enum CouponType {ERC20, ERC721}
    mapping(uint16=>CouponInfo) couponInfos;

    function getCouponsID() public view returns(uint16){
        return couponsID;
    }

    function _nextCouponsID() private {
        couponsID += 1;
    }

    function createERC20Coupon(address _couponAddress, string memory _couponName, address _distributorAddress, address _logicAddress, uint256 _price) 
    public returns(uint16 _couponsID){
        CouponInfo memory couponInfo;
        couponInfo.couponAddress = _couponAddress;
        couponInfo.couponName = _couponName;
        couponInfo.distributorAddress = _distributorAddress;
        couponInfo.logicAddress = _logicAddress;
        couponInfo.isExist = true;
        couponInfo.couponType = 0;
        couponInfo.price = _price;
        couponInfos[couponsID] = couponInfo;
        _couponsID = couponsID;
        _nextCouponsID();
    }
/*
    function createERC721Coupon(address _couponAddress, string memory _couponName, address _distributorAddress, address _logicAddress, uint256 _price) 
    public returns(uint16 _couponsID){
        CouponInfo memory couponInfo;
        couponInfo.couponAddress = _couponAddress;
        couponInfo.couponName = _couponName;
        couponInfo.distributorAddress = _distributorAddress;
        couponInfo.logicAddress = _logicAddress;
        couponInfo.isExist = true;
        couponInfo.couponType = 1;
        couponInfo.price = _price;
        couponInfos[couponsID] = couponInfo;
        _couponsID = couponsID;
        _nextCouponsID();
    }
*/

    function getCouponInfo(uint16 _couponsID) public view 
    returns(address couponAddress, string memory couponName, uint8 couponType, address distributorAddress, address logicAddress){
        require(_couponsID<=couponsID, "Invalid couponsID: couponsID is larger than current couponsID");

        //couponInfos[_couponsID]
        couponAddress = couponInfos[_couponsID].couponAddress;
        distributorAddress = couponInfos[_couponsID].distributorAddress;
        logicAddress = couponInfos[_couponsID].logicAddress;
        couponName = couponInfos[_couponsID].couponName;
        couponType = couponInfos[_couponsID].couponType;
    }

    modifier requireCouponExist(uint16 _couponsID){
        require(couponInfos[_couponsID].isExist, "No coupon is found for that coupon-ID");
        _;
    }

    function getCouponAddress(uint16 _couponsID) public view requireCouponExist(_couponsID) returns (address){
        return couponInfos[_couponsID].couponAddress;
    }

    function getCouponDistributorsAddress(uint16 _couponsID) public view 
    requireCouponExist(_couponsID) returns (address){
        return couponInfos[_couponsID].distributorAddress;
    }


    function getCouponPrice(uint16 _couponsID) public view requireCouponExist(_couponsID) returns (uint256){
        return couponInfos[_couponsID].price;
    }
}