---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/fetch-source.sh
Add bounded, backoff retries for transient Internet Archive original-byte fetch failures, preserving fail-closed integrity checks and manifest output. Four manual retry attempts and a later successful `2id_` fetch show this recovery should be script-owned rather than deferred to a scholar follow-on.
