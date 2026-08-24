---
title: Security invariant and observer model
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

Cloudflare OS treats every non-owner who can see gadget-read data as an observer and requires each relevant Gatekeeper to verify that observer against everything the gadget has historically read.

The mechanism replaces the all-or-nothing `prohibitAllSharing` stopgap. A prospective observer selects one of their own connected accounts for each in-scope Gatekeeper. That account mints an opaque verifier which only the matching vendor Gatekeeper interprets. The Gatekeeper's `addObserver()` must reject anyone unable to read the gadget's prior observations; later reads can name rejected observers through `excludeObservers`, causing the overseer to block the observation.

Verification breadth follows role: `build` collaborators cover every Gatekeeper, while `use` collaborators cover named bindings reachable from the gadget UI. Enforcement follows the authorization graph rather than live sessions because stored data can be displayed after the original read.

Source: [docs/observers.md](https://github.com/cloudflare/cloudflare-os/blob/c6e15a0399372833405c9826f1d8764c7ebd0d76/docs/observers.md) at commit `c6e15a03`.
