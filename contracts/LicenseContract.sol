// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LicenseContract {

    enum State { Created, Paid, Active, RefundRequested, Completed }
    State public state;

    address public owner;
    address public buyer;
    uint public price;
    uint public purchaseTime;

    bool public used;
    bool public refundRequested;
    bool public refundApproved;

    event LicensePurchased(address indexed buyer, uint amount, uint timestamp);
    event UsageConfirmed(address indexed buyer, uint timestamp);
    event RefundRequestedEvent(address indexed buyer, uint timestamp);
    event RefundApprovedEvent(address indexed owner, uint timestamp);
    event RefundRejectedEvent(address indexed owner, uint timestamp);
    event ContractFinalized(address indexed recipient, uint amount, uint timestamp);

    constructor(uint _price) {
        owner = msg.sender;
        price = _price;
        state = State.Created;
    }

    function buyLicense() public payable {
        require(state == State.Created, "License already purchased");
        require(msg.value == price, "Incorrect ETH amount");

        buyer = msg.sender;
        purchaseTime = block.timestamp;
        state = State.Paid;

        emit LicensePurchased(msg.sender, msg.value, block.timestamp);
    }

    function confirmUsage() public {
        require(state == State.Paid, "License not paid yet");
        require(msg.sender == buyer, "Only buyer can confirm usage");
        require(!refundRequested, "Refund already requested");

        used = true;
        state = State.Active;

        emit UsageConfirmed(msg.sender, block.timestamp);
    }

    function requestRefund() public {
        require(state == State.Paid || state == State.Active, "Refund cannot be requested now");
        require(msg.sender == buyer, "Only buyer can request refund");
        require(!refundRequested, "Refund already requested");

        refundRequested = true;
        state = State.RefundRequested;

        emit RefundRequestedEvent(msg.sender, block.timestamp);
    }

    function approveRefund() public {
        require(msg.sender == owner, "Only owner can approve refund");
        require(state == State.RefundRequested, "Refund is not in requested state");
        require(refundRequested, "No refund requested");
        require(!refundApproved, "Refund already approved");

        refundApproved = true;

        emit RefundApprovedEvent(msg.sender, block.timestamp);
    }

    function rejectRefund() public {
        require(msg.sender == owner, "Only owner can reject refund");
        require(state == State.RefundRequested, "Refund is not in requested state");
        require(refundRequested, "No refund requested");
        require(!refundApproved, "Refund already approved");

        emit RefundRejectedEvent(msg.sender, block.timestamp);
    }

    function finalize() public {
        require(state != State.Completed, "Contract already completed");
        require(buyer != address(0), "License not purchased yet");
        require(block.timestamp >= purchaseTime + 7 days, "Too early to finalize");

        state = State.Completed;

        if (refundRequested && refundApproved) {
            uint amount = address(this).balance;
            (bool success, ) = payable(buyer).call{value: amount}("");
            require(success, "Transfer to buyer failed");
            emit ContractFinalized(buyer, amount, block.timestamp);
        } else {
            uint amount = address(this).balance;
            (bool success, ) = payable(owner).call{value: amount}("");
            require(success, "Transfer to owner failed");
            emit ContractFinalized(owner, amount, block.timestamp);
        }
    }
}