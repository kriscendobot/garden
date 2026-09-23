---
source: notes/privacy.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 4
status: current
---

> Abstract: The DialogDB privacy RFC — how the system delivers full infrastructure privacy plus tiered, delegable, selective access. Four sections: the four monotone access levels (L0 no-access opaque blobs, L1 blob-connectivity structure, L2 key-range tree structure, L3 group-scoped fact decryption); the UCAN authorization model (in-tree delegation tokens, owner-issued and re-delegatable with equal-or-more-restrictive scope, verifiable without a central authority); the nested-layer encryption implementation (L1-outer wraps L2-middle wraps L3-inner, hierarchical root-derived per-level and per-group keys, rotation without full-tree rebuild); and the user-chosen privacy-efficiency tradeoff spectrum with private-cloud-sync and group-collaboration use cases. The privacy-tier face of the same UCAN delegation the capability-system sketch uses for effects.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [tiered-access-levels](../sections/dialog-db--notes-privacy--tiered-access-levels.md) | ucan-authorization | current |
| [ucan-authorization-model](../sections/dialog-db--notes-privacy--ucan-authorization-model.md) | ucan-authorization, capability-security | current |
| [tiered-encryption-implementation](../sections/dialog-db--notes-privacy--tiered-encryption-implementation.md) | ucan-authorization | current |
| [privacy-efficiency-tradeoffs](../sections/dialog-db--notes-privacy--privacy-efficiency-tradeoffs.md) | ucan-authorization, local-first-sync | current |

## Provenance

- Repository default branch `main`, file at HEAD `f777fe7c` (2026-07-05), authored by Irakli Gozalishvili.
- An RFC (design, not fully implemented); its "next steps" name UCAN integration, key management, and multi-layer-encryption reference implementations as future work. The related `notes/scope-and-delegation.md` and `notes/space-and-storage.md` are deferred to a follow-on `scholar-ingest-dialog-db` job.
