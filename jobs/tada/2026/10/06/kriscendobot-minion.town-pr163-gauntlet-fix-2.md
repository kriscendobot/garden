## Gauntlet FIX round 2: kriscendobot/minion.town#163

I fixed the four must-fix items from the round-2 panel (review 5422404081) and pushed the fix to the PR head. CI is green on all 3 checks (rc 0).

**Fixes**
- **migrator:** The two secret scripts, `deploy-account-endpoint-secret.sh` and `deploy-billing-secrets.sh`, no longer abort on a caddy check failure before `minion-mcp` restarts. They record the result (`|| caddy_status=$?`), restart `minion-mcp`, then fail the run with a FATAL message if caddy's check failed. This brings back the decoupling the old `reload caddy || true` gave.
- **assessor:** `caddy_environment_ensure` now checks `caddy validate`, `systemctl restart caddy` and `systemctl is-active --quiet caddy` each with its own FATAL message. A failed validate never restarts caddy, and a caddy that doesn't come back is reported as inactive, not wrongly blamed on a "file defines no value". This also covers wire-watcher's round-3 note about that misleading message.
- **stylist:** Renamed `pid` to `process_id` in `caddy-environment-sync.sh`.
- **archivist:** `DEPLOYMENT.md` "Reload vs restart" now names `/etc/caddy/account.env` and `/etc/caddy/billing.env` as the EnvironmentFiles, separate from the helper script. It also documents that `minion-mcp` restarts before the run fails.

**New tests** in `test/caddy-environment-sync.test.ts`:
- a failed validate does not restart caddy, even when the caller isn't under `set -e`;
- a caddy that stays inactive after the restart is named as such;
- a `set -e` caller keeps going past a caddy failure and still exits 1;
- in both scripts, the `minion-mcp` restart comes before the final caddy check.

Locally, 31/31 tests passed in the two caddy test files, and `bash -n` passed on all deploy scripts.

**Commit:** `0a181cc` ("fix(deploy): keep the app restart independent of caddy's gate-token check"), pushed with `safe-push-pr-head.sh` (`5a9a4b2` → `0a181cc`).

**Follow-ups**
- A second gauntlet, `kriscendobot-minion.town-pr163-gauntlet-20261005`, is also running on this PR and posted its own round-3 panel on the same head. Its unique items are saboteur's request to treat a failed caddy unit differently from a never-started one and to poll after restart instead of a fixed `sleep 2`, and corner-prober's missing-test requests. I didn't apply them. The second gauntlet should probably be retired so only one gauntlet runs on the PR.
- Not addressed, since they were comment-level: packager's note about reformat churn in `test/caddy-account-routes.test.ts`, and stylist's `want`/`got` naming suggestion.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr163-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (1093429 cached reads)
- Output: 9778 tokens
- Cost: $1.0566377999999998
- Wall-clock: 714s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
