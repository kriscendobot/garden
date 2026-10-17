The job is complete. Here is my report.

---

## Completion report: unstick ci.minion.town self-hosted CI runner

**Status when claimed (13:53Z):** already recovering. The symptom (7 queued, 0 in_progress at 12:40Z) had self-resolved ~13:15Z, before I claimed.

**What I found (re-derived from a clean start):**
1. **Instance:** `minion-town-ci` (`i-0fdb85b6bbc081acb`, t3.large, us-west-1) **running** since 2026-10-13 — never reclaimed or stopped.
2. **Service:** `ci-runner.service` **`active (running)`** continuously since 2026-10-15 — never wedged, never died.
3. **Runner:** `ci-minion-town-0fdb85b6-20261017T134159Z` **online / busy**, currently running the arm64 Claude-harness build.

**Root cause:** From ~12:04Z to ~13:15Z the ephemeral-runner **JIT minter** hit GitHub **primary REST rate-limit exhaustion** — every `GET /repos/kriscendobot/minion.town` returned `HTTP 403: API rate limit exceeded for user ID 279080640` (the shared kriscendobot OAuth token the minter Lambda uses, which is also the fleet-wide gh-wrapper token). With no JIT config, `ci-runner-controller` logged `could not mint a JIT config; retrying in 60s` and could not register a fresh runner, so runs stayed `queued`. When the hourly rate window reset (~13:15Z), minting resumed (first success `ci-minion-town-...T131549Z`) and the backlog began draining one job at a time (test→amd64→test→probe→arm64).

**Action taken:** none required. I did **not** restart the service (it was healthy — a restart would have changed nothing), did **not** touch the instance, and did **not** switch `CI_RUNS_ON` to hosted (kriscendobot hosted-minutes billing block runs to ~2026-10-30).

**Done criterion met:** a queued run — `test` on `feat/beta-home-splash-waitlist` (queued since 11:46Z) — has reached **`in_progress`** on the self-hosted runner, with the backlog actively draining (12 completed / 1 in_progress / 7 queued and shrinking; the runner serializes jobs).

**Follow-up (not fixed here):** the JIT minter shares the fleet-wide kriscendobot token, so any fleet gh burst can exhaust the primary rate limit and starve CI. A dedicated minter PAT/token would isolate the CI runner from fleet gh traffic. Recorded the diagnostic pattern to memory so a future stall isn't re-diagnosed via SSM from scratch. (Note: the one `deploy (continuous deployment)` run queued at 13:48Z runs on hosted runners per the ops doc and won't drain via the self-hosted runner — expected, separate from this job.)
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-ci-runner-stall-20261017.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (519822 cached reads)
- Output: 7754 tokens
- Cost: $1.1200510000000001
- Wall-clock: 131s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
