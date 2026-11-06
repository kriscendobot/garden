---
gate: go-ahead
priority: normal
role: fixer
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
doomed_at: 2026-11-06T03:03:50Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-11-06T03:03:50Z
---

---
posted_at: 2026-11-06T02:23:07Z
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
role: fixer
tier: mentor
---
Repo: endojs/endo-but-for-bots. Maintainer decision (kriskowal, liaison muster 2026-11-06): PR #1619 (ironhorse nineteenth slice) owns the RegExp `seed_regexp_result_ids` / `regexp_seed_result_ids` change. Rebase PR #1621 (sixteenth slice) onto its pinned base, drop its regexp.rs hunk and the `built-ins/RegExp/match-indices/indices-groups-object-undefined` shard flips, and keep only the await-constructor fix (suspend.rs plus the AsyncGeneratorPrototype / for-await-of / AsyncFromSyncIterator shards). Whichever PR lands second takes the trivial conflict. Verify #1621 does not need the snapshot-golden restamp once the regexp hunk is gone, run the CI-equivalent checks locally, force-push with lease, and leave a comment on #1621 explaining the split. #1620 does not overlap; leave it alone.
