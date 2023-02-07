// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter1 {
    function getPrice(
        AggregatorV3Interface priceFeed
    )
        internal
        view
        returns (
            uint256 // ABI
        )
    // Address 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
    //AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e).version //call version function on the contract specified
    //AggregatorV3Interface priceFeed = AggregatorV3Interface(
    //    0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
    {
        (, int256 answer, , , ) = priceFeed.latestRoundData(); //return whole bunch of variable of the lastestRoundData function under AggregatorV3Interface
        //remove other variable to get only the price of ETH in terms of USD //3000.00000000
        return uint256(answer * 1e10); //1**10 == 10000000000
    }

    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        //3000_000000000000000000 = ETH/ USD price
        //1_000000000000000000 ETH
        uint ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}
