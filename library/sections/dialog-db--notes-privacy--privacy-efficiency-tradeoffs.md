---
title: Privacy-efficiency tradeoffs and use cases
source: notes/privacy.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [ucan-authorization, local-first-sync]
status: current
---

> Abstract: A core principle is that **users choose their own privacy-efficiency tradeoff**. Delegating more structural access (L1/L2) to trusted services buys efficiency (server-assisted sync, structural validation, selective subtree replication) at the cost of exposing more metadata; keeping everything at L0 maximizes privacy at the cost of that assistance. The spectrum runs Maximum Privacy (L0 only) → High Privacy (limited L1) → Balanced (selective L2) → Efficiency-Focused (broad L2 and L3), and different policies can apply to different subtrees ("regions"). Two worked use cases: **private cloud sync** (an L1 sync service ferries connected encrypted nodes without seeing content) and **collaborative editing with group access** (an L2 validator checks tree structure while Bob and Charlie decrypt only their respective groups' facts).

Users can configure their database to operate anywhere on a privacy-efficiency spectrum:

- **Maximum Privacy**: everything fully encrypted, limited delegation (L0 access only).
- **High Privacy**: limited L1.
- **Balanced**: strategic delegation of L1/L2 access to trusted services; selective L2.
- **Efficiency-Focused**: broad L2 and L3 sharing with appropriate access controls.
- **Different regions**: apply different policies to different subtrees.

The tradeoff is explicit and local: more delegated structural access means more efficiency (help with sync, structural validation, selective replication) but more exposed metadata; the user picks the point, per region.

**Use case — private cloud sync**: the user stores encrypted nodes in an L0 blob store and asks an L1 sync service to sync; the service fetches the connected nodes from the blob store and sends the user's missing nodes back, all without seeing content, and the user verifies and decrypts locally.

**Use case — collaborative editing with group access**: Alice creates facts for Groups A and B, shares the Group A key with Bob and the Group B key with Charlie, and delegates L2 access to a Validator. Bob and Charlie each push changes; the validator verifies tree structure (without reading facts); each collaborator queries and decrypts only their own group's facts.

Next steps named by the RFC: implement UCAN integration, develop key-management protocols, create reference implementations of multi-layer encryption, design UIs for managing access levels and delegations, and benchmark across privacy configurations.

Source: [notes/privacy.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/privacy.md) at commit `f777fe7c`.
