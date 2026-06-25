---
title: Membership MVP Roadmap
source: doc/design/membership-next-steps.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-25
ingested_by: scholar
topics: [networking, capability-security]
status: current
---

> Abstract: The staged plan for getting the membership gate working: only peers whose `node_id` is in the membership set may establish a session (`ini6`); unknown peers are rejected. Identity is the stable 32-byte `node_id` from ROOT_DESIGN/CRYPTOGRAPHY; because a bare `ini6` that merely *sends* a node_id lets anyone impersonate anyone, the plan offers Option A (trust the wire on a controlled network, add proof later) and the stronger Option B (membership stores public keys, the client signs a nonce/session_id, the server verifies then checks membership). Bootstrap reads a `CASK_ROOT` env identity (the controlling root user, the only member until it adds others, named to evoke the Unix root user but distinct from the store tip). Membership can live in an extended caskhead link, a system cell, or — the recommended MVP — a `CASK_MEMBERSHIP` file/env of hex node_ids loaded at startup. `ini6` gains a 32-byte `node_id` field and a new `statusNotMember` (e.g. 3) status so clients distinguish "not allowed" from auth failure. Persistence in CASK (caskset or the Rabin-chunked sorted array) and cryptographic proof are explicitly deferred.

## Immediate Next Step: Membership

**Goal:** Only peers whose identity is in the **membership** set may establish a session (`ini6`). Unknown peers are rejected.

**What we need:** a membership structure (set or sorted set of allowed identities), an identity for the connecting peer (so we can check membership), and a gate in `ini6` (before creating a session, the server checks membership; if not a member, respond with a "not a member" status and do not create a session).

## Identity: node_id

From ROOT_DESIGN and CRYPTOGRAPHY: each peer has a stable **node_id** (32 bytes, random, long-lived). Membership is keyed by node_id, so membership is the set of node_ids allowed to establish a session, and `ini6` must carry or prove the client's node_id so the server can look it up.

**Problem:** If `ini6` only *sends* a node_id, anyone can claim to be any node_id. So we need one of:

- **Option A (minimal):** Trust the wire for now (e.g. in a controlled network). `ini6` includes node_id; server checks membership. Add cryptographic proof later.
- **Option B (better):** Client proves they know the secret for that node_id. For example: membership stores `(node_id, ed25519_public_key)`; client signs `session_id` (or a nonce) with the private key; server verifies the signature and then checks the public key (or node_id) in membership. So "invited" = your public key / node_id is in membership and you prove possession.

For a first iteration, Option A gets the gate in place; Option B can follow as the next hardening step.

## Bootstrap: Root User (CASK_ROOT)

On first start, the server may read **CASK_ROOT** (env): the identity (node_id, 64 hex chars) of the **root user** — the controlling member who may establish a session and configure the node (e.g. populate membership, set schema). The name intentionally evokes "root user"; it is distinct from the store tip (see ROOT_DESIGN.md). If set at bootstrap, this identity is the only member until the root user adds others.

## Where Membership Lives

- **caskhead0** currently: schema_version, session_table. No membership.
- **Options:**
  - **1) Extend caskhead (e.g. caskhead1):** Add a `membership_root` link. Membership is a persistent structure (e.g. caskset of node_ids, or later the Rabin-chunked sorted array from ROOT_DESIGN). Bootstrap/upgrade creates it.
  - **2) Membership in a cell:** Root points at a "system" cell whose value is the membership root. Only trusted bootstrap code can mutate it. Same persistent structure, different pointer.
  - **3) MVP config:** Membership is a file or env (e.g. list of node_ids hex). Server loads at startup. No persistence in CASK yet; gets the gate working.

Recommendation: **MVP (3)** first (a `CASK_MEMBERSHIP` file or env with one node_id per line in hex; server loads it, `ini6` includes node_id, server checks the list), then **(1) or (2)** once a persistent membership structure (caskset or casksortedarray) exists.

## ini6 Changes

- **Add field:** a `node_id` (32 bytes) in the `ini6` packet (at a defined offset). Client sends their node_id.
- **Server:** on `ini6`, parse node_id, check membership. If not present → respond with a new status (e.g. `statusNotMember = 3`), do not create a session. If present → proceed as today (verify `auth_tag`, create session).

No change to `in6r` layout except possibly a new status value.

## Summary: Concrete Next Steps

| Step | Action |
|------|--------|
| 1 | **Define membership MVP** – e.g. "list of node_ids" (file or env). Document format. |
| 2 | **Add node_id to ini6** – Extend `ini6` packet with 32-byte node_id; document new layout. |
| 3 | **Implement membership check in server** – Load membership at startup (from file/env). In `handleINI6`, after parsing, check node_id in set; if not, return `statusNotMember` and abort. |
| 4 | **Add statusNotMember** – New `in6r` status (e.g. 3) so client can distinguish "not allowed" from auth failure. |
| 5 | **(Later)** Persist membership in CASK – e.g. caskhead1 with `membership_root` (caskset of node_ids), or membership in a cell. |
| 6 | **(Later)** Cryptographic proof of node_id – e.g. membership stores pubkeys; client signs; server verifies then checks membership. |
| 7 | **(Later)** Capability-gated read/write – Session gives transport only; each LOAD/STOR (or lode/stoe) requires a capability for the target cell (CELLS.md). |

Source: [doc/design/membership-next-steps.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/membership-next-steps.md) at commit `cdb975d8`.
