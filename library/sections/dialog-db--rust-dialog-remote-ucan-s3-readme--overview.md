---
title: Overview — a UCAN-authorized remote wrapping S3 storage
source: rust/dialog-remote-ucan-s3/README.md
source_repo: dialog-db/dialog-db
source_commit: a898b5de44a29e5be30a1faa99f11ef7a5332d69
source_date: 2026-06-04
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [ucan-authorization, local-first-sync]
status: current
---

> Abstract: `dialog-remote-ucan-s3` is a UCAN-authorized remote for Dialog-DB. It wraps S3 storage with UCAN (User Controlled Authorization Networks) for delegated access control: instead of the client holding direct S3 credentials, requests are authorized through a **UCAN access service** that verifies delegation chains before granting access to the backing bucket. This is the delegation-fronted counterpart to `dialog-remote-s3` — same S3 storage underneath, but the trust boundary is a DID-addressed access service rather than raw bucket credentials, so access can be granted, narrowed, and revoked by issuing and rescinding UCAN delegations rather than by sharing keys. It is the concrete remote type used when a repository is meant to be shared across profiles without any party ever handling the bucket's secret.

## Overview

`dialog-remote-ucan-s3` is a UCAN-authorized remote for Dialog-DB. It wraps S3 storage with UCAN (User Controlled Authorization Networks) for delegated access control. Instead of direct S3 credentials, requests are authorized through a UCAN access service that verifies delegation chains.

- The client never holds the bucket's credentials; it presents a **UCAN delegation chain** to an access service, which verifies the chain and then performs the underlying S3 operation on its behalf.
- Access is a capability that can be **delegated** down a chain (owner → collaborator → …) and, being a UCAN, narrowed or revoked without re-keying the bucket.
- Underneath, the same S3 archive-blocks + memory-cells payload as [[repository-branch-remote]]'s direct `dialog-remote-s3`; the difference is the authorization boundary. See [[ucan-delegation]] for the delegation model this remote enforces.

Source: [rust/dialog-remote-ucan-s3/README.md](https://github.com/dialog-db/dialog-db/blob/a898b5de44a29e5be30a1faa99f11ef7a5332d69/rust/dialog-remote-ucan-s3/README.md) at commit `a898b5de`.
