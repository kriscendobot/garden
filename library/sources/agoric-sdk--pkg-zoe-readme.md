---
source: packages/zoe/README.md
source_repo: agoric/agoric-sdk
source_commit: 940d3f0a993ca45a6bb0893bd59e6df1f22d9143
source_date: 2024-07-03
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
section_count: 4
status: current
notes: Zoe is agoric-sdk's smart-contract framework — the canonical "users get what they wanted or a full refund" property is the framework's defining invariant. The Upgrade section is the longest and most consequential (the bundle-and-baggage migration model, the `prepare` function contract, durability/kinds/crank rules). Cross-cuts with bundles, capability-security, exo, patterns. The Upgrade discussion of multi-crank `prepare` mirrors the kernel-level vat-upgrade rules in SwingSet.
---

> Abstract: Zoe is the smart-contract framework on the Agoric platform — itself a smart contract written in JavaScript. The README has four sections: (1) frame, (2) "What is Zoe?" with the core safety property (users get what they want or a full refund regardless of contract correctness; the contract never has access to user assets), (3) "Reading data off-chain" via StoredPublishKit + `agoric follow`, (4) "Upgrade" — the longest and most technical section, documenting the `prepare` function contract, durability requirements, kinds-must-be-defined-first invariant, and the single-crank rule for `prepare` in later incarnations. AGENTS.md names zoe as primary code; `agoric-sdk--readme--edit-loop` calls out the Zoe "contract facet bundle" gotcha.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/agoric-sdk--pkg-zoe-readme--overview.md) | exo, capability-security | current |
| [what-is-zoe](../sections/agoric-sdk--pkg-zoe-readme--what-is-zoe.md) | capability-security, getting-started | current |
| [reading-data-off-chain](../sections/agoric-sdk--pkg-zoe-readme--reading-data-off-chain.md) | tooling | current |
| [upgrade](../sections/agoric-sdk--pkg-zoe-readme--upgrade.md) | exo, bundles, capability-security | current |

## Source

[packages/zoe/README.md](https://github.com/Agoric/agoric-sdk/blob/940d3f0a993ca45a6bb0893bd59e6df1f22d9143/packages/zoe/README.md) at commit `940d3f0a`.
