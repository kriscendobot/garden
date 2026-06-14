---
ts: 2026-06-14T08:03:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--188902
prs:
  - repo: endojs/endo-but-for-bots
    pr: 379
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/379
  - https://github.com/endojs/endo-but-for-bots/pull/379#pullrequestreview-4492610183
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/13/064924Z-result-fixer-138413.md
---

# dispatch: fixer — merge SES + Node-parity test pairs on PR #379 per kriskowal review

Kriskowal CHANGES_REQUESTED review `4492610183` on PR #379
(2026-06-14T08:00:59Z, body):

> Please consolidate every X.test.js and X-node-parity.test.js
> such that there's more clearly legible evidence that the
> declared fixture is covered by both treatments. Consequently,
> the scenarios constant can be declared closer to where it is
> used, as all usage will be in one test module.

This is a refactor on top of fixer `138413`'s table-test
generator. The current shape (post-138413):
- `cycle-rename-tdz-matrix.test.js` (SES, iterates SCENARIOS)
- `cycle-rename-tdz-matrix-node-parity.test.js` (Node, iterates SCENARIOS)
- `_cycle-rename-tdz-assertions.js` (SCENARIOS table)

Maintainer wants:
- Single test file per scenario (or per logical grouping)
  with BOTH SES and Node-parity treatments visible
  side-by-side.
- SCENARIOS constant moves into that single file (no longer
  shared via a separate module since there's only one
  consumer).

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#379`, OPEN (not DRAFT),
  base `master`, head `fix/issue-59-star-export-cycle` at
  `b7e77cf38` (per dispatch-prepare). FETCH if newer.

## Task

In your `project/` worktree on
`fix/issue-59-star-export-cycle`:

1. **Read** the current state of:
   - `packages/compartment-mapper/test/cycle-rename-tdz-matrix.test.js`
   - `packages/compartment-mapper/test/cycle-rename-tdz-matrix-node-parity.test.js`
   - `packages/compartment-mapper/test/_cycle-rename-tdz-assertions.js`
   - The 7 fixture directories under
     `packages/compartment-mapper/test/fixtures-cycle-{rename,named-reexport}-tdz-*/`
2. **Decide the consolidated shape**. Options:
   - **One file with both treatments inline per scenario**:
     each scenario gets a SES test + a Node test back-to-back
     in the same file, iterated from the inline SCENARIOS
     table. Single test file.
   - **One file per scenario** (7 files), each with SES +
     Node back-to-back. More legible per-scenario but more
     files.
   The maintainer's "all usage will be in one test module"
   hints at the first shape (single file).
3. **Refactor**:
   - Inline the SCENARIOS table into the chosen single file
     (or split per-scenario).
   - For each scenario, register a SES test AND a Node
     parity test, side-by-side. Use a helper like:
     ```js
     for (const scenario of SCENARIOS) {
       test(`${scenario.name} (ses)`, async t => { ... });
       test(`${scenario.name} (node parity)`, async t => { ... });
     }
     ```
   - Delete the now-empty `_cycle-rename-tdz-assertions.js`
     (or repurpose as just exports if any external reader
     still needs it; probably none).
   - Delete the now-unused
     `cycle-rename-tdz-matrix-node-parity.test.js`.
4. **Run** `corepack yarn workspace @endo/compartment-mapper test`
   to confirm all scenarios still pass on both SES and Node
   sides.
5. **Run pre-push-gates** in `project/`.
6. **Commit**:
   `test(compartment-mapper): merge cycle-rename-tdz SES+Node
   parity tests into single module per kriskowal review`.
   One commit.
7. **Push** to `fix/issue-59-star-export-cycle` (append push).
8. **Reply on the review** (top-level comment on #379 if
   review-replies endpoint unavailable) at-mentioning
   `@kriskowal` summarizing the consolidation shape.
9. **Re-request review** from kriskowal.

## Authorizations

- **Push commits** to `fix/issue-59-star-export-cycle`
  (append push only).
- **Top-level comment** on PR #379.
- **Re-request review** from kriskowal.

## Out of scope

- Do NOT change test assertions or fixture data.
- Do NOT rebase or force-push.
- Do NOT amend prior commits.

## Deliverable

A `result` entry under `journal/entries/2026/06/14/` naming:

- Pre/post branch tip SHAs.
- The consolidated file shape choice (single file vs
  per-scenario; with rationale).
- File-by-file change summary (which files merged, which
  deleted).
- Test result.
- pre-push-gates result.
- The reply URL.
- Re-request-review URL/status.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator.
