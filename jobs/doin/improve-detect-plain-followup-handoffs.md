---
posted_at: 2026-11-14T10:51:03Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/assert-followup-posted.sh
scripts/jobs/assert-followup-posted.sh:150 misses the `Follow-up: reweave #1590, then #1592` obligation recorded at 2026-11-14T10:29:47Z because it only accepts `## Follow-ups` sections. Recognize a standalone `Follow-up:` label as actionable follow-up input and require a posted successor or explicit disposition, reusing the existing board-backed gate.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-14T10:51:15Z
