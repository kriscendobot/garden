---
title: Observer records and verifiers
source: docs/observers.md
source_repo: cloudflare/cloudflare-os
source_commit: c6e15a0399372833405c9826f1d8764c7ebd0d76
source_date: 2026-08-04
source_authors: [Dan Carter, Kenton Varda, Nathan Disidore, Phillip Jones]
ingested: 2026-08-24
ingested_by: scholar
topics: [collaborative-workspace-sharing, capability-mediated-integrations, capability-security]
status: current
---

An observer record distinguishes authorization intent in the sharing table from completed, per-Gatekeeper verification and keeps vendor identity out of the overseer's stable observer handle.

The record is keyed by the collaborator's profile ID and holds a random opaque `observerId` plus the connected-account choice for each Gatekeeper. A reverse index maps excluded observer IDs back to profiles. The opaque identifier discourages Gatekeepers from parsing a profile or email; actual vendor identity arrives only through a `GatekeeperUserVerifier` minted by the collaborator's selected account.

For every authorized user and every Gatekeeper in scope, the intended invariant is that the Gatekeeper confirmed all historical observations at the user's last open and no later incompatible observation was allowed.

Source: [docs/observers.md](https://github.com/cloudflare/cloudflare-os/blob/c6e15a0399372833405c9826f1d8764c7ebd0d76/docs/observers.md) at commit `c6e15a03`.
