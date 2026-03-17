# 📜 License Smart Contract

## 📌 Overview

This project implements a **smart contract for software license sales** using **Solidity** on the Ethereum blockchain.

The contract automates the process of:
- purchasing a software license
- tracking usage
- handling refund requests
- releasing funds based on predefined conditions

---

## ⚙️ How It Works

The smart contract follows a simple business process:

1. **Contract Deployment**
   - The seller deploys the contract and sets the license price.

2. **License Purchase**
   - A buyer sends ETH to the contract.
   - Funds are locked in the contract (escrow).

3. **Usage Confirmation**
   - The buyer confirms that the software has been used.

4. **Refund Request (Optional)**
   - The buyer can request a refund.
   - The seller approves or rejects the request.

5. **Finalization**
   - After a fixed time period (7 days):
     - If refund is approved → funds go to the buyer
     - Otherwise → funds go to the seller

---

## ✨ Features

- 💰 Secure ETH payment handling
- 🔒 Escrow mechanism (funds locked in contract)
- 🔁 Refund request system
- ⏱ Time-based finalization (7 days)
- 📊 State machine-based workflow
- 📢 Event logging for key actions

---

## 🧠 Smart Contract Structure

The contract includes:

- **State Machine**
  ```solidity
  enum State { Created, Paid, Active, RefundRequested, Completed }