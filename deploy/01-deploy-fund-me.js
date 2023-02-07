//import
//main function
//calling of main function

// function deployFunc(hre) {
//     console.log("Hi!")
// console.log("Hi")
// hre.getNamedAccounts()
// hre.deployments

// }

// module.exports.default = deployFunc

//module.exports async (hre) => {  //same as the above function
//const {getNamedAccounts, deployments} = hre
//hre.getNamedAccounts
//hre.deployments

const { networkConfig, developmentChains } = require("../helper-hardhat-config")
//same as... const helperConfig = require("../helper-hardhat-config")
// const networkConfig = helperConfig.networkConfig
const { network } = require("hardhat")
const { verify } = require("../utils/verify")

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId

    const address = ""

    //if chainId is X, use address Y
    //if chainId is Z, use address A

    //const ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]

    let ethUsdPriceFeedAddress
    if (developmentChains.includes(network.name)) {
        const ethUsdAggregator = await deployments.get("MockV3Aggregator")
        ethUsdPriceFeedAddress = ethUsdAggregator.address
    } else {
        ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]
    }

    //if the contract doesn't exist, we deploy a minimal version of it for local testing

    //when going for lcoalhost or hardhat network, we want to use a mock
    //what happen if we want to change chain?
    //0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
    const args = [ethUsdPriceFeedAddress]
    const fundMe = await deploy("FundMe", {
        from: deployer,
        args: args, //put priceFeedAddress here
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    })

    if (
        !developmentChains.includes(network.name) &&
        process.env.ETHERSCAN_API_KEY
    ) {
        await verify(fundMe.address, args)
    }

    log("------------------------------------------------")
}
module.exports.tags = ["all", "fundme"]
