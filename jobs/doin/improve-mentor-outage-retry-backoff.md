---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/mentor.sh
`scripts/jobs/mentor.sh:281` retries the unavailable improve handler every timer tick; the same outage recurred at 08:50:13Z, 09:20:13Z, and 10:20:12Z, while only its warnings back off. Persist an exponential next-retry deadline and skip handler invocation until eligible, retaining unadvanced markers and resetting the deadline after a real verdict. Extend the transient-backoff test to assert reduced provider calls.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-20T12:24:22Z
