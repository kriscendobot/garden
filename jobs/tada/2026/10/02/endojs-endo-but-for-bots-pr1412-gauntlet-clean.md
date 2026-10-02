The clean stage is finished, but CI isn't green yet: one check, `test-ocapn-guile-interop`, was still in progress on head `715df32609` when I rechecked. That makes this stage still-pending, so the driver should re-post it on a fresh budget.

**Coverage pass.** The two touched packages are `packages/inference` and `packages/claude`:
- **`packages/inference`:** 99.8% of lines were already covered.
- **`packages/claude`:** I added tests for the three uncovered error paths in the new files. In both backends, a credential source that fails now returns `unavailable` and starts no process or query. In the stream reducer, an assistant event with no message id counts as its own turn.
- **Coverage gain:** `cli-backend.js` went from 96.5% to 98.2% of lines, `sdk-backend.js` from 92.3% to 95.2%, and `stream-reducer.js` from 98.5% to 100%.
- **Dead code:** I found none that the change orphaned.

The change is commit `715df32609`, test files only. Locally, all 122 tests pass, ESLint reports no errors, Prettier is clean, and both the package and repo-root `tsc` are clean. I pushed it with `safe-push-pr-head.sh`.

**CI on `715df32609`:** 32 of 33 checks pass. The exception is `test-ocapn-guile-interop`, which is an infrastructure problem, not this PR:
- **First run:** it hung for 41 minutes in its "Resolve Guix module paths" step and was cancelled, so `ci-wait-merge` returned rc 3.
- **Rerun:** I reran that one job once. It hung in the same step, and `ci-wait-merge` reached its 2400s deadline with rc 4.
- **Repo-wide:** other branches' guile-interop jobs were stuck in that step at the same time.

**Follow-up:** the PR itself needs no further changes. If the guile-interop job ends cancelled again, it will need one more rerun once the Guix step stops hanging.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1412-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (2802772 cached reads)
- Output: 13448 tokens
- Cost: $2.832433000000001
- Wall-clock: 5599s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
