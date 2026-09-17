---
gate: go-ahead
priority: normal
tier: minion
token-budget: 100000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: transient
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-09-17T12:23:27Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-09-17T12:23:27Z
---

---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/budget-level.sh
A pool with a missing/invalid monk physical cap in config/worker-leveling currently zeroes `mv` globally, which freezes monk apportionment for EVERY host on every tick (see report_freeze call and the `mv=0` fallthrough), not just the misconfigured host's pool. This is firing right now for `anthropic:oros-studio-garden-ce242c49` (added to config/budget-pools at 2026-09-17T02:10Z with no matching `host` row in config/worker-leveling) and is blocking the whole fleet's monk count from rising. `set-budget-pool.sh` already gained a write-time guard for *new* pools (commit dd3e002519, same day) so this exact case can't recur going forward, but it doesn't repair a pool that predates the guard or one written by bypassing the setter (direct journal edit). Harden budget-level.sh to isolate a single pool's missing/invalid-cap fault the same way it already isolates uncalibrated provenance later in the file (`uncalibrated "$prov"&&continue`) — exclude just that pool/host from the apportionment sum and target computation, and freeze/report only that host, rather than blocking every other correctly-configured host's leveling. Separately, the standing config gap itself (oros-studio-garden-ce242c49 has no worker-leveling host row) still needs a human/operator decision on its physical monk cap and a `set-worker-leveling.sh` or `set-budget-pool.sh --monk-cap` call to backfill it — that's outside this script change.
