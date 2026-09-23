---
source: rust/dialog-remote-ucan-s3/README.md
source_repo: dialog-db/dialog-db
source_commit: a898b5de44a29e5be30a1faa99f11ef7a5332d69
source_date: 2026-06-04
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 3
status: current
---

> Abstract: The README for `dialog-remote-ucan-s3`, dialog-db's UCAN-authorized remote. It wraps S3 storage with UCAN delegated access control — instead of direct S3 credentials, requests are authorized through a UCAN access service that verifies delegation chains — making it the delegation-fronted counterpart to `dialog-remote-s3`. It documents the `UcanAddress::new(access_service_url)` remote lifecycle (identical `create`/`set_upstream`/`push`/`pull` surface as any remote) and a collaboration walkthrough: Alice `claim(&repo).delegate(bob.did())` mints a UCAN chain, Bob `save`s it, and Bob then adds the same UCAN remote with `.subject(alice_repo.did())` to push/pull — no bucket secret ever shared.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/dialog-db--rust-dialog-remote-ucan-s3-readme--overview.md) | ucan-authorization, local-first-sync | current |
| [usage-walkthrough](../sections/dialog-db--rust-dialog-remote-ucan-s3-readme--usage-walkthrough.md) | ucan-authorization, local-first-sync | current |
| [collaboration](../sections/dialog-db--rust-dialog-remote-ucan-s3-readme--collaboration.md) | ucan-authorization, capability-security | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `a898b5de` (2026-06-04), authored by Irakli Gozalishvili.
- The delegation-authorized remote of the dialog-db storage cluster; it wraps the same S3 backend the direct `rust/dialog-remote-s3` (ingested the same cycle) uses, behind a UCAN access service. The delegation model is documented on `rust/dialog-ucan` / concept [[ucan-delegation]].
- Ingested in the `scholar-ingest-dialog-db-remainder-12` cycle (2026-07-06).
