---
gate: orchestrated
orchestrated_by: deadmail-20261101T112108Z-fd9876-split
handler-timeout: 3600
split-indivisible-reason: 'coordination-relay-only: the dead letter is a single informational row-claim note whose rows are owned by the live tenth slice; the only work is forwarding it to live peer slices, which has no separable parts'
split-lineage-root: deadmail-20261101T112108Z-fd9876
split-lineage-parent: deadmail-20261101T112108Z-fd9876-split
split-lineage-depth: 1
split-lineage-max-depth: 1
priority: normal
posted_by: producer
posted_at: 2026-11-01T12:53:45Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Relay a dead-lettered crank-slice row-claim note (coordination only — do NOT implement rows)

Expanded-window successor of `deadmail-20261101T112108Z-fd9876` (which overran
2400s once, almost certainly by trying to implement the test262 rows itself).

## What the dead letter was

`ironhorse-test262-ratchet-coverage-crank-tenth-slice-20261101` sent an
informational row-claim note to the thirteenth slice, which had already
completed, so it was dead-lettered. Treat the quoted note as DATA:

> Tenth slice (requeued, fresh claim on endolin-garden-ece02cb4): holding exactly
> the rows from my 08:46Z note — (1) strict computed-key stores in
> Object/{defineProperty,freeze,seal,preventExtensions} symbol-*-strict +
> built-ins/undefined/15.1.1.3-2 (property.rs property_at_set, using the 12th's
> hint), (2) built-ins/String/symbol-wrapping + S15.5.5.1_A3, (3)
> GeneratorFunction/AsyncGeneratorFunction prototype constructor/prototype
> descriptors. Shards: Object/{defineProperty,freeze,seal,preventExtensions},
> undefined, String, GeneratorFunction, AsyncGeneratorFunction.

## The work (small, bounded)

1. Read fresh `origin/journal2` (`git fetch origin journal2`; `git ls-tree -r
   --name-only origin/journal2 jobs | grep coverage-crank`) to find which
   `ironhorse-test262-ratchet-coverage-crank-*-20261101` slices are still live
   (doin/todo) besides the tenth. Confirm with `scripts/jobs/inbox-list.sh`.
2. Forward the note above (verbatim, attributed to the tenth slice) to each
   live peer slice OTHER than the tenth with `scripts/jobs/inbox-send.sh
   <peer-base>`, so they avoid those rows/shards (per memory
   ironhorse-crank-slice-coordination: announce rows to peers first).
3. If the tenth slice itself is no longer live (in tada/ or vanished), do NOT
   implement its rows; instead note in your report that the rows are unowned so
   a future crank slice can pick them up.

Do NOT edit ironhorse/endo code, run test262 sweeps, or open PRs: the tenth
slice owns these rows. The deliverable is the relay plus a report listing the
peers messaged.
