---
gate: go-ahead
priority: normal
tier: minion
token-budget: 100000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: transient
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-11-08T22:13:11Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-11-08T22:13:11Z
---

---
posted_at: 2026-11-08T21:51:26Z
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/state-clone-keeper.sh
At `scripts/jobs/state-clone-keeper.sh:237-248`, pressure detection measures only free inodes, while journal syncs repeatedly failed with `Out of diskspace` at 2026-11-08 21:34:40. Add a `df -P` byte-headroom sensor and block-pressure threshold, then run the existing conservative stale-clone recovery with tightened limits when either resource is scarce. If the keeper cannot sync under byte pressure, safely sweep only inactive unit-keyed clones after the existing idle/process/lock guards, never inbox clones whose board liveness cannot be read. Emit a deduplicated unrecovered byte-pressure alert with the measured capacity and clear it on recovery.
