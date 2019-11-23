const owner = accounts[0]
const distributorA = accounts[1]
const adminA = accounts[5]
const consumer01 = accounts[12]
const consumer02 = accounts[13]

let erc20Coupon = await ERC20Coupon.new({from:owner})

await erc20Coupon.setDistributor(distributorA, {from:owner})
await erc20Coupon.addAuthorizedCaller(adminA, {from:owner})

await erc20Coupon.mint(100, {from:adminA})
await erc20Coupon.balanceOf.call(distributorA)

await erc20Coupon.hasCouponOwner.call(consumer01)

await erc20Coupon.transfer(consumer01, 1, {from:distributorA})

await erc20Coupon.balanceOf.call(consumer01)

await erc20Coupon.transferFrom(distributorA, consumer01, 1, {from:adminA})
await erc20Coupon.balanceOf.call(consumer01)