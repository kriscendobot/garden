---
title: Usage walkthrough — configure an Address, add it as a remote, push/pull
source: rust/dialog-remote-s3/README.md
source_repo: dialog-db/dialog-db
source_commit: a898b5de44a29e5be30a1faa99f11ef7a5332d69
source_date: 2026-06-04
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [local-first-sync]
status: current
---

> Abstract: The end-to-end S3-remote lifecycle. Build an `Address` from `(endpoint, region, bucket)` and attach credentials with `.with_credentials(S3Credentials::new(access_key_id, secret_access_key))`. Register it as a remote with `repo.remote("origin").create(address).perform(&operator)`. Open the local `main` branch and the remote's `main` branch, bind the remote as upstream with `main.set_upstream(upstream).perform(&operator)`, and thereafter synchronize with `main.push().perform(&operator)` and `main.pull().perform(&operator)`. Every step terminates in `.perform(&operator)` — the same operator capability environment the whole repository API routes effects through — so an S3 remote plugs into the identical remote/upstream/push/pull surface as any other backend.

## Usage

```rust
use dialog_remote_s3::{Address, S3Credentials};

// Configure S3 address with credentials from environment
let address = Address::new(
    env!("S3_ENDPOINT"),
    env!("S3_REGION"),
    env!("S3_BUCKET"),
).with_credentials(S3Credentials::new(
    env!("AWS_ACCESS_KEY_ID"),
    env!("AWS_SECRET_ACCESS_KEY"),
));

// Add as a remote on a repository
let origin = repo.remote("origin")
    .create(address)
    .perform(&operator)
    .await?;

// Set upstream and sync
let main = repo
    .branch("main")
    .open()
    .perform(&operator)
    .await?;

let upstream = origin
    .branch("main")
    .open()
    .perform(&operator)
    .await?;

main
    .set_upstream(upstream)
    .perform(&operator)
    .await?;

main
    .push()
    .perform(&operator)
    .await?;

main
    .pull()
    .perform(&operator)
    .await?;
```

The shape is identical to the generic remote lifecycle in [[repository-branch-remote]] — `create` the remote, `open` both branches, `set_upstream`, then `push`/`pull` — with `Address`/`S3Credentials` as the concrete S3 address type.

Source: [rust/dialog-remote-s3/README.md](https://github.com/dialog-db/dialog-db/blob/a898b5de44a29e5be30a1faa99f11ef7a5332d69/rust/dialog-remote-s3/README.md) at commit `a898b5de`.
