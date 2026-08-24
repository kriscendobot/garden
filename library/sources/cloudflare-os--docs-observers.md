---
source: docs/observers.md
source_repo: cloudflare/cloudflare-os
source_commit: c6e15a0399372833405c9826f1d8764c7ebd0d76
source_date: 2026-08-04
source_authors: [Dan Carter, Kenton Varda, Nathan Disidore, Phillip Jones]
ingested: 2026-08-24
ingested_by: scholar
section_count: 5
status: current
notes: Historical implementation plan; upstream warns that details may become outdated.
---

The historical observer-enforcement plan defines how shared gadgets verify every collaborator against previously-read external data and block future reads that would disclose data to an unauthorized observer.

| Section | Topics | Status |
|---------|--------|--------|
| [security invariant and observer model](../sections/cloudflare-os--docs-observers--security-invariant-and-observer-model.md) | collaborative-workspace-sharing, capability-mediated-integrations, capability-security | current |
| [observer records and verifiers](../sections/cloudflare-os--docs-observers--observer-records-and-verifiers.md) | collaborative-workspace-sharing, capability-mediated-integrations, capability-security | current |
| [configuration and re-verification on open](../sections/cloudflare-os--docs-observers--configuration-and-reverification-on-open.md) | collaborative-workspace-sharing, capability-mediated-integrations, capability-security | current |
| [forward exclusion and sharing-change teardown](../sections/cloudflare-os--docs-observers--forward-exclusion-and-sharing-change-teardown.md) | collaborative-workspace-sharing, capability-mediated-integrations, capability-security | current |
| [Gatekeeper observer strategies](../sections/cloudflare-os--docs-observers--gatekeeper-observer-strategies.md) | collaborative-workspace-sharing, capability-mediated-integrations, capability-security | current |
