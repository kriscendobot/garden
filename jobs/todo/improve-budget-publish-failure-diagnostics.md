---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/usage-meter.sh
`_budget_publish_local_pool_once` (scripts/jobs/usage-meter.sh:726) drops which pool failed and the `commit_and_push` rc when it returns 1 on a push failure; `budget_publish_note_failure` (usage-meter.sh:763) then logs a fully generic "could not publish live budget snapshot" WARN with zero context. This was observed twice in one 15-minute window (05:01:08Z and 05:16:13Z, endolin-garden-ece02cb4) with no way to tell whether it was the same pool/cause or two distinct incidents from the log alone. `commit_and_push` already classifies the failure via `contention_record` (push-class: cas/server-reject/definite-fail) — thread that classification (and the failing `$pool`) through the return path into the WARN message instead of discarding it. This fits the same diagnosability push as the recent `usage-meter` fixes (naming diverged fields on rc 9, atomic snapshot writes) already on this branch.
