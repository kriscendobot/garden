No code change was needed: the fix this job asks for is already on `origin/main2` in commit `434d5402956` ("fix(common): treat reclone_clone rc=124/137 timeouts as a transient skip"). This job duplicates that earlier self-heal.

- **The fix is in place.** In `scripts/jobs/common.sh:4309-4325`, `reclone_clone` now saves the `bounded_clone` exit code as `rc`. It exits `GARDEN_OFFLINE_RC` (EX_TEMPFAIL) when `rc` is 124 or 137 or when `_fetch_stderr_is_offline "$GARDEN_CLONE_STDERR"` matches, and only calls `die` otherwise. This is the pattern `sync_clone` already uses.
- **The running checkout has it too.** `/home/kris/garden2/scripts/jobs/common.sh:4321` has the same condition, so a bare 45s clone timeout now skips the tick quietly instead of ending in FATAL.
- **Unit state.** `garden-comment-watcher@endojs-endo-but-for-bots` on this host is inactive because its start condition wasn't met (`Result: exec-condition`), not because of a crash. That fits the watcher being a leader-only service on a follower host.

Nothing was committed or pushed, and there are no follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-comment-watcher-endojs-endo-but-for-bots-reclone-timeout-not-offline.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (149101 cached reads)
- Output: 1153 tokens
- Cost: $0.36209620000000003
- Wall-clock: 17s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
