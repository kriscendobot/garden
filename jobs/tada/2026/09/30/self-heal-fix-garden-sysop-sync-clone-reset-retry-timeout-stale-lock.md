## Completion report: self-heal-fix-garden-sysop-sync-clone-reset-retry-timeout-stale-lock

The fix is pushed to `main2` as `5ea81b8dc93`. When `sync_clone` has to retry a failed reset and the re-fetch times out, it now skips the tick instead of dying. It also clears the stale `HEAD.lock` a killed git process leaves behind before retrying the reset.

**Changes in `scripts/jobs/common.sh`:**
1. **Re-fetch classification:** after the retry fetch in the reset-retry branch, the re-fetch result is now checked the same way as the function's other fetch sites. An exit code of 124 or 137 (the timeout kill and its SIGKILL escalation), an offline stderr signature, or `journal_bounded_fetch_is_ambiguous_outage` all exit with `$GARDEN_OFFLINE_RC` (75). Before, only the offline signature was checked, so a timed-out fetch fell through to the reset.
2. **Second lock sweep:** `_sweep_stale_git_locks "$dir"` now runs again just before the retry `git reset --hard`. `clone_lock` is still held at that point, so any lock file present was left by a git process this run killed.
3. **`gc.log.lock`:** added to the sweep list. This is safe because the fleet sets `gc.autoDetach=false`, so no background gc can still be running and holding it. Separately, the leftover `gc.log.lock` from 2026-09-29 in the sysop clone gets removed on that clone's next sync once this is deployed.

**New test: `scripts/jobs/test/sync-clone-reset-retry-test.sh`.** It uses a real local bare remote and an injected fetch. The first fetch leaves a `HEAD.lock` behind after the entry sweep, so the first reset fails exactly as in production. Four cases:
- The re-fetch returns 124, and the result is exit 75 with no FATAL.
- The re-fetch returns 137, and the result is exit 75 with no FATAL.
- A leftover `HEAD.lock` appears between the re-fetch and the retry reset; the lock is swept and the reset reaches `origin/journal2`.
- A stale `gc.log.lock` is swept.

With the fix all 4 pass. With the old `common.sh` all 4 fail, and the first three reproduce the incident's exact `cannot lock ref 'HEAD' ... File exists` FATAL.

**Other test runs:**
- `budget-snapshot-outage-reclone-test.sh` passes.
- `receipt-watcher-test.sh` has 2 failures ("fresh-clone outage lost its warning/cooldown" and "empty-stderr prerequisite ... wording").
- `fetch-timeout-test.sh` timed out (exit 124) after SUBTEST 3.

Both of those failed the same way against the old `common.sh`, so this change didn't cause them, and I didn't investigate them further.

**Follow-ups:**
- The two failing tests above (the `receipt-watcher-test.sh` failures and the `fetch-timeout-test.sh` timeout) need their own look.
- The fix only takes effect on each host once the rolling deploy picks up `5ea81b8dc93`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-sysop-sync-clone-reset-retry-timeout-stale-lock.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1179088 cached reads)
- Output: 11318 tokens
- Cost: $1.0304256
- Wall-clock: 1009s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
