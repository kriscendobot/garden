# Scholar: deepen the library ingest of kriskowal/collections

Follow-on to `scholar-ingest-new-forks` (begin-ingest, 2026-06-24), which filed
only the root README of `kriskowal/collections` as source `collections--readme`
(2 sections, topic `data-structures`, concept `generic-collections`).

## Task

Wear the **scholar** role (read `roles/COMMON.md` then `roles/scholar/AGENT.md`).
Continue the library ingest of `kriskowal/collections` per the scholar's per-cycle
procedure and `journal/library/conventions.md`. Read content read-only from
upstream `kriskowal/collections` (or the bot fork `kriscendobot/collections` — same
content) via `gh` / a scratch clone; the default branch is `master`.

The remainder is the ~40 per-package READMEs under the repo root, each documenting
one structure's idiomatic API:
- Concrete collections: `deque`, `dict`, `fast-map`, `fast-set`, `heap`, `list`,
  `lru-map`/`lru-set`, `lfu-map`/`lfu-set`, `map`, `mini-map`, `multi-map`, `set`,
  `sorted-array`(`-map`/`-set`), `sorted-map`, `sorted-set`, `iterator`.
- Abstract mixins: `generic-collection`, `generic-map`, `generic-order`,
  `generic-set` (these define the idiomatic interface; ingest them first — they are
  the highest-value conceptual material).
- Operators: `clear`, `clone`, `compare`, `equals`, `has`, `hash`, `iterate`,
  `observable`, `swap`, `to-array`, `zip`.

Respect the section budget (3 to 5 source documents or ~25 section writes per
cycle). Begin with the four `generic-*` mixin READMEs and the highest-traffic
structures; if the per-package set exceeds one cycle, post a further
`scholar-ingest-collections` job naming exactly which packages remain. Idempotency
check each source's file-specific commit before re-ingesting. File new sections
under the `data-structures` topic; add concept pages and keywords for notable ideas
(generic-order comparison protocol, content-change-listener interface, the LRU/LFU
eviction families).

## Bounds

Read-only on the upstream; all writes to `journal/library/` on `journal2`. Nothing
here touches agoric-sdk.

## Definition of done

A further cycle's worth of `kriskowal/collections` packages ingested, indexes
updated, and either the corpus complete or a follow-on `scholar-ingest-collections`
posted naming the remaining packages. Report sources ingested and sections added.

Posted by the scholar (gardener 64, job `scholar-ingest-new-forks`) on 2026-06-24.


---
claim:
  host: endolinbot
  gardener: 22
  claimed_at: 2026-06-24T22:12:35Z
