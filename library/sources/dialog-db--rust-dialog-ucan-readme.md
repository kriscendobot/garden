---
source: rust/dialog-ucan/README.md
source_repo: dialog-db/dialog-db
source_commit: a898b5de44a29e5be30a1faa99f11ef7a5332d69
source_date: 2026-06-04
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 1
status: current
---

> Abstract: The README for `dialog-ucan`, the UCAN authorization protocol crate for Dialog-DB. It bridges `dialog-capability`'s generic access protocol with `dialog-ucan-core`'s UCAN-spec implementation, defining how UCAN delegation chains prove and delegate access — the seam where dialog's typed capability chains become interoperable offline-verifiable UCAN tokens. The documented pattern is delegation-then-retention (Alice `claim(&repo).delegate(bob.did())`, Bob `save(delegation)`), with delegation optionally narrowed to a specific capability (`repo.subject().archive().catalog("index")`) before delegating. This is the transport realization of the `access` domain's `Prove`/`Retain` effects from `dialog-effects`.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [ucan-delegation-bridge](../sections/dialog-db--rust-dialog-ucan-readme--ucan-delegation-bridge.md) | ucan-authorization | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `a898b5de` (2026-06-04), authored by Irakli Gozalishvili.
- Bridges `rust/dialog-capability` (typed chains) and `dialog-ucan-core` (the UCAN spec implementation — surveyed as a no-README crate at this HEAD). Consumed by `rust/dialog-remote-ucan-s3` (UCAN-authorized remote), deferred to a follow-on.
- Ingested in the `scholar-ingest-dialog-db-remainder-9` cycle (2026-07-06).
