---
title: Abstract
source: "Capability-Based Financial Instruments (Financial Cryptography 2000, Springer LNCS 1962)"
source_kind: paper
source_authors: [Mark S. Miller, Chip Morningstar, Bill Frantz]
source_year: 2000
source_venue: "Financial Cryptography 2000, Springer LNCS 1962"
source_url: https://papers.agoric.com/papers/capability-based-financial-instruments/abstract/
source_pdf_sha256: 49c7606bbf78f3cd5e4565802dcaf2e87254ed9ab02ed955dd6963053fecfb8e
source_paper_pages: "1-15 (§1 Overview + §1.1 Introduction + §1.2 Six Perspectives; §2 From Functions To Objects; §3 From Objects to Capabilities, §3.1-§3.3 including Rights Amplification)"
ingested: 2026-05-28
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, patterns]
status: current
parent: papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--granovetter-six-perspectives-and-object-capability-model
---

The paper opens with a claim about the *cooperation problem* in electronic commerce: every novel cooperative arrangement of mutually-suspicious parties — every smart contract — would seem to require its own cryptographic protocol. Protocol design is hard and expensive, so under this requirement cryptographically-enabled commerce stays unreachable. The paper's response is to find **a common abstraction** across three communities — the object-programming community, the capability-based secure-operating-systems community, and the financial-cryptography community — that lets contracts be built compositionally rather than designed individually. The abstraction is the **Granovetter Operator**: the three-object reference-passing primitive named after sociologist Mark Granovetter's diagrams of how interpersonal-knowledge topologies evolve when people introduce people they know to each other. Alice holds references to Bob and Carol; Alice sends Bob a message `bob.foo(carol)` containing a copy of her reference to Carol; from this single step *six independent disciplines simultaneously make sense of what just happened*: Object Computation (the basic message-send), Capability Security (the only way Bob can come to know about Carol if he didn't already), Cryptographic Protocol (Pluribus enacts the same step across mutually-suspicious machines), Public-Key Infrastructure (the message arrow is a certificate of authorization), Game-Rule (the move that changes which moves are subsequently available to whom), and Financial Bearer Instrument (the secure transfer of an electronic right). §2 derives the object-capability model from lambda + message-dispatch + local-side-effects; §3 enumerates the three connectivity-acquisition mechanisms (Introduction / Parenthood / Construction) that make object computation into *capability* computation. §3.3 introduces **rights amplification** via **sealer/unsealer pairs** (`BrandMaker pair("MarkM")`) — the primitive E provides for combining two references to obtain authority that neither held alone (the can/can-opener analogy), and the substrate the §3.4 mint/purse money example will build on.
