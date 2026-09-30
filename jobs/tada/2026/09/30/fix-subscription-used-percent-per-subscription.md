I fixed the claim gate so each Claude subscription reads only its own hosts' utilization, and pushed it direct to `main2` as commit `3d65d01cc06`.

**What changed**
- **New helper `subscription_ledger_hosts`** (`scripts/jobs/usage-meter.sh`): returns the hosts that `config/subscription-mapping` assigns to a subscription with worker kind `monk`, `gardener` or `*`.
- **`subscription_used_percent`**: its primary reading, the seven-day utilization rows in `usage/*.jsonl`, now counts only rows from those hosts. Previously it took the newest row from any host.
  - claude-endolin1 now reads endolin-garden-ece02cb4's rows and claude-endolin2 reads endolin-garden2-5bcdff64's.
  - A subscription with no mapped Claude hosts no longer reads the Claude figures at all. This also fixes a second leak: codex-endolin, which only has cleric workers, was reading the Claude utilization.
  - A journal with no mapping file keeps the old unfiltered read, so hosts mid rolling deploy still work.
  - The fallbacks are unchanged: live `used_percent` snapshots and manual checkpoints.
  - The percent is now rounded to two decimals; `0.57*100` was printing `56.99999999999999`. Callers compare numerically, so this doesn't affect them.
- **New regression test** `scripts/jobs/test/subscription-used-percent-per-subscription-test.sh`, 7 checks. Two subscriptions on two hosts report 73% and 57%, with the 57% row arriving last; each must read its own figure. It also covers a subscription with no rows, a cleric-only subscription, the live-snapshot fallback not crossing subscriptions, and the no-mapping case. It passes 7/7 with the fix and fails 6 of 7 without it.
- **`claude-stream-signal-test.sh`**: its test ledger row had no `host`, so I added one to match real rows, which always carry `host`.

**Tests**
The new test, `claude-stream-signal`, `budget-live-percent-label`, `quota-panel` and `augment-usage-session-delta` pass. Several other tests that load `usage-meter.sh` fail, but they fail the same way on a clean copy of the old `origin/main2`, so the failures were already there:
- `live-budget-admission`: same 3 failures in both copies.
- `botany-worktree-scripts-disabled`, `monk-claude-tree-reap`, `kimi-opus-fallback`, `worker-derotate`: also fail on the baseline copy.
- `project-worktree-isolation` and `gardener-worktree-test` (git/worktree setup) fail as well; I didn't compare them against the baseline because they don't touch utilization.
- `run-test` hit my 300s timeout.

**Follow-ups**
- Usage rows still don't record which subscription they belong to. If one host ever serves two Claude subscriptions, host filtering can't tell them apart, and the subscription would need to be stamped onto each row when it is written.
- The fix takes effect on each host at its next rolling deploy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-subscription-used-percent-per-subscription.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1239726 cached reads)
- Output: 10200 tokens
- Cost: $0.9576172000000001
- Wall-clock: 958s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
