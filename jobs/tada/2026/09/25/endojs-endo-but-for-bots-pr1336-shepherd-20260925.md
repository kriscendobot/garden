**Shepherd report: endojs/endo-but-for-bots#1336, head `cbadcf336e`**

CI is green and the gauntlet is running again at panel iteration 4. I did not change any code and did not un-draft the PR.

**Classification: a flake that was already on `llm` (the base), not caused by this PR.**
- The failure is `test (22.x, macos-15)`, in `@endo/daemon` `daemon-teardown › an orphaned daemon shuts itself down instead of lingering`. The check that fails is "daemon recorded its pid before its launcher exited" (`daemon-teardown.test.js:196`).
- This PR doesn't touch the test or anything in the daemon except one `exports` entry in `package.json`. The changes since the last passing head `4ff416dd32` don't touch `packages/daemon` at all.
- The exact same check also failed on macOS on unrelated branches:
  - `codex/thixotrope-daemon-features`: two runs, 35947379869 and 35978844449, both on 22.x.
  - `build/registry-host-formula-migration-revive`: run 35778508869, on 24.x.
- The test was added on `llm` by #1309 (`db664fa119`, 2026-09-22). It is a pre-existing macOS flake in that test, so I did not change the test in this PR.

**What I did:**
1. Re-ran the failed job in CI run 36075334764. Attempt 3 passed, and every required check on `cbadcf336e` is now green.
2. Resumed the gauntlet with `/home/kris/garden/scripts/jobs/gauntlet.sh --resume-from-stage endojs-endo-but-for-bots-pr1336-gauntlet panel --iteration 4`. The job's path `/home/kris/garden2/...` doesn't exist on this host. It returned rc=0, and on `journal2` the gauntlet record now shows `iteration: 4` and `current_child: endojs-endo-but-for-bots-pr1336-gauntlet-panel-4`, with that job in `jobs/todo/`.

**Follow-up (not done here):** the macOS flake in the orphaned-daemon test needs a fix on `llm` so it stops failing unrelated PRs. The fixer's theory is that the pid file isn't written yet when the launcher exits. The fix could have the launcher wait for `endo.pid` before exiting, or have the test poll for the pid file instead of reading it once. I suggest a separate fix job against `llm`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1336-shepherd-20260925.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1483965 cached reads)
- Output: 6672 tokens
- Cost: $0.9747529999999999
- Wall-clock: 2264s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
