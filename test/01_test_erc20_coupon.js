const Test = require('../config/testConfig.js');

contract(`Test ERC20 Coupon`, async(accounts)=>{
    before(async()=>{
        config = await Test.Config(accounts);
    })

    describe(`test administrationable`, function(){
        it(`1) allows owner to set distributor`, async()=>{
            try{
                await config.erc20Coupon.setDistributor(config.distributorA, {from:config.owner});
            }catch(err){
                assert.fail(`Owner could not set distributor: ${err.message}`);
            }

            assert.equal(await config.erc20Coupon.distributorOf.call(), config.distributorA, 
                        "Distributor of coupon is not correct after setDistributor()");
        })

        it(`2) only allows owner to add authorized caller`, async()=>{
            let allowAdd = true;
            try{
                await config.erc20Coupon.addAuthorizedCaller(config.hacker, {from:config.hacker});
            }catch(err){
                //console.log(`Error message:${err.message}`);
                allowAdd = false;
            }
    
            assert.equal(allowAdd, false, "Could not restrict hacker to add hacker as authorized caller");
        });

        it(`3) allows owner to add authorized caller`, async()=>{
            assert.equal(await config.erc20Coupon.isAuthorizedCaller.call(config.adminA), false, 
                    "Already be authorized caller before call addAuthorizedCaller() method");
            assert.equal(await config.erc20Coupon.isAuthorizedCaller.call(config.adminB), false, 
                    "Already be authorized caller before call addAuthorizedCaller() method");
            try{
                await config.erc20Coupon.addAuthorizedCaller(config.adminA, {from:config.owner});
                await config.erc20Coupon.addAuthorizedCaller(config.adminB, {from:config.owner});
            }catch(err){
                //console.log(`Error message:${err.message}`);
                assert.fail(`Error on adding administrator by owner: ${err.message}`);
            }
            assert.equal(await config.erc20Coupon.isAuthorizedCaller.call(config.adminA), true, 
                        "not  be authorized caller after call addAuthorizedCaller() method");
            assert.equal(await config.erc20Coupon.isAuthorizedCaller.call(config.adminB), true, 
                        "not  be authorized caller after call addAuthorizedCaller() method");
        });
    });

    describe(`test minting part`, function(){
        it(`4) allows admin to mint token for distributor`, async()=>{
            assert.equal(await config.erc20Coupon.balanceOf.call(config.distributorA), 0, 
                        "Minter has balance before call mint()");
            try{
                await config.erc20Coupon.mint(100, {from:config.adminA});
            }catch(err){
                assert.fail(`Error on minting token by token: ${err.message}`);
            }

            assert.equal(await config.erc20Coupon.balanceOf.call(config.distributorA), 100, 
                        "Incorrect balance after call mint()");
        });

        it(`5) restrict hacker to mint token`, async()=>{
            let allowAdd = true;
            try{
                await config.erc20Coupon.mint(10, {from:confirm.hacker});
            }catch(err){
                allowAdd = false;
            }

            assert.equal(allowAdd, false, "Could not restrict hacker to mint token");
        });
    });

    describe(`test transfer tokens`, function(){
        it(`6) allows distributor to tranfer tokens to consumer`, async()=>{           
            assert.equal(await config.erc20Coupon.hasCouponOwner.call(config.consumer01), false, 
                        "Consumer has been coupon-owner before transfer token");
            try{
                await config.erc20Coupon.transfer(config.consumer01, 1, {from:config.distributorA});
            }catch(err){
                assert.fail(`Error on transfer token to consumer from distributer: ${err.message}`);
            }
            
            assert.equal(await config.erc20Coupon.hasCouponOwner.call(config.consumer01), true, 
                        "Consumer is not coupon-owner after transfer token");

            assert.equal(await config.erc20Coupon.balanceOf.call(config.consumer01), 1,
                        "Incorrect token balance of consumer");
        });

        it(`7) allows administrator to transfer token to consumer for distributor`, async()=>{
            try{
                await config.erc20Coupon
                                .transferFrom(
                                    config.distributorA, 
                                    config.consumer01, 1, 
                                    {from:config.adminA}
                                );
            }catch(err){
                assert.fail(`Error on transfer token to consumer from distributer by admin: ${err.message}`);
            }

            assert.equal(await config.erc20Coupon.balanceOf.call(config.consumer01), 2,
                        "Incorrect token balance of consumer");
        });

        it(`8) allows administrator to transfer token to distributor from consumer`, async()=>{
            try{
                await config.erc20Coupon
                                .transferFrom(
                                    config.consumer01, 
                                    config.distributorA, 2, 
                                    {from:config.adminA}
                                );
            }catch(err){
                assert.fail(`Error on transfer token to distributor from consumer by admin: ${err.message}`);
            }

            assert.equal(await config.erc20Coupon.balanceOf.call(config.consumer01), 0,
                        "Incorrect token balance of consumer");

            assert.equal(await config.erc20Coupon.balanceOf.call(config.distributorA), 100,
                        "Incorrect token balance of consumer");
        });

        it(`9) restrict hacker to transfer tokens to himself`, async()=>{
            let allowTransfer = true;
            try{
                await config.erc20Coupon
                                .transferFrom(
                                    config.distributorA, 
                                    config.hacker, 20, 
                                    {from:config.hacker}
                                );
            }catch(err){
                console.log(err.message);
                allowTransfer = false;
            }

            assert.equal(allowTransfer, false, "Hacker could transfer tokens to hacker");

            assert.equal(await config.erc20Coupon.balanceOf.call(config.distributorA), 100,
                        "Incorrect token balance of consumer");
        });

        it(`10) restrict transfer tokens exceeding balance`, async()=>{
            let allowTransfer = true;
            try{
                await config.erc20Coupon
                                .transferFrom(
                                    config.distributorA, 
                                    config.consumer01, 120, 
                                    {from:config.adminA}
                                );
            }catch(err){
                console.log(err.message);
                allowTransfer = false;
            }

            assert.equal(allowTransfer, false, "Could transfer tokens more than balance");
        });
    });

    describe(`Test operationable part`, function(){
        it(`11) could shift operationable status correctly`, async()=>{
            // only admin could set operationable
            let setAble = true;
            try{
                await config.erc20Coupon.setUnoperationable({from:config.hacker});
            }catch(err){
                console.log(err.message);
                setAble = false;
            }
            assert.equal(setAble, false, "not administrator could set operationable");
            
            // could set operationable correctly
            try{
                await config.erc20Coupon.setUnoperationable({from:config.owner});
            }catch(err){
                assert.fail(`Admin could not set unoperationable:${err.message}`);
            }
            assert.equal(await config.erc20Coupon.isOperationable.call(), false, 
                        "coupon is still operationable aftersetUnoperationable()");

            // restrict mint, transfer, transferFrom after unoperationable
            let canMint = true;
            try{
                await config.erc20Coupon.mint(100, {from:config.adminA});
            }catch(err){
                //assert.fail(`Admin could mint when coupon is unoperationable:${err.message}`);
                canMint = false;
            }
            assert.equal(canMint, false, `Admin could mint when coupon is unoperationable`);

            let canTransfer = true;
            try{
                await config.erc20Coupon.transfer(config.consumer01, 1, {from:config.distributorA});
            }catch(err){
                //assert.fail(`Admin could mint when coupon is unoperationable:${err.message}`);
                canTransfer = false;
            }
            assert.equal(canTransfer, false, `Distributor could transfer when coupon is unoperationable`);

            // allow mint, transfer, transferFrom after operationable
            try{
                await config.erc20Coupon.setOperationable({from:config.owner});
            }catch(err){
                assert.fail(`Admin could not set operationable:${err.message}`);
            }
            assert.equal(await config.erc20Coupon.isOperationable.call(), true, 
                        "coupon is not operationable after setOperationable()");

            canMint = true;
            try{
                await config.erc20Coupon.mint(100, {from:config.adminA});
            }catch(err){
                //assert.fail(`Admin could mint when coupon is unoperationable:${err.message}`);
                canMint = false;
            }
            assert.equal(canMint, true, `Admin could not mint when coupon is back to operationable`);

            canTransfer = true;
            try{
                await config.erc20Coupon.transfer(config.consumer01, 1, {from:config.distributorA});
            }catch(err){
                //assert.fail(`Admin could mint when coupon is unoperationable:${err.message}`);
                canTransfer = false;
            }
            assert.equal(canTransfer, true, `Distributor could not transfer when coupon is back to operationable`);
        });
    });
});