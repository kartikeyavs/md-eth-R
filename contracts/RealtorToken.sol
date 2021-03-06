pragma solidity ^0.4.2;

import 'zeppelin-solidity/contracts/token/ERC20/StandardToken.sol';
import './Authentication.sol';

contract RealtorToken is StandardToken, Authentication {
    string public name = "RealtorToken";
    string public symbol = "RT";
    uint8 public decimals = 18;
    struct Property {
        address owner;
        uint256 price;
        // Valid state numbers are:
        // 0: Off market
        // 1: On market
        // 2: Pending
        uint8 state;
    }
    // First param is the property id and second one is the property details
    mapping (string => Property) private properties;

    uint256 public constant INITIAL_SUPPLY = 1000000;

    event PropertyUpdated(string propertyId, address owner);

    modifier onlyOffMarket(string propertyId) {
        // Only properties in Off market state.
        require(properties[propertyId].state == 0);
        _;
    }

    modifier onlyOnMarket(string propertyId) {
        // Only properties in On market state.
        require(properties[propertyId].state == 1);
        _;
    }

    modifier onlyPending(string propertyId) {
        // Only properties in On market state.
        require(properties[propertyId].state == 2);
        _;
    }

    function RealtorToken() public {
        // First user is the contract creator.
        signup("First user");
        totalSupply_ = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;

        Transfer(0x0, msg.sender, INITIAL_SUPPLY);
    }

    function registerProperty(string propertyId, uint256 propertyPrice) public {
        // TODO: Verify the user exists in the database.
        // TODO: Verify the property is not registered already.
        properties[propertyId].owner = msg.sender;
        properties[propertyId].price = propertyPrice;
        properties[propertyId].state = 0;
        PropertyUpdated(propertyId, msg.sender);
    }

    function publish(string propertyId) public onlyOffMarket(propertyId){
        properties[propertyId].state = 1;
        PropertyUpdated(propertyId, msg.sender);
    }

    function unpublish(string propertyId) public onlyOnMarket(propertyId){
        properties[propertyId].state = 0;
        PropertyUpdated(propertyId, msg.sender);
    }
}