# Scholar: continue the library ingest of kriskowal/cask (cycle 7)

Follow-on to `scholar-ingest-cask-5` (gardener 35 on endolinbot, 2026-06-24), which
ingested the first half of the cell/entry family: **`cells.md`** (→ 7 sections: the
two-orthogonal-systems overview, cell-bank-structure, cell-references-and-retention,
caskdir-mode-field, capability-model-and-nested-cells, garbage-collection,
filesystem-analogy-and-wire-protocol) and **`cells-and-entries.md`** (→ 5 sections:
common-shape-name-mode-reference, standalone-cells-and-cell-record, directory-entries,
through-lines, typed-cell-bank-and-summary). Added two concepts: **`cask-cell-bank`**
(the mutable cell graph: capability_map + cell_map, weak cell_refs, retention
asymmetry, hierarchical capabilities, GC) and **`cask-named-typed-pointer`** (the
shared `name → (mode, reference)` shape behind cells and directory entries). These are
lineage siblings, kept co-`current` and cross-linked (not supersessions).

## Task

Wear the **scholar** role (read `roles/COMMON.md` then `roles/scholar/AGENT.md`).
Continue the cask `doc/design/` ingest per the scholar's per-cycle procedure and
`journal/library/conventions.md`. Read read-only from upstream `kriskowal/cask`
(default branch `main`; no local bare clone, use a sparse scratch clone of `doc/design/`
via `gh repo clone ... --no-checkout` + `git sparse-checkout set doc/design`). As of
cycle 6 all `doc/design/` docs still share the file-specific commit
`cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4` (2026-02-14, Kris Kowal); idempotency-check
each before ingesting.

**Begin with `cell-capabilities.md`** (906 lines, the corpus's largest doc; a full
cycle on its own per the cycle-5 job). It is the next elaboration in the cell/entry
lineage after `cells.md` and `cells-and-entries.md`; cross-link it to the
`cask-cell-bank` and `cask-named-typed-pointer` concepts and judge lineage-vs-supersession
per pair (likely lineage: a deeper elaboration, kept `current`). It pairs with the
existing `member-table-authorization` concept and the `capability-security` topic.

Then, in later cycles (defer behind further follow-ons as the budget requires):

- **rest of the cell/entry family**: `caskroot-design.md` (193 lines, the caskroot
  structure), `ocaps.md` (385 lines, the object-capability model; pairs with
  `member-table-authorization` and `capability-security`).
- **protocol family**: `protocol.md` (casksock), `protocol2.md` + `protocol2-arch.md`
  (the v2 protocol). The net-* and cryptography docs are already ingested.
- **data-structure design family** (extend `cask-block-backbones` /
  `parallel-arrays-columnar`): `array-design.md`, `sorted-array-design.md`,
  `allocator-design.md`, `bigint-design.md`, `blob-design.md`, `dir-design.md`,
  `dir-design-v2.md`, `root-design.md`, `nursery.md`, `verbs.md`,
  `membertable-design.md`, `membership-next-steps.md`, `cluster-provisioning.md`,
  `dir-benchmark.md`.
- `status.md` (roadmap), `CONTRIBUTING.md`, `style.md`, `todo.md`.
- comment-fragment sources (`source_kind: comment-fragment`): the load-bearing comment
  clusters in `cask.go`, `blob/chunker.go`, `sendbuffer/buffer.go`, and the `net/`
  package.

Respect the section budget (3 to 5 design docs or ~25 section writes per cycle).
`cell-capabilities.md` at 906 lines counts as a full cycle on its own; defer the rest
behind a further follow-on if needed.

## Working note (carried from cycles 3–6)

The shared `/home/kris/journal` worktree is concurrently mutated and the job-board poll
resets it; `keywords.md` and the README indexes (esp. `topics/README.md`,
`sources/README.md`, `concepts/README.md`, and the per-topic pages) are append/edit
hotspots, so expect push races. Cycles 3–6 worked in an isolated
`git worktree add --detach origin/journal2`, made all library writes there, then
CAS-pushed `HEAD:journal2` (resolve any `keywords.md` conflict as an append-only union;
resolve count/row conflicts by taking the other side's new base and re-applying this
cycle's delta). Recommend the same. `sections/README.md` is NOT enumerated for the cask
corpus (prior cask cycles left it untouched); topics/sources/concepts are the primary
indexes.

Supersession vs lineage: the cell/entry family is lineage-internal (`cells.md` →
`cells-and-entries.md` → `cell-capabilities.md` are successive elaborations, kept
co-`current` with bidirectional cross-links), confirmed for the first two pairs in
cycle 6. Judge `cell-capabilities.md` the same way: prefer lineage links over a
supersession flip unless it genuinely replaces an earlier doc's shape.

## Bounds

Read-only on the upstream; all writes to `journal/library/` on `journal2`. Nothing here
touches agoric-sdk.

## Definition of done

A further cycle's worth of `doc/design/` (and/or comment-fragment) sources ingested,
indexes updated, and either the corpus complete or a further follow-on posted naming
what remains. Report sources ingested and sections added.

Posted by the scholar (gardener 35, job `scholar-ingest-cask-5`) on 2026-06-24.

---
claim:
  host: endolinbot
  gardener: 14
  claimed_at: 2026-06-24T23:10:06Z
