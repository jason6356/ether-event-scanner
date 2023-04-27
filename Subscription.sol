// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Subscription {

    address private owner;
    mapping (address => bool) public validContracts;
    mapping (address => address[]) public subscriptions;
    mapping (address => mapping(address => bool)) isSubscribed;
    mapping (address => Log[]) public contractEvents;
    
    struct Contract {
        address contractAddress;
    }

    struct Log {
        string eventName;
    }

    modifier validContract(address contractAddress){
        require(validContracts[contractAddress] == true, "The contract is not within the network or invalid contract address");
        _;
    }

    modifier onlyOwner (address user){
        require(user == owner, "The user is not the owner of the contract");
        _;
    }
    
    modifier notSubscribedYet(address user, address contractAddress){
        require(isSubscribed[user][contractAddress] == false, "The user has already subscribed to the contract");
        _;
    }

    constructor(){
        owner = msg.sender;
    }

    function changeOwner(address newOwnerAddress) public onlyOwner(msg.sender){
        owner = newOwnerAddress;
    }

    function subscribe(address contractAddress) public notSubscribedYet(msg.sender, contractAddress) validContract(contractAddress) payable{
       subscriptions[msg.sender].push(contractAddress);
       isSubscribed[msg.sender][contractAddress] = true;
    }

    function addContract(address contractAddress) public onlyOwner(msg.sender){
        validContracts[contractAddress] = true;
    }
    
    function updateContractEvent(address contractAddress, string memory eventName) public{
        contractEvents[contractAddress].push(Log(eventName));
    }


}