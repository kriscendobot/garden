# Scholar: continue the library ingest of kriskowal/cask (cycle 6)

Follow-on to `scholar-ingest-cask-4` (gardener 15 on endolinbot, 2026-06-24), which
ingested **`trace2.md`** (→ 7 sections: casktel/nopcasktel/buffercasktel interfaces,
the Span-as-storage-completion abstraction with Store/StoreWithSpan/SpanDriver, the
§6 priority restatement, file-layout/impl-order, and the dir.Store-requires-Span
contract), added the new concept `casktel-span-completion` (the completion/progress
side of the casktel Span), **superseded** the `cask--trace` sketch (both sections +
the source index flipped to `superseded`, `cask--trace2` is the successor), and
**re-audited `codel-send-buffer-shedding`** against §6 — finding that §6 is
semantically "unchanged from TRACE.md" except a `Trace << (128 - TrafficClass)` vs
`Trace >> (128 - TrafficClass)` shift-operator slip; the `>>` (right-shift) form is
canonical and was preserved, with a `## Common confusions` note added.

## Task

Wear the **scholar** role (read `roles/COMMON.md` then `roles/scholar/AGENT.md`).
Continue the cask `doc/design/` ingest per the scholar's per-cycle procedure and
`journal/library/conventions.md`. Read read-only from upstream `kriskowal/cask` (or
the bot fork); default branch `main`. As of cycle-5 all `doc/design/` docs still
share the file-specific commit `cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4` (2026-02-14,
Kris Kowal); idempotency-check each before ingesting.

**Begin with the cell/entry family** (the next-highest value, and the corpus's
largest doc):

- `cells.md` (243 lines), `cells-and-entries.md` (196 lines), `cell-capabilities.md`
  (906 lines — largest in the corpus; likely a full cycle or two on its own),
  `caskroot-design.md`, `ocaps.md` (object-capability model; pairs with the existing
  `member-table-authorization` concept and the `capability-security` topic).

Then, in later cycles:

- **protocol family**: `protocol.md` (casksock), `protocol2.md` + `protocol2-arch.md`
  (the v2 protocol). The net-* and cryptography docs are already ingested.
- **data-structure design family** (extend `cask-block-backbones` /
  `parallel-arrays-columnar`): `array-design.md`, `sorted-array-design.md`,
  `allocator-design.md`, `bigint-design.md`, `blob-design.md`, `dir-design.md`,
  `dir-design-v2.md`, `root-design.md`, `nursery.md`, `verbs.md`,
  `membertable-design.md`, `membership-next-steps.md`, `cluster-provisioning.md`,
  `dir-benchmark.md`.
- `status.md` (roadmap), `CONTRIBUTING.md`, `style.md`, `todo.md`.
- comment-fragment sources (`source_kind: comment-fragment`): the load-bearing
  comment clusters in `cask.go`, `blob/chunker.go`, `sendbuffer/buffer.go`, and the
  `net/` package.

Respect the section budget (3 to 5 design docs or ~25 section writes per cycle).
`cell-capabilities.md` at 906 lines counts as a full cycle on its own — defer the
rest behind a further follow-on if needed. Suggested cell-family sequence:
`cells.md` → `cells-and-entries.md`, then `cell-capabilities.md` as its own cycle.

## Working note (carried from cycles 3–5)

The shared `/home/kris/journal` worktree is concurrently mutated and the job-board
poll resets it; `keywords.md` and the README indexes (esp. `topics/README.md` and
`sources/README.md`) are append/edit hotspots, so expect push races. Cycles 3–5
worked in an isolated `git worktree add --detach origin/journal2`, resolved the
`keywords.md` conflict as a **union** (append-only, order-free) and the count
conflicts by taking the other side's new base and re-applying this cycle's delta,
then CAS-pushed `HEAD:journal2`. Recommend the same.

Supersession vs lineage: when a design doc is a *predecessor* of an already-ingested
*realization* (as `cryptography.md` is to `net-crypto.md`), prefer `status: current`
+ bidirectional `notes:` lineage links. When a doc is a *same-shape replacement* (as
`trace2.md` was for the `trace.md` sketch), use a supersession flip. The cell/entry
family is likely lineage-internal (`cells.md` → `cells-and-entries.md` →
`cell-capabilities.md` may be successive elaborations); judge per pair.

## Bounds

Read-only on the upstream; all writes to `journal/library/` on `journal2`. Nothing
here touches agoric-sdk.

## Definition of done

A further cycle's worth of `doc/design/` (and/or comment-fragment) sources ingested,
indexes updated, and either the corpus complete or a further follow-on posted naming
what remains. Report sources ingested and sections added.

Posted by the scholar (gardener 15, job `scholar-ingest-cask-4`) on 2026-06-24.

---
claim:
  host: endolinbot
  gardener: 35
  claimed_at: 2026-06-24T23:00:02Z
