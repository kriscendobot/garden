---
title: Overview — a direct SigV4-signed S3 remote for repository sync
source: rust/dialog-remote-s3/README.md
source_repo: dialog-db/dialog-db
source_commit: a898b5de44a29e5be30a1faa99f11ef7a5332d69
source_date: 2026-06-04
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [local-first-sync, content-addressed-storage]
status: current
---

> Abstract: `dialog-remote-s3` is an S3-compatible remote for Dialog-DB. It provides *direct* S3 access with SigV4 request signing — credentials go straight to the bucket, no authorization service in between — and is used to push and pull repository data (archive blocks and memory cells) to and from S3 buckets. It is the concrete, credential-fronted implementation of the `dialog-repository` remote abstraction: a remote is registered on a repository, its branch bound as a local branch's upstream, and thereafter `push()`/`pull()` move the branch's content-addressed blocks over the S3 protocol. Its UCAN-authorized sibling `dialog-remote-ucan-s3` wraps this same S3 storage behind a delegation-checking access service; use `dialog-remote-s3` when the client legitimately holds the bucket's own credentials.

## Overview

`dialog-remote-s3` is an S3-compatible remote for Dialog-DB. It provides direct S3 access with SigV4 request signing, used for pushing and pulling repository data (archive blocks, memory cells) to S3 buckets.

- The remote carries the bucket's credentials directly (S3 access key + secret), signing each request with AWS Signature Version 4.
- The synchronized payload is the repository's content-addressed data: **archive blocks** (the immutable block store) and **memory cells** (the mutable pointers).
- It is one concrete `impl Into<SiteAddress>` behind the generic remote surface of [[repository-branch-remote]]; the delegation-authorized alternative is `dialog-remote-ucan-s3`, which wraps the same S3 backend behind a UCAN access service.

Source: [rust/dialog-remote-s3/README.md](https://github.com/dialog-db/dialog-db/blob/a898b5de44a29e5be30a1faa99f11ef7a5332d69/rust/dialog-remote-s3/README.md) at commit `a898b5de`.
