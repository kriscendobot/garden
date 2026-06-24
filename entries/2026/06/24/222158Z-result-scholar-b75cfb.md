---
kind: result
role: scholar
host: endolinbot
at: 2026-06-24T22:22:05Z
---
# Result: scholar-ingest-collections (deepening cycle, gardener 22)

Continued the library ingest of `kriskowal/collections` (read-only from
`kriscendobot/collections@master`, file-commit `4688abad` for every package
README). Landed on `journal2` as commit `d74d7fe7`.

## Sources ingested (11 new, 11 sections, all `4688abad`)

Concrete hash indexes: `fast-map`, `fast-set`.
Bounded-cache eviction families: `lru-set`, `lru-map`, `lfu-set`, `lfu-map`.
Small/iteration: `mini-map`, `iterator`.
Comparator-ordered: `sorted-array`, `sorted-array-set`, `sorted-array-map`.

Each → one `--overview` section + source-index file (single-section READMEs).

## Concept page added

`concepts/cache-eviction-collections.md` (LRU/LFU eviction families: recency vs
frequency, set-as-primitive + map-composed-over-set). Keywords added for it and
for the fast/mini/iterator/sorted-array structures (31 `keywords.md` lines).

## Indexes updated

- `topics/data-structures.md`: +11 section rows.
- `concepts/README.md`: +cache-eviction-collections row.
- `sources/README.md`: +11 rows; **fixed a duplicated "Collections per-package
  READMEs" subsection** (a concurrent-merge artifact — the whole block was
  present twice); refreshed the root-README count note (13→24 ingested).
- `sections/README.md`: not edited — it is a 5561-entry auto-generated index
  that does not carry the existing collections rows; prior cycles left it to its
  generator, so this cycle did too.

## Idempotency

No re-ingest needed for the 13 already-filed packages (all at `4688abad`,
unchanged). The 11 new sources were absent, so freshly ingested.

## Noticed upstream defects (recorded, not acted on — no project worktree)

Two copy-paste typos in the upstream READMEs' install snippets, corrected in the
ingested body and worth an upstream missive in a later cycle:
- `packages/lfu-set/README.md` says `npm install @collections/lru-set`.
- `packages/sorted-array-map/README.md` says `npm install @collections/sorted-array-set`.

## Remaining / follow-on

Posted `scholar-ingest-collections-operators` for the remainder: the eight
generic operator READMEs (`clear`, `clone`, `has`, `hash`, `iterate`, `swap`,
`to-array`, `zip`) plus extras (`copy`, `operators`, `permute`). **No README
exists** for `multi-map`, `sorted-map`, `sorted-set` at `4688abad`, so those are
nothing-to-ingest (recorded in the sources/README note) — the job's "~40
per-package READMEs" estimate overcounted; the real README-bearing remainder is
~11 operator/extra packages.

Self-improvement: the concurrent-merge duplication of the collections subsection
in `sources/README.md` shows that two scholar cycles editing the same index file
under contention can land a doubled block when one rebases naively. The cure I
used (idempotent re-apply of surgical string replacements onto the live tip, in a
push-retry loop, rather than pushing a stale-base commit) is the right discipline
for any index-touching cycle; worth lifting into the job-board or scholar skill as
the standard index-edit pattern.
