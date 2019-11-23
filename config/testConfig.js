let ERC20Coupon = artifacts.require("ERC20Coupon");

let Config = async(accounts)=>{
    const owner = accounts[0];
    const distributorA = accounts[1];
    const distributorB = accounts[2];
    const distributorC = accounts[3];
    const hacker = accounts[4];
    const adminA = accounts[5];
    const adminB = accounts[6];
    const cashierA01 = accounts[7];
    const cashierA02 = accounts[8];
    const cashierA03 = accounts[9];
    const cashierB01 = accounts[10];
    const cashierC01 = accounts[11];
    const consumer01 = accounts[12];
    const consumer02 = accounts[13];
    const consumer03 = accounts[14];
    const consumer04 = accounts[15];
    const consumer05 = accounts[16];
    const consumer06 = accounts[17];
    const consumer07 = accounts[18];
    const consumer08 = accounts[19];

    let erc20Coupon = await ERC20Coupon.new({from:owner});

    return {
        erc20Coupon:erc20Coupon,
        owner:owner,
        distributorA:distributorA,
        distributorB:distributorB,
        distributorC:distributorC,
        hacker:hacker,
        adminA:adminA,
        adminB:adminB,
        cashierA01:cashierA01,
        cashierA02:cashierA02,
        cashierA03:cashierA03,
        cashierB01:cashierB01,
        cashierC01:cashierC01,
        consumer01:consumer01,
        consumer02:consumer02,
        consumer03:consumer03,
        consumer04:consumer04,
        consumer05:consumer05,
        consumer06:consumer06,
        consumer07:consumer07,
        consumer08:consumer08
    }
}

module.exports = {
    Config: Config
};