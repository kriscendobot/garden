# Clean stage: endojs/endo-but-for-bots PR #1431 — CI green after a re-trigger

CI is green on the new head `1286f427b5` (`ci-wait-merge.sh` returned rc 0: 31 checks, 0 failed). The clean stage is done.

**Coverage pass:** nothing to do. The PR changes one file, `designs/hardened-text-codecs-shim.md`, so there is no code to cover and no dead code to remove.

**What went wrong with CI at `c3ab267ef9`:** two jobs had failed, `format-ironhorse` (its "Check row-schema history and version transitions" step) and `test-ironhorse-oracle`. Neither could be caused by a doc edit.
- **Cause:** the CI run was created at 15:25:53, four seconds before the PR's base was moved to `llm-9a14ddf` at 15:25:57. Its event payload still held the old base from 2026-10-07. So change detection (`scripts/ci-changes.py`) compared weeks of `llm` history against the head and selected every job, including the ironhorse ones.
- **Check:** run locally on the real diff, the same detector selects only `lint`.
- **Why a rerun wouldn't help:** `ci.yml` only triggers on PR `opened`/`synchronize`/`reopened`, so moving the base never re-ran CI. A rerun would reuse the stale payload.
- **I couldn't read the failure logs:** GitHub returned a 503 ("Egress is over the account limit") for them.

**What changed:** I re-stamped the single commit with the same tree, message and author, and only a new committer date. I pushed it with `safe-push-pr-head.sh --mode rewrite` (`c3ab267ef9 → 1286f427b5`) to get a fresh `synchronize` event with the correct base. Change detection then selected only `lint`. Everything else that ran passed (`zizmor`, the `android` workflow, the change detectors), and the rest were correctly skipped.

**Follow-ups:**
- The PR head SHA no longer matches the `c3ab267ef93b` in the gauntlet's name. The diff is identical, so later stages should work from the PR as it is now.
- Possible garden improvement: any workflow that retargets a PR's base (weave or pin) right after pushing can hit this race. The run gets created against the old base and runs the full suite.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1431-gauntlet-20261029-c3ab267ef93b-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1652978 cached reads)
- Output: 8850 tokens
- Cost: $1.0300516
- Wall-clock: 955s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
