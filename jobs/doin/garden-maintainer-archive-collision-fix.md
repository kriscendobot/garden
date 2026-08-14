---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: fixer
Fix scripts/jobs/maintainer-archive.sh so a coalesced maintainer notice can be archived when an older version with the same message ID already exists in inbox/maintainer/read. Preserve the latest unread content losslessly, handle the collision deterministically, add regression coverage, and verify both normal and collision archival paths.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-14T12:55:00Z
