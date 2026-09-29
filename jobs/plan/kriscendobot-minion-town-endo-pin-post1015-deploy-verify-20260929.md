---
gate: blocked-failed
blocked_failed_reason: blocker 'conduct-kriscendobot-minion-town-pr139-20260929' completed but declined its gated outcome; held for a human decision
blocked_on: conduct-kriscendobot-minion-town-pr139-20260929
priority: high
role: builder
posted_by: producer
posted_at: 2026-09-29T08:05:52Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Verify the minion.town CD deploy advances the Endo daemon to 1706e63 (after #139 merges)

Successor to `kriscendobot-minion-town-endo-pin-post1015-20260929`, which handed off to this job. That job advanced
minion.town's Endo pin past https://github.com/endojs/endo-but-for-bots/pull/1015 in
https://github.com/kriscendobot/minion.town/pull/138 (merged as `47d0c0b`, pin `1706e63247fb2c23b767f24fa1bd4b35d575089e`).
Its CD deploy (run 36531062447) crash-looped the endo daemon. The cause was a deploy-script bug, not the pin: the
upgrade preflight's `endo list` probe auto-started a stray daemon on 127.0.0.1:8920. Production was restored by hand
to the old pin `f9cbcfc426` at about 06:33Z. The fix is https://github.com/kriscendobot/minion.town/pull/139,
which is being merged by conductor job `conduct-kriscendobot-minion-town-pr139-20260929`.

Precondition: #139 is MERGED on `main`. If it was closed without merging, message the maintainer and stop.

1. Find the `deploy (continuous deployment)` run for #139's merge SHA
   (`gh run list -R kriscendobot/minion.town --commit <sha>`). If it did not run, dispatch it with
   `gh workflow run deploy.yml -R kriscendobot/minion.town -f deploy_target=all`. Wait for it in the foreground.
2. Verify it read-only over SSM (`deploy/aws/scripts/common.sh` `ssm_run`, instance i-0380cd68b90020fad, us-west-1):
   `/opt/endo/ENDO_COMMIT` is `1706e63…`, `systemctl is-active endo-daemon` is active with a stable
   `NRestarts` over a few minutes, and no endo-daemon-owned `manager-node.js` process runs outside
   `endo-daemon.service`. Also confirm that minion-mcp is active.
   Do NOT probe with a bare `endo list`: it auto-starts a daemon when the socket does not answer.
   Use a connect check first, as `endo_probe` in `deploy-endo-daemon.sh` does.
3. If the daemon crash-loops, first restore production. Kill any stray endo process outside the unit cgroup, and
   use `deploy/aws/scripts/rollback-endo-daemon.sh` if needed. Then revert the pin in all three sites
   (`.github/workflows/test.yml`, `deploy/aws/scripts/deploy-endo-daemon.sh` `ENDO_COMMIT`,
   `src/endo/captp-client.ts` `PINNED_ENDO_COMMIT`) back to `f9cbcfc426f726858a671bcb09f7c2c774cc659e`, following the
   #111 pattern, through `ensure-pr.sh`, and have the conductor merge it. Then emit `<<<GARDEN-ORCHESTRATION-FAILED>>>`.
4. Report the deploy run, the box's pin, and the health evidence.
