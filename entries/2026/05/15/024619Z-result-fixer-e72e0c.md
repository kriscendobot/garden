---
ts: 2026-05-15T02:46:19Z
kind: result
role: fixer
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 244
    role: target
  - repo: endojs/endo
    pr: 3263
    role: source
refs:
  - entries/2026/05/15/024311Z-dispatch-liaison-e72e0c.md
---

# Result: fixer synced #244 from upstream #3263 (reset)

Dispatch root: `dispatches/fixer--e72e0c/`. Source dispatch: `024311Z-dispatch-liaison-e72e0c.md`.

## Sync shape: reset

Bots-side tip `746beaf4` and upstream tip `b583f9259` had **identical trees** (`git diff 746beaf4 b583f9259` returned empty). The two histories diverged only in commit shape:

- bots-side (3 commits, kriscendobot-authored): `50dcec6d6` eslint-plugin → `52a6844ff` yarn.lock → `746beaf4` migrate (squashed prettier-fix in).
- upstream (4 commits, kriskowal-authored): `6f19761da` eslint-plugin → `180e184b2` yarn.lock → `7faa80774` migrate → `b583f9259` prettier --write on autofix-touched.

The bots-side carried no commits that upstream lacked content-wise, so the right shape is a clean reset to upstream (preserves upstream's commit boundaries so future ferries map 1:1).

## Commits absorbed from upstream (kriskowal-authored)

- `6f19761da chore(eslint-plugin): require underscore-delimited groups in numeric literals`
- `180e184b2 chore: Update yarn.lock`
- `7faa80774 chore: migrate numeric literals to underscore-delimited grouping`
- `b583f9259 chore: prettier --write on autofix-touched files`

## Bot-side commits preserved

None. The bots-side kriscendobot squash (`746beaf4`) and upstream's 4-commit shape produced identical trees, so resetting loses no content.

## Push

`git push --force-with-lease=...:746beaf4... origin HEAD:refs/heads/chore/eslint-numeric-separators-style-master` succeeded: `746beaf43...b583f9259 (forced update)`. New head SHA: `b583f9259`.

## CI status (snapshot at push+~30s)

28 check-runs on `b583f9259`: 2 success (`build`, `zizmor`), 16 in-progress, 10 queued, 0 failures. `test-ocapn-guile-interop` (named gating signal) is in-progress. Per dispatch self-improvement, not blocking on full convergence; the steward/shepherd carries it forward.

PR #244 remains `OPEN`, draft (matches pre-sync state; the dispatch's "non-draft" note was inaccurate but the dispatch also says "No un-draft", so leaving alone is right).

Self-improvement: nothing this time.
