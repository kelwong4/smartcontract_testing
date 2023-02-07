const { run } = require("hardhat")

//verify
//async function verify(contractAddress, args) {
const verify = async (contractAddress, args) => {
    //by doing this, the function become a variable
    console.log("Verifying contract...")
    try {
        await run("verify:verify", {
            address: contractAddress,
            constructorArguments: args,
        })
    } catch (e) {
        if (e.message.toLowerCase().includes("already verified")) {
            console.log("Already Verified!")
        } else {
            console.log(e)
        }
    }
}
module.exports = { verify }
