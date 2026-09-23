---
ts: 2026-06-15T06:37:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--d78877
prs:
  - repo: endojs/endo-but-for-bots
    pr: 379
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/379
  - https://github.com/endojs/endo-but-for-bots/pull/379#discussion-(kriskowal 2026-06-15T06:35Z)
---

# dispatch: fixer — consolidate *-node-parity test files on PR #379 per kriskowal

Maintainer review on PR #379 (kriskowal CHANGES_REQUESTED, 2026-06-15T06:35:31Z), inline on `packages/compartment-mapper/test/cycle-esm-in-cjs-node-parity.test.js:1`:

> I would, for example, like this module's test to be moved into `cycle-esm-in-cjs.test.js` so that it is evident at a glance that the same test passes both Node.js parity and with Endo. I would like this principled generally to the other new parity tests.

Follow the same consolidation pattern the prior fixer (e79088 / 385fe4) applied to the `cycle-rename-tdz-matrix.test.js` ↔ `cycle-rename-tdz-matrix-node-parity.test.js` pair (now a single module registering both `(ses)` and `(node parity)` tests).

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#379`, OPEN, not draft, reviewDecision CHANGES_REQUESTED, base `master`, head `f87d0eb05`.

## Parity test files to consolidate

Pairs (parity-file → sibling-file to merge into):
- `cycle-cjs-reexporter-node-parity.test.js` → `cycle-cjs-reexporter.test.js`
- `cycle-esm-in-cjs-node-parity.test.js` → `cycle-esm-in-cjs.test.js` (the maintainer's example)
- `cycle-rename-node-parity.test.js` → `cycle-rename.test.js`
- `cycle-rename-unused-node-parity.test.js` → `cycle-rename-unused.test.js`
- `subpath-patterns-node-parity.test.js` → `subpath-patterns.test.js`

For each pair, the prior consolidation pattern (`cycle-rename-tdz-matrix.test.js`) is:
- Each test in the matrix registers `(ses)` (under SES lockdown) AND `(node parity)` (direct Node import) back-to-back per scenario.
- One module, one table-driven loop, two test titles per scenario row.

## Task

In your `project/` worktree at `f87d0eb05`:

1. Read the pattern at `packages/compartment-mapper/test/cycle-rename-tdz-matrix.test.js` (from commit ca17e11e4) for the canonical structure.
2. For each pair:
   - Read both files to understand the assertions.
   - Verify the assertions are identical (typical for parity).
   - Merge the parity file's `(node parity)` test registration into the sibling's body alongside the existing `(ses)` test.
   - Delete the parity file.
3. Run `corepack yarn workspace @endo/compartment-mapper test` to confirm everything passes.
4. Run pre-push-gates.
5. Commit per-pair if helpful, or one cohesive commit:
   - `test(compartment-mapper): consolidate cycle-esm-in-cjs node-parity into single module per kriskowal review`
   - (similar for other pairs)
6. Push to `fix/issue-59-star-export-cycle` (append only).
7. Top-level comment on PR #379 at-mentioning @kriskowal with per-pair resolution + SHAs.
8. Re-request review from kriskowal.

## Authorizations

- Push commits (append only).
- Top-level comment + re-request review.

## Out of scope

- Do NOT touch upstream endojs/endo.
- Do NOT pursue boneskull's nits (already addressed).

## Deliverable

A `result` entry under `journal/entries/2026/06/15/` naming:

- Pre/post head SHAs.
- Per-pair consolidation mapping (files merged + deleted) + commit SHAs.
- Test result.
- pre-push-gates result.
- PR #379 comment URL + re-request-review URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: liaison`.

End your turn with a concise summary back to the orchestrator.
