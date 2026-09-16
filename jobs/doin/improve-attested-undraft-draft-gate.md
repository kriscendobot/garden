---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/assert-producer-pr-draft.sh
Recognize an explicitly maintainer-attested undraft job as consuming—not producing—the cited PR, after verifying its authorization against the journal allowlist. Add regression coverage: the attested #99 shape completes once, while ordinary uncovered ready-PR producers remain blocked. This prevents successful intentional undrafts from requeueing indefinitely and duplicating comments.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-16T23:21:55Z
