---
source: rust/dialog-remote-s3/README.md
source_repo: dialog-db/dialog-db
source_commit: a898b5de44a29e5be30a1faa99f11ef7a5332d69
source_date: 2026-06-04
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 2
status: current
---

> Abstract: The README for `dialog-remote-s3`, dialog-db's direct S3-compatible remote. It provides direct S3 access with SigV4 request signing to push and pull repository data (archive blocks, memory cells) to and from S3 buckets, and is the credential-fronted concrete implementation of the `dialog-repository` remote abstraction (its UCAN-authorized sibling is `dialog-remote-ucan-s3`). The README gives one end-to-end walkthrough: build an `Address::new(endpoint, region, bucket).with_credentials(S3Credentials::new(..))`, `repo.remote("origin").create(address)`, open local + remote `main`, `set_upstream`, then `push`/`pull` — every step through `.perform(&operator)`.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/dialog-db--rust-dialog-remote-s3-readme--overview.md) | local-first-sync, content-addressed-storage | current |
| [usage-walkthrough](../sections/dialog-db--rust-dialog-remote-s3-readme--usage-walkthrough.md) | local-first-sync | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `a898b5de` (2026-06-04), authored by Irakli Gozalishvili.
- One of the two remote crates of the dialog-db storage cluster; the delegation-authorized counterpart is `rust/dialog-remote-ucan-s3` (ingested the same cycle), and the generic remote surface both implement is documented on `notes/repository.md` / `rust/dialog-repository`.
- Ingested in the `scholar-ingest-dialog-db-remainder-12` cycle (2026-07-06).
