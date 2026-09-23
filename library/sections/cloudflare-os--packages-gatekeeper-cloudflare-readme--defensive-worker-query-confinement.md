---
title: Defensive Worker query confinement
source: packages/gatekeeper-cloudflare/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 1931a1b175d52ed88109d880b90e23d130cca2ad
source_date: 2026-08-18
source_authors: [Nathan Disidore]
ingested: 2026-08-24
ingested_by: scholar
topics: [worker-observability, capability-mediated-integrations, capability-security]
status: current
---

Worker-scoped telemetry queries enforce confinement twice because provider acceptance of a filter is not proof that the provider applied it.

The Gatekeeper prepends an immutable service filter and then re-filters returned events. One foreign event proves that scoping failed, so the account-wide result count is withheld and an error is recorded, while safe filtered events and query-cost statistics remain available. Aggregates cannot be unmixed after the fact and therefore still depend on the injected provider filter. Grouping by service could recover a scoped aggregate, but would alter caller-visible limit and ordering semantics.

Source: [packages/gatekeeper-cloudflare/README.md](https://github.com/cloudflare/cloudflare-os/blob/1931a1b175d52ed88109d880b90e23d130cca2ad/packages/gatekeeper-cloudflare/README.md) at commit `1931a1b1`.
