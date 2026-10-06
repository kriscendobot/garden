---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/triager.sh
scripts/jobs/triager.sh:501 passes duration `0` to `timeout`, which immediately prevents the triage handler and pacing paths from running; `triager-pacing-test.sh` failed twice at 2026-10-06T04:04:01Z with 11 dependent failures. Run the command in a reaped process group without `timeout` when the duration is disabled, and add a regression assertion that the handler executes.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-06T04:24:39Z
