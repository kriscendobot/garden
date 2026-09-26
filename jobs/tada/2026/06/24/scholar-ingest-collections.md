Those three are other gardeners' worktrees — not mine; mine were removed cleanly. Work is complete. Here is my report.

---

## Completion report: `scholar-ingest-collections` (gardener 22)

**Done.** Deepened the `kriskowal/collections` library ingest. Landed on `journal2` as commit `d74d7fe7`; the claimed job is in `jobs/tada/`.

**Context correction:** the job assumed only the root README was filed, but a prior cycle had already ingested 13 packages (root readme + the four `generic-*` mixins + compare/equals/observable + map/set/list/dict/deque/heap). I idempotency-checked those (all at file-commit `4688abad`, unchanged → no re-ingest) and ingested the **remaining concrete structures** this cycle.

**11 sources ingested (11 sections), all at `4688abad`:**
- Hash indexes: `fast-map`, `fast-set`
- Bounded-cache eviction families: `lru-set`, `lru-map`, `lfu-set`, `lfu-map`
- Small / iteration: `mini-map`, `iterator`
- Comparator-ordered: `sorted-array`, `sorted-array-set`, `sorted-array-map`

Each got a `--overview` section plus a source-index file.

**New concept page:** `concepts/cache-eviction-collections.md` (LRU vs LFU, recency vs frequency, set-as-primitive with map-composed-over-set) + 31 `keywords.md` lines for it and the fast/mini/iterator/sorted-array structures.

**Indexes updated:** `topics/data-structures.md` (+11 rows), `concepts/README.md` (+1 row), `sources/README.md` (+11 rows, root-note refreshed 13→24). Left `sections/README.md` to its auto-generator, consistent with prior cycles. (Did not touch the shared `/home/kris/journal` tree — a concurrent gardener was mid-edit on frb there; all my work went through an isolated worktree off `origin/journal2` with a CAS-retry push.)

**Fixed a defect:** `sources/README.md` had the entire "Collections per-package READMEs" subsection duplicated (a concurrent-merge artifact) — collapsed to one.

**Noticed upstream typos** (corrected in the ingested bodies, flagged for a future missive — no project worktree to act on them): `lfu-set/README.md` and `sorted-array-map/README.md` both have wrong package names in their `npm install` snippets.

**Follow-up:** posted `scholar-ingest-collections-operators` for the real remainder — the eight generic operator READMEs (`clear`, `clone`, `has`, `hash`, `iterate`, `swap`, `to-array`, `zip`) plus `copy`/`operators`/`permute`. It was claimed by another gardener within seconds. Recorded that `multi-map`, `sorted-map`, `sorted-set` ship **no README** at `4688abad`, so the job's "~40 READMEs" estimate overcounted; the README-bearing corpus is essentially complete after the operators land.

**Self-improvement:** the duplicated subsection shows two scholar cycles editing the same index file under contention can land a doubled block via naive rebase. The cure I used — idempotent re-apply of surgical string replacements onto the *live tip* in a push-retry loop, never pushing a stale-base commit — is worth lifting into the job-board or scholar skill as the standard index-edit pattern.
