# 📜 License Smart Contract

## 📌 Overview

This project implements a simple smart contract for software license sales using Solidity.

The contract simulates:
- license purchase with ETH
- usage confirmation
- refund request and approval
- automatic fund release after a fixed time period

---

## ⚙️ Process Flow

1. Contract is deployed by the seller with a fixed price
2. Buyer purchases a license by sending ETH
3. Buyer confirms usage of the software
4. Buyer can request a refund (optional)
5. Seller approves or rejects the refund
6. After 7 days, funds are released:
   - to buyer (if refund approved)
   - otherwise to seller

---

## ✨ Features

- ETH payment handling
- Escrow mechanism
- Refund request system
- Time-based finalization
- State machine logic
- Event logging

---

## 🧠 Main Functions

- `buyLicense()` – purchase license
- `confirmUsage()` – confirm usage
- `requestRefund()` – request refund
- `approveRefund()` / `rejectRefund()` – seller decision
- `finalize()` – release funds

---

## 🛠️ Tech Stack

- Solidity (^0.8.0)
- Remix IDE
- Ethereum Virtual Machine (Remix VM)

---

## 🚀 Usage

1. Open Remix IDE
2. Create `LicenseContract.sol`
3. Compile contract
4. Deploy with price:
   100000000000000000 (0.1 ETH in wei)
5. Interact via UI

---

## 📄 Notes

- One buyer per contract
- Usage is manually confirmed
- No external integrations (email, keys, etc.)