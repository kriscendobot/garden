---
title: Crank
source: packages/zoe/README.md
source_repo: agoric/agoric-sdk
source_commit: 940d3f0a993ca45a6bb0893bd59e6df1f22d9143
source_date: 2024-07-03
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
topics: [exo, bundles, capability-security, persistence]
status: current
notes: The upgrade-contract flow is structurally similar to SwingSet's vat-upgrade flow (per the doc's link to `packages/SwingSet/docs/vat-upgrade.md`). The single-crank rule for `prepare` in later incarnations is a SwingSet-kernel correctness invariant: it allows the kernel to deliver queued inbound messages safely without having to distinguish "needed for upgrade" from "new work". Cross-cuts with bundles (the new source code is identified by a bundleID), exo (the contract uses prepareExo / prepareExoClass for its remotables), and the "null upgrade" pattern (re-use the same bundle to clear accumulated state) is a legitimate use.
parent: agoric-sdk--pkg-zoe-readme--upgrade
---

For the first incarnation, `prepare` is allowed to return a promise that takes more than one crank to settle
(e.g., because it depends upon the results of remote calls).
But in later incarnations, `prepare` must settle in one crank.
Therefore such necessary values should be stashed in the baggage by earlier incarnations.
The `provideAll` function in contract support is designed to support this.

The reason is that all vats must be able to finish their upgrade without
contacting other vats. There might be messages queued inbound to the vat being
upgraded, and the kernel safely deliver those messages until the upgrade is
complete. The kernel can't tell which external messages are needed for upgrade,
vs which are new work that need to be delayed until upgrade is finished, so the
rule is that buildRootObject() must be standalone.

Source: [packages/zoe/README.md](https://github.com/Agoric/agoric-sdk/blob/940d3f0a993ca45a6bb0893bd59e6df1f22d9143/packages/zoe/README.md) at commit `940d3f0a`.
