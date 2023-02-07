// SPDX-License-Identifier: MIT
//1.)pragma
pragma solidity ^0.8.7;

//GetFunds from users
//Withdraw funds
//Set a minimum funding value in USD

//2.)Imports
import "./PriceConverter1.sol";

//3.)Error codes
error FundMe__NotOwner();

//4.)Interfaces, Libraries, Contracts

/**@title A contract for crowd funding
 * @author Kelvin Wong
 * @notice This contract is to demo a sample funding contracts
 * @dev This implements price feeds as our library
 */
contract FundMe {
    //A.)Type declaration

    //make it public bcoz we want everybody can call this function
    //Want to be able to set a minimum fund amount in USD
    //1. How do we send ETH to this contract
    //keyword "payable" makes the button to red color

    //B.)State Variables
    using PriceConverter1 for uint256;

    uint256 public minimumUsd = 50 * 1e18; //1 * 10 ** 18

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public owner;

    AggregatorV3Interface public priceFeed;

    //C.) Event, Modifier
    modifier onlyOwner() {
        //require(msg.sender == owner, "Sender is not the owner!"); // == means checking two variables are equivilant
        if (msg.sender != owner) revert FundMe__NotOwner();
        _; //_; means process the rest of code
    }

    //D.)Functions

    //Function order: Constructor, receive, fallback, external, public, internal, private, view/pure

    constructor(address priceFeedAddress) {
        owner = msg.sender; //where msg.sender is whomever deployed the contract
        priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    // receive() external payable {
    //     fund();
    // }

    // fallback() external payable {
    //     fund();
    // }

    /**
     * @notice This contract funds this contract
     * @dev This implements price feeds as our library
     */

    function fund() public payable {
        //"require" set minimum of price
        //If first section below is false, then revert the error message followed by
        //revert means undo any action before, and send remaining gas back
        //number = 8;
        //require(msg.value > 1e18, "Didn't send enough!"); //1e18 == 1 * 10 ** 18 == 1000000000000000000 == 1ETH
        require(
            msg.value.getConversionRate(priceFeed) >= minimumUsd,
            "Didn't send enough!"
        ); //1e18 == 1 * 10 ** 18 == 1000000000000000000 == 1ETH 18 decimals
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

    function withdraw() public onlyOwner {
        //user modifier to make sure the ownership is checked before reading the content of the function
        //require(msg.sender == owner, "Sender is not the owner!"); // == means checking two variables are equivilant
        //for loop
        //[1,2,3,4]
        //0. 1. 2. 3. looping turn
        /*starting index, ending index, step amount */
        //e.g. 0, 10, 2 that means 0 2 4 6 8 10
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        //reset the array
        funders = new address[](0); //reset to 0 as a brand new array
        //actually withdraw the funds

        //transfer

        //msg.sender = address
        //payable(msg.sender) = payable address
        //payable (msg.sender).transfer(address(this).balance);  //keyword "this" means this whole contract

        //send
        //bool sendSuccess = payble(msg.sender).send(address(this).balance);
        //require(sendSuccess, "Send failed");

        //call
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }(""); //can call other contracts' function
        require(callSuccess, "Call failed");
    }
}
