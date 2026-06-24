---
ts: 2026-05-14T22:19:10Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 109
    role: target
---

# Dispatch: fixer addresses test-ocapn-guile-interop failure on #109 + shepherds to green

Dispatch root: `dispatches/fixer--4c9f0b/`. Project worktree on `endojs/endo-but-for-bots@feat/syrups-package` (current head `894510bec`).

Maintainer directive at [#109#issuecomment-4455143625](https://github.com/endojs/endo-but-for-bots/pull/109#issuecomment-4455143625) (2026-05-14T22:11:33Z): *"Please fix and shepherd."*

CI state on `894510bec`: 26 SUCCESS / 1 FAILURE. The failure is `test-ocapn-guile-interop` (workflow "OCapN Guile interop"), failed at 2026-05-14T22:00:50Z, started at 21:51:36Z. Likely fallout from the recent syrup-frame rename: the prior fixer (`c690c4`) renamed `makeSyrups*` → `makeSyrupFrame*` in the JS side; if the Guile-interop fixture or the wire-format-naming side wasn't updated to match, the cross-language test fails.

## Per-action authorization

Standing on endo-but-for-bots: push, comment if needed.

## Task

Per the maintainer's "fix and shepherd" vocabulary: address the failing job + drive CI to green.

1. **Read the failing job's log** (`gh run view --log-failed`) for the actions/runs ID in the failure detail URL (`https://github.com/endojs/endo-but-for-bots/actions/runs/25887739382/job/76083514673`). Capture the actual failure-message line.

2. **Diagnose**. Most likely shape: a Guile-side fixture or the OCapN wire-format name (e.g., a Python test harness, a Guile test fixture, or a name that crossed the JS/Guile boundary) was not updated when `makeSyrups*` → `makeSyrupFrame*` landed. Verify by reading the Guile-interop test setup files in the project.

3. **Fix.** Apply the minimal change that addresses the failure. Commit shape: one commit per logical concern. If the fix is "update the Guile-side fixture to match the new JS symbol", that's one commit.

4. **Shepherd CI to green.** Push; watch `gh pr checks 109 --watch`; if a transient failure surfaces (e.g., known macOS-15 flake), document inline. The goal is `test-ocapn-guile-interop` SUCCESS + all other checks SUCCESS.

5. **Standing comment authorization** applies; if it helps the maintainer to see what was fixed, post a one-line summary comment on #109. Optional.

## Out of scope

- No new feature work on #109's substance.
- No re-name (the syrup-frame rename is settled per the prior fixer's commits).
- No comment on upstream `endojs/endo#3256` (the boatman re-ferries later).
- No un-draft (PR is already non-draft; this is a fixer-after-maintainer-review cycle).

## Report

≤ 250 words: the failure's root cause one-line, the fix's shape one-line, head SHA after push, CI status (green or remaining flake), one-line `Self-improvement: ...`.
