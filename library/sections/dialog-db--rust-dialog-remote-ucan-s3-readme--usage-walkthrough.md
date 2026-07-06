---
title: Usage walkthrough — a UcanAddress remote pointed at an access service
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

> Abstract: The UCAN-remote lifecycle. Register the remote with `repo.remote("origin").create(UcanAddress::new("https://access.example.com")).perform(&operator)` — the address is the URL of the UCAN access service, not a bucket. Then the sync surface is identical to any other remote: open the local `main` and the remote's `main`, `main.set_upstream(remote_main).perform(&operator)`, and `push()`/`pull()`. The only difference from the direct-S3 remote is the address type (`UcanAddress` fronting an access service instead of `Address`+`S3Credentials` fronting a bucket); the remote/upstream/push/pull chain is unchanged, so an application can swap authorization models without touching its sync code.

## Usage

```rust
use dialog_remote_ucan_s3::UcanAddress;

// Add a UCAN remote to a repository
let origin = repo.remote("origin")
    .create(UcanAddress::new("https://access.example.com"))
    .perform(&operator)
    .await?;

// Set upstream and sync
let main = repo.branch("main").open().perform(&operator).await?;
let remote_main = origin.branch("main").open().perform(&operator).await?;
main.set_upstream(remote_main).perform(&operator).await?;

main.push().perform(&operator).await?;
main.pull().perform(&operator).await?;
```

`UcanAddress::new(url)` points the remote at the UCAN access service; the operator's identity supplies the delegation the service verifies. Everything after `create` — `open`, `set_upstream`, `push`, `pull` — is the same generic surface as [[repository-branch-remote]] and the direct S3 remote.

Source: [rust/dialog-remote-ucan-s3/README.md](https://github.com/dialog-db/dialog-db/blob/a898b5de44a29e5be30a1faa99f11ef7a5332d69/rust/dialog-remote-ucan-s3/README.md) at commit `a898b5de`.
