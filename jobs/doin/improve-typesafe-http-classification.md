---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/classify-foreign-content.sh
scripts/jobs/classify-foreign-content.sh:269 collapses the 2026-10-14T17:40:30Z TypeSafe HTTP 400 into generic unavailability, causing a strict scholar job to requeue blindly. Capture the HTTP status and a bounded, sanitized provider error code in the manifest; retry only transient transport/408/429/5xx responses with bounded backoff. Classify non-retryable 4xx responses distinctly so callers can report an actionable API-contract failure rather than treating it as a host failover.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-14T17:52:38Z
