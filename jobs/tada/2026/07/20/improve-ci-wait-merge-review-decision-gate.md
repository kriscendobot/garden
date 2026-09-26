Done. Pushed to `main2`.

## Completion report

**Job:** Add a review-decision gate to the conductor's CI-wait-then-merge spine so a maintainer `CHANGES_REQUESTED` review that lands during the CI wait is never merged over.

**What changed** (`scripts/jobs/gardening/ci-wait-merge.sh`):
- Extended the pre-merge PR read: `gh pr view --json` now also requests `reviewDecision` alongside `state,mergeable,statusCheckRollup`. `read_rollup` extracts it (`.reviewDecision // ""`) and appends it as a fifth pipe-delimited field; the loop's `IFS='|' read` now binds it to `$review`.
- Added a deterministic guard in the green-and-terminal block, placed **after** the `--no-merge` early return (so probes are unaffected) and **before** `gh pr merge`: if `reviewDecision == "CHANGES_REQUESTED"`, it alerts the maintainer via the existing `alert_maintainer` path (dedup key `changes-requested-<repo>-<pr>`) and exits `1` — leaving the merge job claimable rather than completed-merged.
- Keyed off `reviewDecision` (GitHub's rollup) per the spec, so once the review is dismissed/superseded and the decision clears to `APPROVED`/`REVIEW_REQUIRED`, a later re-enqueued tick merges cleanly. No dependence on a stale/dismissed review.
- Updated the header behaviour notes and the exit-code contract (exit 1 now also covers `reviewDecision=CHANGES_REQUESTED`).

**Tests** (`scripts/jobs/test/ci-wait-merge-test.sh`):
- Added `GREEN_CR` fixture and **T11**: green CI + `reviewDecision=CHANGES_REQUESTED` → exit 1, merge never called. Existing fixtures omit `reviewDecision`, so `// ""` leaves T1–T10 merging as before.
- Full suite: **PASS=22 FAIL=0**. `bash -n` clean; shellcheck shows only pre-existing warnings (sourced-file SC1091, `GARDEN_TAG` SC2034), none introduced by this change.

**Follow-ups:** none. The gate closes the minion.town#7 race for every checkless/own-fork repo without branch protection.
