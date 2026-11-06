---
posted_at: 2026-11-06T02:23:07Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: fixer
tier: mentor
---
Repo: endojs/endo-but-for-bots. Maintainer decision (kriskowal, liaison muster 2026-11-06): PR #1619 (ironhorse nineteenth slice) owns the RegExp `seed_regexp_result_ids` / `regexp_seed_result_ids` change. Rebase PR #1621 (sixteenth slice) onto its pinned base, drop its regexp.rs hunk and the `built-ins/RegExp/match-indices/indices-groups-object-undefined` shard flips, and keep only the await-constructor fix (suspend.rs plus the AsyncGeneratorPrototype / for-await-of / AsyncFromSyncIterator shards). Whichever PR lands second takes the trivial conflict. Verify #1621 does not need the snapshot-golden restamp once the regexp hunk is gone, run the CI-equivalent checks locally, force-push with lease, and leave a comment on #1621 explaining the split. #1620 does not overlap; leave it alone.

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-11-06T02:23:29Z
