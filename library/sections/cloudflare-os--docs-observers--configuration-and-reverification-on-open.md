---
title: Configuration and re-verification on open
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

The gadget-open path invokes an optional callback only when a collaborator must choose connected accounts, then re-runs Gatekeeper verification on every subsequent open without reopening the modal.

`ObserverConfigCallback.configure()` receives binding needs and returns account choices. The overseer selects the role-appropriate Gatekeepers, auto-fills matching ambient singleton accounts, prompts only for uncovered bindings, and resolves each choice through the opening user's own User Durable Object. That server-side lookup checks the expected vendor before minting a verifier, so UI filtering is not the security boundary.

All `addObserver()` calls must succeed before the observer record is persisted. A failure triggers best-effort rollback for Gatekeepers added in the current pass and denies the open. Re-verification catches later revocation of underlying resource access, while Gatekeepers may cache their vendor-specific checks.

Source: [docs/observers.md](https://github.com/cloudflare/cloudflare-os/blob/c6e15a0399372833405c9826f1d8764c7ebd0d76/docs/observers.md) at commit `c6e15a03`.
