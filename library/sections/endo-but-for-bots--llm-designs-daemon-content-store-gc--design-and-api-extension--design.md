---
title: Design
source: designs/daemon-content-store-gc.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: e22f713278b397142ca2a27eddd38f937573cd43
source_date: 2026-03-21
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [daemon, persistence]
status: current
notes: The "sweep-time reference count, NOT a persistent counter" is the daemon's GC-discipline pattern — avoids the complexity of a durable refcount table by re-deriving liveness from the formula graph each sweep. Same pattern would generalize to any 1-to-many storage where the "many" side is in formulas. The content-store sweep is **batched** (once per GC pass over the batch of collected formulas), not per-formula.
parent: endo-but-for-bots--llm-designs-daemon-content-store-gc--design-and-api-extension
---

### Content-store cleanup: reference counting at collection time

During the GC sweep, after identifying the set of formulas to collect:

1. **Scan collected formulas** for `readable-blob` and `readable-tree` types. Collect their `content` hashes into a candidate set.
2. **Scan surviving formulas** for any that reference the same hashes. Remove those hashes from the candidate set.
3. **Delete orphaned content files** — for each hash remaining in the candidate set, remove `{statePath}/store-sha256/{hash}`.

This is a sweep-time reference count, not a persistent counter. It avoids the complexity of maintaining a durable refcount table and is consistent with the existing mark-and-sweep approach.

### Scratch-mount cleanup: directory removal at collection time

When collecting a `scratch-mount` formula:

1. Extract the formula number from the formula identifier.
2. Remove the backing directory: `rm -rf {statePath}/mounts/{formulaNumber}`.

This is simpler than content-store cleanup because scratch-mount directories have a 1:1 relationship with their formula (no sharing).

### Integration point

Both cleanup steps hook into the existing `collectIfDirty()` function in `daemon.js`, after the formula JSON is deleted and before the collection pass completes. The content-store sweep runs once per GC pass (not per formula), operating on the batch of collected formulas.

### Content store API extension

Add a `remove(hash)` method to the content store interface:

```js
const remove = async hash => {
  const storePath = filePowers.joinPath(storeDirectoryPath, hash);
  await fs.promises.unlink(storePath);
};
```

Source: [designs/daemon-content-store-gc.md](https://github.com/endojs/endo-but-for-bots/blob/e22f713278b397142ca2a27eddd38f937573cd43/designs/daemon-content-store-gc.md) at commit `e22f7132` on branch `llm`.
