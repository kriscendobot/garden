---
title: Design (sweep-time refcount + scratch-mount directory removal) + API extension
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
kind: index
section_count: 2
---

> Abstract: **Content-store cleanup (sweep-time refcount, NOT persistent counter)**: during GC sweep, after identifying the formulas to collect — (1) scan **collected** formulas for `readable-blob`/`readable-tree` types; collect their `content` hashes into a candidate set; (2) scan **surviving** formulas for any referencing the same hashes; remove those hashes from the candidate set; (3) for each hash remaining in the candidate set, `rm {statePath}/store-sha256/{hash}`. Avoids durable refcount-table complexity; consistent with existing mark-and-sweep. **Scratch-mount cleanup** (simpler, 1:1 with formula, no sharing): when collecting a `scratch-mount` formula, extract formula number from identifier, `rm -rf {statePath}/mounts/{formulaNumber}`. **Integration point**: both cleanup steps hook into `collectIfDirty()` in `daemon.js`, after formula JSON deletion and before pass completion. **Content-store sweep batched once per GC pass** (operating on the batch of collected formulas), not per-formula. **API extension**: add `remove(hash)` method to content-store interface — `await fs.promises.unlink(filePowers.joinPath(storeDirectoryPath, hash))`.

Sections:

- [Design](endo-but-for-bots--llm-designs-daemon-content-store-gc--design-and-api-extension--design.md)
- [Dependencies](endo-but-for-bots--llm-designs-daemon-content-store-gc--design-and-api-extension--dependencies.md)

Source: [designs/daemon-content-store-gc.md](https://github.com/endojs/endo-but-for-bots/blob/e22f713278b397142ca2a27eddd38f937573cd43/designs/daemon-content-store-gc.md) at commit `e22f7132` on branch `llm`.
