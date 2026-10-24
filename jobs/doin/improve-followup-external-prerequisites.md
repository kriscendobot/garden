---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/assert-followup-posted.sh
scripts/jobs/assert-followup-posted.sh:347 blocks and requeues a completed job when its only follow-up requires unavailable Docker/AWS credentials; the 2026-10-24T05:51:51Z report explicitly names those external prerequisites. Recognize narrowly phrased host-access/credential prerequisites as non-board-postable and auto-escalate the follow-up to the maintainer inbox, preserving completion instead of rerunning the finished agent work.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-24T06:21:21Z
