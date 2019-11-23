const ERC20Coupon = artifacts.require("ERC20Coupon");
//const Administrationable = artifacts.require("Administrationable");

module.exports = function(deployer){
    deployer.deploy(ERC20Coupon);
};