Implemented and pushed commit `f866574b0a`, stacked on PR #1568’s frozen branch.

Opened draft PR #1569:
https://github.com/endojs/endo-but-for-bots/pull/1569

Changes:
- Added structured `Git.merge()` results for up-to-date, fast-forward, merged, and conflict outcomes.
- Added `Git.mergeText()` for porcelain output compatibility.
- Added authority-bearing conflict entries, index-stage OIDs, and merge/diff3/zdiff3 marker styles.
- Updated guards, types, generated declarations, help, design notes, tests, and changesets.

Validation:
- Affected package lint, tests, and type checks pass.
- Root TypeScript and documentation builds pass.
- Repository pre-push gates pass.
- Regression test was mutation-checked.
- Broader validation encountered documented pre-existing workflow, hardened262 baseline, and daemon test-runner issues.

Follow-up Phase 7 work remains for structured rebase, structured stash operations, and read-only type narrowing.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-git-next-steps-structured-merge.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 4813s

<!-- garden-usage-end -->
