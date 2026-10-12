I went with the second option: `ci-wait-merge.sh` now falls back to the Actions runs API when the rollup read gets a 403. The token itself is unchanged, since a PAT's permissions can only be changed by a person in GitHub settings. The fix is pushed to `main2` as `563e6db8cbe`, but I have not run it on oros-studio-garden-ce242c49 itself. That host picks it up on its next rolling deploy.

**What changed in `scripts/jobs/gardening/ci-wait-merge.sh`:**
- **403 handling:** a 403 on `statusCheckRollup` ("Resource not accessible by personal access token") no longer counts as a passing hiccup that ends in rc 4. A secondary-rate-limit 403 still does, because it clears on its own.
- **Fallback:** the script re-reads the PR's state, mergeable, reviewDecision and head, then builds the check list from `repos/<r>/actions/runs?head_sha=<head>`, one entry per workflow run. Green, red and pending are then decided the same way as before. The failure printout and the billing-block check use the same path.
- **When the fallback can't be used:** if the Actions runs read also gets a 403, or the PR is in a delegated-merge mode, the script exits 1 with a `ci-read-forbidden` line and alerts the maintainer. It never returns rc 4 for this. Delegated merges are excluded because the fallback only sees Actions runs, not commit statuses or non-Actions checks.
- The header and the exit-code list document the new path.

**Tests:**
- I added T41–T45 to `scripts/jobs/test/ci-wait-merge-test.sh`: 403 with green runs (both the no-merge and merge modes), 403 with a red run (exit 3), 403 with a run still in progress (keeps waiting), both reads forbidden (exit 1), and a rate-limit 403 (keeps retrying).
- The suite gives 105 passes and 2 failures. Both failures are T8, which fails the same way on the old script before my change, so it's an existing problem.
- `ci-wait-merge-ratchet-test.py` and `ci-wait-merge-screening-test.py` pass, and shellcheck is clean.
- Live check from endolin: I ran the script against the real kriscendobot/minion.town#93 with a `gh` wrapper that forces the 403. It fell back to the runs API, saw 1 run (`test (typecheck + vitest)` = SUCCESS on `58ef7714f35`) and exited 0 with CI GREEN.

**Not changed:** `assert-panel-head-fresh.sh` doesn't read check status at all; it only reads `headRefOid,state` and the journal. So the pr93 handoff failure (freshness rc=1) has a separate cause. Its documented failure codes are 10, 11, 12 and 2, so rc=1 points to an unexpected exit, or to an older copy of the script deployed on that host. The sensor's own output didn't make it into the capture.

**Follow-ups:**
- After oros-studio deploys `563e6db8cbe`, re-run or resume the pr93 and pr180 gauntlet stages.
- Optionally, grant that host's PAT checks:read and statuses:read, so its view includes commit statuses and non-Actions checks, and so delegated merges work on that host.
- The unexplained freshness rc=1 may need its own job.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `c49849aa03255e41721b33a176e933aec1ce7bee`; this job presented `58ef7714f35a406f401397b75e195ad1d9bddf87`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-studio-ci-rollup-403-20261012.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1360564 cached reads)
- Output: 18932 tokens
- Cost: $1.4708328000000002
- Wall-clock: 273s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
