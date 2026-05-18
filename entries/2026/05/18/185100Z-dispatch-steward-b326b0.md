---
ts: 2026-05-18T18:51:00Z
kind: dispatch
role: steward
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 280
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/280#pullrequestreview-4312821322
  - entries/2026/05/18/042532Z-result-fixer-190fbc.md
---

# Dispatch: fixer preserves historical record on async_hooks Node-20 compatibility (per kriskowal review)

Dispatch root: `dispatches/fixer--b326b0/`. Project worktree on `endojs/endo-but-for-bots@chore/drop-node-20-ci`.

## The directive

Maintainer kriskowal CHANGES_REQUESTED review on PR #280 (`pullrequestreview-4312821322`, 2026-05-18T18:46:29Z):

> Let's pay off the debt on the async_hooks comment mentioned above.

Inline comment on `.github/workflows/ci.yml:139`:

> Please preserve the historical record on version compatibility.

Context: the earlier fixer dispatch `190fbc` (drop Node 18 + cherry-pick endojs/endo#3084 baseline) dropped the `test-async-hooks` matrix entries for 18 and 20 along with the commentary about which Node-20 patch versions were SES-viable. The maintainer wants that historical record preserved — the commentary documents specific compatibility constraints worth keeping even after the version itself is dropped.

## Per-action authorization

- Edit `.github/workflows/ci.yml` (specifically around the `test-async-hooks` matrix area) to restore the historical commentary about Node-20 SES-viable patch versions.
- Push under kriscendobot identity (`--force-with-lease`).
- Optionally post a brief ack comment on PR #280.

## Task

1. Read the current `.github/workflows/ci.yml` to see where the test-async-hooks matrix is now.
2. Recover the prior commentary about Node-20 SES-viable patch versions. Find it via:
   - `git log -p chore/drop-node-20-ci -- .github/workflows/ci.yml | grep -B 20 -A 20 "20.*SES"` (or similar)
   - Or `git show <pre-drop-commit>:.github/workflows/ci.yml | grep -B 5 -A 5 "test-async-hooks"`
   - The commentary was a multi-line comment naming specific Node-20 patch SHAs that were SES-compatible vs not.
3. Re-add the commentary in a form that makes sense post-drop. Options:
   - Restore as a verbatim historical note above the matrix line: "Historical note: Node 20.x was SES-viable on patches X.Y.Z through A.B.C; dropped from the matrix at PR #280 with this commentary preserved."
   - Or place in a comment block at the workflow's top naming the SES-viability constraints by Node major.
   - Fixer's call on the exact placement; preserve the substantive content.
4. Commit with conventional message: `ci: preserve Node 20 SES-viable patch history (per kriskowal review on #280)`.
5. Force-push to `chore/drop-node-20-ci` with lease.
6. Optionally post a brief ack comment on PR #280.

## Out of scope

- No other CI matrix changes.
- No rebase needed unless conflicts surface.
- No comment on endojs/endo#3084.

## Report

≤ 400 words. The recovered historical content (paraphrase), where it was placed in the file, final head SHA, optional ack comment ID, one-line `Self-improvement: ...`.
