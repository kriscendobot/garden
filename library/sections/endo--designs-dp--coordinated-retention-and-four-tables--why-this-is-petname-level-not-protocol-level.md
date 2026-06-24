---
title: Why this is petname-level, not protocol-level
source: designs/daemon-persistence.md
source_repo: endojs/endo
source_branch: kriskowal-doc-formula-persistence
source_commit: aefc1b87da0cebd09184668effa264fe25e1c0b5
source_date: 2026-03-08
source_authors: [Kris Kowal]
source_pr: endojs/endo#3121
source_pr_state: draft
topics: [daemon, persistence, capability-security, ocapn]
status: current
notes: This is the **petname-side** companion to the cross-peer retention protocol described in [[endo-but-for-bots--llm-designs-dcpg--retention-set-model]]. The DCPG design covers the *wire protocol* for retention propagation; this section covers the *user-facing data model* (mirrored retention roots with local agency) that the wire protocol serves.
parent: endo--designs-dp--coordinated-retention-and-four-tables
---

The wire protocol for retention deltas
([[endo-but-for-bots--llm-designs-dcpg--wire-and-batching]]) carries
formula-number-level adds and removes. This design names the
*purpose* those deltas serve: keeping each peer's mirror table of "what
the *other* side currently retains of me" in sync.

The user interface affordance — *petnames* — is the layer the user
operates on. The protocol-level retention set is the *transport* for
keeping that affordance honest across partition.
