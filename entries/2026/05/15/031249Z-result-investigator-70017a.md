---
ts: 2026-05-15T03:12:49Z
kind: result
role: investigator
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    issue: 260
    role: commented
refs:
  - entries/2026/05/15/030128Z-result-investigator-9a5955.md
---

# Result: investigator narrow-down of `test (20.x, macos-15)` same-hash retry-divergence

Dispatch root: `dispatches/investigator--70017a/`. Project worktree on `endojs/endo-but-for-bots@llm` (detached). Issue #260 comment authorization given in dispatch prompt.

## Headline

**N = 0 divergence cases out of M = 2 same-hash double-runs of `test (20.x, macos-15)`** in the 48 h window (2026-05-13T02:42 Z to 2026-05-15T02:42 Z). Both double-runs failed identically on both attempts; no retry flipped the outcome.

## Methodology

Listed every `CI` workflow run completed in the window via `gh run list --limit 500`. 57 unique SHAs, 59 completed runs, 4 with `attempt >= 2`. For each `attempt >= 2` run, pulled `attempts/1/jobs` and `attempts/2/jobs` and located the `test (20.x, macos-15)` record. A pair counts as a true same-hash double-run only when attempt-2's job has distinct `id`, `started_at`, and `completed_at`; otherwise GitHub inherited the attempt-1 record (the job was outside the "rerun failed jobs" scope and was not actually re-executed). Two of the four `attempt >= 2` runs (25829399737, 25890456557) had inherited macos-15 records, so they are not double-runs of the macos-15 job and were excluded.

## The two double-runs

Both on `jcorbin-genie-sandbox`. Both failed both times.

- Run 25870453776, sha `bf5fbc5373`: attempt 1 FAILURE 2026-05-14T16:04:07Z, attempt 2 FAILURE 2026-05-14T18:26:08Z. Signature: `sandbox-slice-mint > mintGenieSlice` (4 sub-tests) + `tools > command > bash/exec: grep with no match`. No divergence.
- Run 25883674333, sha `42e4accb62`: attempt 1 FAILURE 2026-05-14T20:28:18Z, attempt 2 FAILURE 2026-05-14T20:41:47Z. Same signature. No divergence.

These map to Clusters D1 and D2 from the parent survey (entry 030128Z-result-investigator-9a5955.md); the parent survey already verdicted these as PR-side defects (already fixed on a later head). The retry-divergence narrowing confirms determinism: the failure reproduces 4 / 4 attempts across 2 SHAs.

## Recurrence note for the auto-retry policy decision

The two truly macos-only flakes from the parent survey (Clusters A and C, on `feat/migrate-eslint-plugin-import-x` and `chore/eslint-numeric-separators-style`) were *never re-tried at the same hash* in the window. Same-hash retry-divergence evidence for or against an auto-retry policy is therefore unavailable for those branches in this window. The case for the policy still rests on cross-matrix sibling-cell scope (parent survey's headline), not on retry-divergence at the same SHA, of which the window contains zero.

## Files / runs examined

Same window as the parent survey. Job-attempt fetches: runs 25870453776, 25883674333, 25829399737, 25890456557 (each attempts/1 and attempts/2). Per-job log greps for failure signatures on job ids 76023977312, 76048429226, 76069733732, 76071878137. Comment posted at `https://github.com/endojs/endo-but-for-bots/issues/260#issuecomment-4456562761`.

Self-improvement: nothing this time. The narrow-down sharpened the prior survey's claim (cross-matrix scope evidence) by separating it from a claim it does not make (same-hash retry divergence evidence). One sentence worth adding to `skills/ci-status-summary/SKILL.md` someday if a similar question recurs: "same-hash retry divergence is a stronger flake signal than cross-matrix sibling-cell scope, but it requires the job to actually have been rerun; GitHub's `attempt` field on the workflow run is misleading because failed-jobs reruns inherit the unrun jobs' attempt-1 records into attempt-2." Not strong enough to land on its own; noting for the corpus.
