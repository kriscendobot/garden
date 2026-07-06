---
title: Syncing — remotes, upstream, push/pull, subject targeting
source: rust/dialog-repository/Guide.md
source_repo: dialog-db/dialog-db
source_commit: 18c640a06797b62eb3c57f3aeedb016634a5da19
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [local-first-sync, ucan-authorization]
status: current
---

> Abstract: The replication surface. A remote is registered with `repo.remote("origin").create(SiteAddress::Ucan(UcanAddress::new(url)))`, its branch opened and set as the local branch's upstream (`main.set_upstream(remote_main)`), after which `main.push()` and `main.pull()` synchronize the branch against it. To sync against **someone else's** repository, add `.subject(alice_repo.did())` when creating the remote so it targets Alice's repo rather than the local one — the [[subject-routing]] hook that decouples *which site* from *which repository at that site*. The key local-first ergonomic: **when a branch has a remote upstream, queries automatically replicate missing blocks on demand**, so a reader need not pre-`pull()` — the sync is lazy at read time.

## Syncing

Register a remote and set the branch's upstream, then push and pull:

```rs
// Create remote with a UCAN access service
let origin = repo.remote("origin")
    .create(SiteAddress::Ucan(UcanAddress::new("https://access.example.com")))
    .perform(&operator).await?;

// Open remote branch and set as upstream
let remote_main = origin.branch("main").open().perform(&operator).await?;
main.set_upstream(remote_main).perform(&operator).await?;

main.push().perform(&operator).await?;
main.pull().perform(&operator).await?;
```

To point at a different repository (e.g., pulling from someone else's repo):

```rs
let origin = bob_repo.remote("origin")
    .create(SiteAddress::Ucan(UcanAddress::new("https://access.example.com")))
    .subject(alice_repo.did())  // target Alice's repo, not Bob's
    .perform(&bob_operator).await?;
```

When a branch has a remote upstream, queries automatically replicate missing blocks on demand.

The `.subject(did)` override is the routing hook: a `SiteAddress` (here `Ucan`, elsewhere `S3`) names *where* the remote lives, while the subject DID names *which repository* at that site to replicate — the pairing captured by the `RemoteAddress` type in `notes/memory-layout.md`. The on-demand block replication makes `pull()` optional for read-only access: a query issued against an upstreamed branch pulls exactly the blocks it touches.

Source: [rust/dialog-repository/Guide.md](https://github.com/dialog-db/dialog-db/blob/18c640a06797b62eb3c57f3aeedb016634a5da19/rust/dialog-repository/Guide.md) at commit `18c640a0`.
