---
ts: 2026-05-29T20:20:16Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo
to: "*"
short_id: 04d956
prs:
  - repo: endojs/endo
    pr: 3276
    role: upstream
  - repo: endojs/endo-but-for-bots
    pr: 336
    role: superseded-mirror
  - repo: endojs/endo-but-for-bots
    pr: 379
    role: new-mirror
refs:
  - entries/2026/05/29/200322Z-dispatch-fixer-04d956.md
  - https://github.com/endojs/endo/pull/3276#pullrequestreview-4388440170
  - https://github.com/endojs/endo-but-for-bots/pull/379
---

# result: fixer — verified-no-change reply to naugtur feedback on #3276 mirror

## Disposition

**`verified-no-change`** plus one regression test for parity
evidence (no source change).

## Deliverable

- **Addressing commit**: `96ea2c59cc40011525c695541a68a207f8765a08`
  on top of upstream-synced base `f4aad15aa`.
- **Mirror PR**: <https://github.com/endojs/endo-but-for-bots/pull/379>
  (new PR; reopen of #336 blocked by GitHub:
  `state cannot be changed. The fix/issue-59-star-export-cycle
  branch was force-pushed or recreated.`).
- **PR body** cites #336 as superseded and links to the upstream
  review thread.

## Technical answer to naugtur

The "all calls to deferring notify happen before `upstreamNotify`
can be obtained" subcase is reachable in theory (cyclic re-export
of an unused live binding where no higher wireUp re-references the
deferred notifier and no downstream subscriber exists), but it is
**benign**: the queue stays full, the local `value` stays
`undefined`, and the export reads as `undefined`. Node.js reads
the same fixture shape (`export var y;` declared but never
assigned) as `undefined` for every projection of the cycle. The
new test `cyclic star export with renaming reexport, unused live
binding` in `packages/ses/test/import-gauntlet.test.js` pins SES
to Node.js parity for this shape.

## Steps performed

1. Synced mirror branch to upstream PR head `f4aad15a` (cosmetic
   test rename + companion compartment-mapper tests).
2. Added one regression test (43 lines, `// @ts-nocheck` file, no
   source change).
3. Verified `yarn workspace ses test` (503 pass + 2 known failures
   + 2 skipped) and `yarn workspace @endo/compartment-mapper test`
   cycle-rename suites (12 pass).
4. Force-with-lease pushed mirror branch (anchored to prior SHA).
5. Opened PR #379 (reopen of #336 blocked per above).
6. Posted top-level summary on the mirror PR (covered by repo's
   standing authorization).
7. **No comment posted on upstream PR #3276** (not authorized per
   the dispatch's explicit restriction).

## Liaison disposition

- Dispatch root `dispatches/fixer--04d956/` to be torn down by the
  liaison after this entry.
- Authorized upstream reply: not in this engagement. If naugtur's
  question merits an explicit acknowledgment on the upstream
  thread, that needs a per-action authorization in a new
  dispatch (or the boatman's mirror-cross-link convention can
  surface the mirror PR's reply when the next ferry happens).

Self-improvement: nothing this engagement (per the dispatched
fixer's own report).
