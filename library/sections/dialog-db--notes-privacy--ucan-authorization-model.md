---
title: UCAN authorization model
source: notes/privacy.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [ucan-authorization, capability-security]
status: current
---

> Abstract: DialogDB grants the tiered access levels through **UCANs** (User Controlled Authorization Networks): capability-based "bearer tokens" that encode specific capabilities, delegable from users to services or other users, cryptographically verifiable via proofs, and storable **in-tree** (delegation tokens live within the tree structure itself, so a parent node can carry delegations for its children). The owner issues capabilities scoped to specific access levels and subtrees; delegates may re-delegate with equal-or-more-restrictive permissions; access is verified without a central authority. This is the same delegation model as Dialog's `capability-sysstem.md` sketch, applied to the L0–L3 privacy tiers: Alice delegates L1 to a sync service, L2 to a validator, and L3 (optionally group-scoped) to individual collaborators.

DialogDB supports capability-based authorization through UCANs (User Controlled Authorization Networks):

- **Capability-based**: authorization uses "bearer tokens" that encode specific capabilities.
- **Delegation chain**: capabilities can be delegated from users to services or other users.
- **Proofs**: authorization can be cryptographically verified.
- **In-tree storage**: delegation tokens can be stored within the tree structure itself.
- **Parent-child authorization**: parent nodes can contain delegations for their children.

UCANs enable an authorization model where:

1. The owner of a database can issue capabilities to others.
2. Those capabilities can be precisely scoped to specific access levels and subtrees.
3. Capabilities can be delegated further with equal or more restrictive permissions.
4. Access can be verified without a central authority.

Worked delegation topology: Alice (data owner) delegates L1 access to a Sync Service, L2 access to a Validation Service, L3 access to Bob (collaborator), and L3-Group-A-only access to Charlie (limited collaborator). Each grant is a UCAN delegation scoped to a level (and, for L3, to a group).

This is the privacy-side face of the `capability-sysstem.md` design: the same `subject x command x policy` UCAN delegation that the capability sketch uses to scope Archive/Memory effects here scopes the L0–L3 encryption tiers and per-group visibility. Endo readers will recognize the pattern — attenuated delegation of an unforgeable authority — as ocap delegation; UCAN is the serialized, offline-verifiable token form of it.

Source: [notes/privacy.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/privacy.md) at commit `f777fe7c`.
