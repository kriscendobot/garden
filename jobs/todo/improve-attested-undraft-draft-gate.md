---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/assert-producer-pr-draft.sh
Recognize an explicitly maintainer-attested undraft job as consuming—not producing—the cited PR, after verifying its authorization against the journal allowlist. Add regression coverage: the attested #99 shape completes once, while ordinary uncovered ready-PR producers remain blocked. This prevents successful intentional undrafts from requeueing indefinitely and duplicating comments.
