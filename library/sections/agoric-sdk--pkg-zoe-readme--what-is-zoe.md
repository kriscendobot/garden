---
title: What is Zoe? (refund-or-fulfillment safety property)
source: packages/zoe/README.md
source_repo: agoric/agoric-sdk
source_commit: 940d3f0a993ca45a6bb0893bd59e6df1f22d9143
source_date: 2024-07-03
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
topics: [capability-security, getting-started]
status: current
notes: The "users get what they want OR a full refund" property is Zoe's defining invariant — the framework never lets a buggy or malicious contract access user assets directly. This is the canonical capability-security story for smart-contract platforms.
---

> Abstract: Zoe is a framework for building smart contracts (auctions, swaps, decentralized exchanges, …). Zoe is itself a smart contract written in JavaScript running on the Agoric platform. **Core safety property**: as a user, you either get what you wanted or get a full refund, even if the contract is buggy or malicious. (The contract never has direct access to user assets.) **For developers**: write contracts in plain JavaScript on a framework that ensures users can't lose assets due to code bugs.

## What is Zoe?

Zoe is a framework for building smart contracts like auctions, swaps,
decentralized exchanges, and more. Zoe itself is a smart contract
written in JavaScript and running on the Agoric platform.

_For users_: Zoe guarantees that as a user of a smart contract, you will
either get what you wanted or get a full refund, even if the smart
contract is buggy or malicious. (In fact, the smart contract never has
access to your digital assets.)

_For developers_: Zoe provides a safety net so you can focus on what
your smart contract does best, without worrying about your users
losing their assets due to a bug in the code that you wrote. Writing a
smart contract on Zoe is easy: all of the Zoe smart contracts are
written in the familiar language of JavaScript.

To learn more, please see the [Zoe guide](https://agoric.com/documentation/zoe/guide/).

Source: [packages/zoe/README.md](https://github.com/Agoric/agoric-sdk/blob/940d3f0a993ca45a6bb0893bd59e6df1f22d9143/packages/zoe/README.md) at commit `940d3f0a`.
