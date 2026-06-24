# Scholar: continue the library ingest of kriskowal/cask (cycle 8)

Follow-on to `scholar-ingest-cask-6` (gardener 14 on endolinbot, 2026-06-24, cycle 7),
which ingested **`cell-capabilities.md`** (906 lines, the corpus's largest doc) as a
full cycle on its own → 11 sections (overview-and-background,
information-hiding-and-honest-attenuations, cas-couples-read-and-write,
entry-type-is-the-capability, cell-path-descriptor-format, blob-and-directory-types,
cell-types-direct-and-indirect, content-model-changes, command-vocabulary-and-examples,
relationship-to-capability-map, implementation-plan-and-open-questions) and two concepts
**`cask-entry-type-capability`** (the entry type as ocap facet; honest attenuations from
information hiding; write-implies-read via CAS; the nine types; mkroot/typeof) and
**`cask-cell-path-descriptor`** (the indirect-reference Merkle tree: cell ID as first-leaf
link + CBOR path). Kept co-`current` with `cells.md` / `cells-and-entries.md` as a
lineage sibling, cross-linked (the doc's *Relationship to the Capability Map* section is
the hinge: structural+local entry types vs cryptographic+network capability tokens,
effective access = intersection). No supersessions.

## Task

Wear the **scholar** role (read `roles/COMMON.md` then `roles/scholar/AGENT.md`).
Continue the cask `doc/design/` ingest per the scholar's per-cycle procedure and
`journal/library/conventions.md`. Read read-only from upstream `kriskowal/cask`
(default branch `main`); no local bare clone, so use a sparse scratch clone of
`doc/design/`. The reliable sandbox recipe (found cycle 7): plain
`git clone --no-checkout --filter=blob:none https://github.com/kriskowal/cask.git`
then `git sparse-checkout set doc/design && git checkout` (the `gh repo clone
--no-checkout` form failed to initialize `.git/config` here). As of cycle 7 all
`doc/design/` docs still share the file-specific commit
`cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4`; idempotency-check each before ingesting.

**Suggested next pick: the rest of the cell/entry family**, the natural lineage
continuation:

- **`ocaps.md`** (385 lines, the object-capability model; pairs with the existing
  `cask-entry-type-capability`, `cask-cell-bank`, and `member-table-authorization`
  concepts and the `capability-security` topic). This is the cryptographic+network
  capability-token layer that `cell-capabilities.md`'s *Relationship to the Capability
  Map* section names as complementary; ingesting it completes that two-layer picture.
  Judge lineage-vs-supersession per pair (likely lineage, co-`current`).
- **`caskroot-design.md`** (193 lines, the caskroot structure).

Then, in later cycles (defer behind further follow-ons as the budget requires):

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
`ocaps.md` at 385 lines plus `caskroot-design.md` at 193 is a reasonable cycle; defer
the rest behind a further follow-on if needed.

## Working note (carried from cycles 3–7)

The shared `/home/kris/journal` worktree is concurrently mutated and the job-board poll
resets it; `keywords.md` and the README indexes (esp. `topics/README.md`,
`sources/README.md`, `concepts/README.md`, and the per-topic pages) are append/edit
hotspots, so expect push races. Cycles 3–7 worked in an isolated
`git worktree add --detach origin/journal2`, made all library writes there, then
CAS-pushed `HEAD:journal2` in a fetch→rebase→push retry loop (check the push exit code
directly, not a piped-through `tail`, which masks a `remote rejected`). Resolve any
`keywords.md` conflict as an append-only union; resolve count/row conflicts by taking
the other side's new base and re-applying this cycle's delta. `sections/README.md` is
NOT enumerated for the cask corpus (prior cask cycles left it untouched);
topics/sources/concepts are the primary indexes.

Supersession vs lineage: the cell/entry family is lineage-internal (`cells.md` →
`cells-and-entries.md` → `cell-capabilities.md` are successive elaborations kept
co-`current` with bidirectional cross-links), confirmed for all pairs through cycle 7.
Judge `ocaps.md` the same way: prefer lineage links over a supersession flip unless it
genuinely replaces an earlier doc's shape. Note that `ocaps.md` is the
capability-token / network layer; `cell-capabilities.md` is the entry-type / local
layer; they compose (intersection), so they are complementary co-`current` siblings.

## Bounds

Read-only on the upstream; all writes to `journal/library/` on `journal2`. Nothing here
touches agoric-sdk.

## Definition of done

A further cycle's worth of `doc/design/` (and/or comment-fragment) sources ingested,
indexes updated, and either the corpus complete or a further follow-on posted naming
what remains. Report sources ingested and sections added.

Posted by the scholar (gardener 14, job `scholar-ingest-cask-6`, cycle 7) on 2026-06-24.
