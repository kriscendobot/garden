## Completion report: fix-comment-watcher-test-cooldown-isolation

**Cause:** `common.sh` puts the gh-api cooldown under `$GARDEN_ROOT/.garden-state/gh-api-cooldown` unless `GARDEN_API_COOLDOWN_DIR` is set. Gardeners export `GARDEN_ROOT` as the deployed root. So when `comment-watcher-test.sh` ran on its own from a job worktree, any case that didn't set its own cooldown directory (the RATE primary-quota cases) wrote its latch into the live host's `marker`. That is what blocked the host's `gh` calls on 2026-10-06 around 16:27Z.

**Fix (main2 `6ed3c51a989`):**
- **New helper `scripts/jobs/test/test-live-cooldown-guard.sh`:**
  - `live_cooldown_guard_begin <tmp-root>` records the current state of the live `marker` and `marker-graphql`. It checks both the inherited `GARDEN_ROOT` and the root the script itself sits in. It then exports `GARDEN_API_COOLDOWN_DIR=<tmp-root>/gh-api-cooldown`, so every case without its own directory writes to the temp tree.
  - `live_cooldown_guard_end` fails, and prints a diff, if any live marker changed during the suite.
- **Where it's wired in:** `comment-watcher-test.sh`, `issue-inbox-watcher-test.sh` and `mention-watcher-test.sh` call `begin` right after the temp root is created. Each also runs a final `LIVE-COOLDOWN` assertion before its result line, so the suite fails if it ever latches the live fleet again.

**Verification:**
- I ran all three suites with `GARDEN_ROOT` pointed at a throwaway stand-in for the live root, which reproduces the incident's conditions:
  - comment-watcher: 472 passed, 0 failed
  - issue-inbox: 65 passed, 0 failed
  - mention-watcher: 51 passed, 0 failed
- The stand-in's `.garden-state` stayed empty in every run.
- I also tested the helper on its own: it reports clean when nothing changes, and returns rc 1 with a diff after a write to the live marker.

**Follow-ups and limits:**
- If the real fleet sets a live latch while a suite is running, the guard will report a false failure. That should be rare, since a primary-quota latch means `gh` is already blocked.
- I did not add the guard to suites that rely on the cooldown path derived from a fixture `GARDEN_ROOT` (api-cooldown, ci-watcher, dependabot-watcher, approval-reconciler, triager-pacing). Forcing the directory there would break their assertions, and their fixture roots are already isolated.
- Other suites that already set their own cooldown directory at the top (gh-api-retry, mirror-closer, receipt-watcher) were left unchanged.
- A possible further step: a guard inside `common.sh` that refuses to write the live cooldown from a test context. I didn't do it because `common.sh` can't reliably tell which root is the live one.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-comment-watcher-test-cooldown-isolation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1182659 cached reads)
- Output: 11534 tokens
- Cost: $1.0239878
- Wall-clock: 568s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
