**Fix round 3 for kriscendobot/minion.town PR #163: all must-fix items from panel round 3 are applied, pushed, and CI is green.**

When I started, the PR head had already moved to `0a181cc`. That was a fix from the older, undated gauntlet (`kriscendobot-minion.town-pr163-gauntlet`), addressing its round-2 findings. I built on top of it. Commit `4d5fd6f` was pushed with `safe-push-pr-head.sh` and only adds to the branch (`0a181cc..4d5fd6f`).

**What changed, by reviewer seat**
- **saboteur:**
  - A **failed** caddy unit now fails the run instead of being treated as a fresh box. A caddy that has never started is still skipped, and one that is activating or reloading is now checked.
  - After a restart, a bounded poll (`CADDY_ENVIRONMENT_RESTART_WAIT`, default 30s) replaces the fixed `sleep 2`.
- **wire-watcher:** `caddy_environment_in_sync` now returns a new status, 4, when caddy is not running or its environment can't be read. The post-restart error therefore says caddy is missing instead of blaming a token file with no value. Status 3 after a restart now names both causes.
- **corner-prober:**
  - Concurrent runs now take a `flock` (`CADDY_ENVIRONMENT_LOCK`), so overlapping deploys restart caddy once. I checked that the new concurrency test fails when the lock is removed.
  - Added tests for two stale tokens at once and for a value containing a newline.
- **fast-checker:** "the token is never printed" is now checked with `fc.assert` over arbitrary token values.
- **archivist:** the cross-reference already resolved, since the heading sits under `## Caddy config discipline`. The scripts now quote the heading exactly.
- **Docs:** `DEPLOYMENT.md` now describes the poll, the lock, and how a failed unit is handled.

**Tests**
- `test/caddy-environment-sync.test.ts`: 31 of 31 pass.
- Full vitest suite: one failure, `test/git-remote/capability.test.ts`. It is an existing failure caused by this host's environment, not by this PR.
- `shellcheck` and `bash -n` are clean.
- Nothing has been tested against the live box.

I posted a fix-round summary comment on the PR (issuecomment-6006712068). `ci-wait-merge.sh --no-merge` returned 0, with 3 of 3 checks green.

**Follow-up:** the driver still has to post panel round 4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr163-gauntlet-20261005-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1457789 cached reads)
- Output: 18754 tokens
- Cost: $1.3761978000000001
- Wall-clock: 584s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
