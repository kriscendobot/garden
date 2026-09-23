---
title: Pull — Fetch, Reconciliation, Differentiation, Integration
source: notes/sync.md
source_repo: dialog-db/dialog-db
source_commit: bf88f2c3313f54e3bd2d89f394f2c4aaf1f1d6c1
source_date: 2025-10-20
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [local-first-sync, change-propagation]
status: current
---

> Abstract: Pulling is **Fetch** (discover the latest remote root via the pointer's `ETag`, materialize a *partial* replica from it) then **Merge**. Merge needs to know whether a node present locally but absent remotely was *inserted locally* or *removed remotely* — undecidable from the two trees alone — so it computes a **differential** between the current tree and the last-pushed **checkpoint** it diverged from, yielding local changes as a set of `Add`/`Remove` entries (a ZSet-like ±1 weighting), then **integrates** them into the fetched remote tree. Integration only replicates subtrees that changed locally (unchanged subtrees are skipped; locally-changed ones are already cached). Add resolves a concurrent conflict by keeping the greater hash; Remove is a no-op unless the target holds the same key+hash. A `Replica{current, checkpoint, upstream}` `push` loop CAS-asserts the new root and re-`pull`s on failure.

Pulling changes is composed of two sequential phases: **Fetch** and **Merge**.

**Fetch** discovers the latest remote state and materializes a *partial* replica of it from the discovered root: determine the last known remote root (`ETag`), query the mutable pointer for the current remote root, and load the tree from that root (getting the root node from the archive unless it is in local cache). Failure handling: `401` re-sign and retry; `404` treat as empty tree; `5xx` retry with exponential backoff.

**Reconciliation.** To merge local and remote trees we must identify what changed where. Given a node present in the local tree but not the remote, the two trees alone cannot say whether it was inserted locally or removed remotely since the last sync — information critical to deciding whether it stays in the merged tree. The resolution: compute the differential between the current tree and the tree it **diverged from** (the last successfully-pushed checkpoint), giving the local changes to **integrate** into the fetched remote. Integration naturally replicates only subtrees with overlapping changes; unchanged subtrees are never accessed, and locally-changed-but-remotely-unchanged subtrees are already in cache.

The merge logic (Rust sketch):

```rust
pub struct Replica { current: Tree, checkpoint: Tree, upstream: MutablePointer }

impl Replica {
  fn changes(&self) -> impl Differential { Differential::from((self.current, self.checkpoint)) }
  async fn merge(&mut self, remote: &Tree) -> Result<&mut Self> {
    if remote.root() != self.checkpoint.root() {
      self.current = integrate(remote, self.changes())?;
    }
    Ok(self)
  }
  async fn pull(&mut self) -> Result<&mut Self> {
    let root = self.upstream.query().await?;
    if root != self.checkpoint.root() { self.merge(Tree::load(root)).await; }
    Ok(self)
  }
  async fn push(&self) -> Result<&mut Self> {
    loop {
      let checkpoint = self.current.clone();
      if let Ok(_) = upstream.assert(checkpoint.root()).await { self.checkpoint = checkpoint }
      else { self.pull().await?; }
    }
  }
}
```

**Differentiation.** Thinking of the search tree as a sorted set of entries, the differential between the last checkpoint and the current working tree is a set of entries added or removed (`Change::Add(Entry)` / `Change::Remove(Entry)`). This ends up resembling a **ZSet from DBSP** — for a collection the weight stays in the −1/+1 range, and the tree is effectively a collection where Remove/Add is −1/+1. Computing the differential does not require replicating unchanged subtrees, and changed subtrees are likely already cached.

**Integration** applies the differential to the target tree (assumed to have diverged from the checkpoint), iterating over changes to add or remove entries, replicating only subtrees changed locally:

- **Adding an entry:** if the target has a conflicting entry under the same key (a concurrent change), compare hashes — if the existing hash is greater, keep it; otherwise replace it with the entry being added. If there is no conflict, insert at the right location.
- **Removing an entry:** if the target has no entry for the key, or an entry with a different hash, the entry was already removed or replaced — do nothing. Only when the target holds the same key with the same hash is it removed.

Source: [notes/sync.md](https://github.com/dialog-db/dialog-db/blob/bf88f2c3313f54e3bd2d89f394f2c4aaf1f1d6c1/notes/sync.md) at commit `bf88f2c3`.
