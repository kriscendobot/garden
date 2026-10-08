The clean stage is done for kriscendobot/minion.town PR #171. I pushed one test-only commit, and CI is green on the new head (`ffad4c47f6a`).

**What I did**
- **Starting point:** CI was already green at the old head `2bd839e`, but the coverage pass had not been run, so I ran it instead of skipping the stage. The PR is stacked on `feat/prod-objectives-probe-55299f0`, so I only looked at the PR's own commit.
- **Coverage:** I ran `node --test --experimental-test-coverage` on `deploy/probe/prod-objectives.mjs`. The checks that compare production against the tracked Claude release had four untested failure cases: version mismatch, binary digest mismatch, signing-key fingerprint mismatch, and wrong manifest owner. The new `readRootCanaryBearer` also had no test for its "skip when not configured" and "reject a relative path" cases.
- **Change:** I added assertions for all of those to `deploy/probe/prod-objectives.test.mjs` (commit `ffad4c4`, "test(probe): cover the remaining Claude harness pin checks") and pushed it with `safe-push-pr-head.sh`.
- **Result:** 25/25 tests pass. Line coverage went from 71.0% to 72.5% and branch coverage from 87.1% to 88.9%.
- **What stays uncovered:** only the code that calls live services (SSM, HTTPS, MCP sessions) and the `main` entry point. It can't run in a unit test.
- **Dead code:** the change orphaned nothing, so there was nothing to remove.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0. `test`, `Claude harness (amd64)` and `Claude harness (arm64)` all succeeded on `ffad4c4`.

**Follow-ups**
- Prettier reports style issues in the test file, but it did that before my edit too. The repo has no Prettier config and no Prettier check in CI, so I left the formatting alone.
- The PR is still a draft. The next stages are the panel review, the fix loop, and un-drafting.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr171-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (993346 cached reads)
- Output: 5563 tokens
- Cost: $0.7557052000000001
- Wall-clock: 376s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
