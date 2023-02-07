const { assert, expect } = require("chai")
const { deployments, ethers, getNamedAccounts } = require("hardhat")

describe("FundMe", function () {
    let fundMe
    let MockV3Aggregator
    let deployer
    const sendValue = ethers.utils.parseEther("1") // 1ETH
    beforeEach(async function () {
        //deploy FundMe contract
        //using Hardhat-deploy
        //const accounts = await ethers.getSigners()
        //const accountZero = accounts [0]
        deployer = (await getNamedAccounts()).deployer
        //const { deployer } = await getNamedAccounts()
        await deployments.fixture(["all"]) //deploy all contracts in local network inside deploy folder
        fundMe = await ethers.getContract("FundMe", deployer)
        MockV3Aggregator = await ethers.getContract(
            "MockV3Aggregator",
            deployer
        )
    })

    describe("constructor", function () {})
    it("set the aggregator address correctly", async function () {
        const response = await fundMe.priceFeed()
        assert.equal(response, MockV3Aggregator.address)
    })

    describe("fund", function () {
        it("fails if you don't send enough ETH", async function () {
            await expect(fundMe.fund()).to.be.revertedWith(
                "You need to spend more ETH!"
            )
        })
        it("updated the amound funded data structure"),
            async function () {
                await fundMe.fund({ value: sendValue })
                const response = await fundMe.addressToAmountFunded(deployer)
                assert.equal(response.toString(), sendValue.toString())
            }
    })
})
