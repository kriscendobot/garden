Both parts of this job were already done before I claimed it, so I made no commits. The rolling deploy is built and on `main2`, the doc edits are made, and it is running live on the three-host fleet. Its test harness passes 105 of 105. A failed canary halting the roll has only been shown in the test harness, never on a real host.

**What exists on `main2`**
- **The build:** e8f6a81d1a0 (2026-09-04), "leader-orchestrated fleet upgrade with followers as canaries". It follows the design's recommended choices:
  - The deploy trigger stays a host-local `upgrade-ready` fact. The leader orders the roll with harmless journal release tokens and `drain` ops, and never sends the sysop `deploy` op, so that op still needs maintainer attestation.
  - Followers go first as canaries, one at a time, and the leader deploys itself last.
  - Each canary is checked on unit health, a probe job pinned to that host that must go claim → run → tada, and a watch on job processing. These combine into one pass/fail result.
  - A failed canary halts the roll, stays drained, and pages the maintainer once.
  - `self-deploy.sh` keeps the follower's own trigger: the leader's release token is the main path, with a fallback for when there is no leader.
  - Automatic rollback was not built; the design leaves it as an open question.
- **The deferred doc edits** landed in the same commit: `roles/liaison/AGENT.md` § Deploy-on-upgrade Monitor (now "observe/override", and neither tier needs a watching session), CLAUDE.md § Deliberate deploy, and `context/operations/deploy.md`.
- **About ten follow-up fixes since then**, the latest being 36def9fd9e8 (2026-09-29). They covered hosts that are offline, canaries waiting behind long jobs, pinning the deploy target, the canary-drain deadlock, and busy canaries.

**Test harness** (`scripts/jobs/test/rolling-deploy-test.sh`, run just now): all 105 checks pass. The ones this job asked for:
- The roll releases canary F1 only, posts a probe pinned to F1, and on F1's pass releases F2. With all canaries passed, the leader deploys last; it did not advance at any earlier step.
- A real gardener completes a canary probe through the full claim → tada path with no LLM.
- A failed canary is drained and marked as drained by the roll, the leader does not advance, and it is retried after a backoff. Once retries run out, the roll stops and the maintainer is paged. The canary stays drained and the leader never advances.
- A code check confirms the roll never issues `op=deploy`, reads no bus message to decide to deploy, and never calls an LLM.

**Live evidence** (journal plus `journalctl --user -u garden-rolling-deploy`, leader `endolin-garden-ece02cb4`):
- There are 24 completed live rolls in `journal/deploy/roll-completed/`. Examples:
  - `e036bb8e…` completed 2026-09-28T19:05Z with both canaries passed (`endolin-garden2-5bcdff64`, `oros-studio-garden-ce242c49`).
  - `47b41af5…` completed 2026-09-26 with `oros` skipped as offline (heartbeat stale by 2076s).
- The roll for today's `36def9fd9e81`, from the log:
  - 15:32–15:47: canary `endolin-garden2` was held back behind a long job, logged "DEFERRING (waiting, not failed)".
  - 15:50:13: it posted probe `canary-probe-endolin-garden2-5bcdff64-36def9fd9e81-r1`.
  - 16:02:01: "canary endolin-garden2-5bcdff64 PASSED for 36def9fd9e81: units all active + probe round-trip OK".
  - 16:14:01: `oros` was skipped as offline (heartbeat 23181s stale), then "all required canaries passed … leader self-deploying LAST".
  - The leader's deploy is draining now and waiting on one mid-job gardener. That is probably this job, so it should land once this report is written. `fleet/deployed` already shows `endolin-garden2` on `36def9f` while the leader is still on `e036bb8`.

**Still to confirm on real hosts:** no real canary has failed in the last 7 days of logs, so the halt path is only proven in the harness. Confirming it live would take a deliberately broken canary on a follower, which I did not stage. Follower host `oros-studio-garden` has been offline for over 6 hours, so it is being skipped rather than validated.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-build-follower-self-deploy.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 3 host(s) (2 unmetered)
- Input: 18 tokens (466000 cached reads)
- Output: 3998 tokens
- Cost: $0.6045440000000001 (2 engagement(s) unpriced)
- Wall-clock: 2751s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
