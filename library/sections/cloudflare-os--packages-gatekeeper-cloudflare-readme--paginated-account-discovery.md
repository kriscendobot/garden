---
title: Paginated account discovery
source: packages/gatekeeper-cloudflare/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 1931a1b175d52ed88109d880b90e23d130cca2ad
source_date: 2026-08-18
source_authors: [Nathan Disidore]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, worker-observability]
status: current
---

Cloudflare account discovery walks every page before applying the picker's substring match, avoiding silent omission after the provider's default first 20 accounts.

The documented server-side name filter does not specify exact versus substring semantics. Pushing the picker query down could therefore exchange visible pagination truncation for an invisible matching error. Exhaustive traversal followed by client-side matching preserves the user-facing selection contract.

Source: [packages/gatekeeper-cloudflare/README.md](https://github.com/cloudflare/cloudflare-os/blob/1931a1b175d52ed88109d880b90e23d130cca2ad/packages/gatekeeper-cloudflare/README.md) at commit `1931a1b1`.
