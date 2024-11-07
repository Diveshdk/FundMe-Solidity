//Get Funds from Users
// Withdraw Funds
//set a minimum funding value in usd

//SPDX-License-Identifier: MIT
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";


pragma solidity >=0.8.18;

error NotOwner();
contract FundMe{
    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD = 5e18;

    address[] public funders;
    mapping(address => uint256 amountFunded) public addressToAmountFunded;

    address public immutable i_owner;

    constructor(){
         i_owner = msg.sender;
    }


    function fund() public payable {
        require(msg.value.getConversionRate() > MINIMUM_USD, "DIDNT SENT ENOUGH ETH");//value of 1ETH //msg.value is first parameter
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] == addressToAmountFunded[msg.sender] + msg.value;
    }
    
 function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
        // // transfer
        // payable(msg.sender).transfer(address(this).balance);

        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");

        // call
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    modifier onlyOwner(){
        // require(msg.sender== i_owner, "Sender is not the owner");
                if (msg.sender != i_owner) revert NotOwner();

        _;//phle upar waala codde run krega then rest of the code.. underline ka ye matlab hai
    }

        fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }
}