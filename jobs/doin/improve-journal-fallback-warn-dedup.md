---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/common.sh
scripts/jobs/common.sh:4350 emits a warning on every cached-remote fallback, producing seven garden-* warnings from 20:04:50–20:06:15 despite successful continuation. scripts/jobs/common.sh:4890 likewise repeats the leader-cache warning at 20:05:40 and 20:06:00. Persist a per-source failure-episode marker and log only the first fallback warning, clearing it after a direct origin read or successful leader fetch. Retain fallback and repair behavior; escalate only after a bounded persistent interval.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T21:36:31Z
