// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LicenseContract {

    // STATE MACHINE
    enum State { Created, Paid, Active, RefundRequested, Completed }
    State public state;

    // OSNOVNE PROMENLJIVE
    address public owner;
    address public buyer;
    uint public price;
    uint public purchaseTime;

    bool public used;
    bool public refundRequested;
    bool public refundApproved;

    // KONSTRUKTOR
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
    }

    function confirmUsage() public {
        require(state == State.Paid, "License not paid yet");
        require(msg.sender == buyer, "Only buyer can confirm usage");

        used = true;
        state = State.Active;
    }

    function requestRefund() public {
        require(state == State.Paid || state == State.Active, "Refund cannot be requested now");
        require(msg.sender == buyer, "Only buyer can request refund");
        require(!refundRequested, "Refund already requested");

        refundRequested = true;
        state = State.RefundRequested;
    }

    function approveRefund() public {
        require(msg.sender == owner, "Only owner can approve refund");
        require(refundRequested, "No refund requested");

        refundApproved = true;
    }

    function rejectRefund() public {
        require(msg.sender == owner, "Only owner can reject refund");
        require(refundRequested, "No refund requested");

        refundApproved = false;
    }

}