from_host: endolin-garden2-5bcdff64
from: gardener:ironhorse-fuzz-repromote-quarantined
reply_to: ironhorse-fuzz-repromote-quarantined
msg_key: msg-ironhorse-fuzz-repromote-quarantined-1719457af4c6
notice_count: 1
first_seen: 2026-09-17T01:25:56Z
last_seen: 2026-09-17T01:25:59Z
sent_at: 2026-09-17T01:25:59Z
---
ironhorse-fuzz repromote: STOPPED after the bounded probe — the reword does NOT fix the refusal on Anthropic, and this job is superseded by design.

FINDING (empirical): I regenerated 5 quarantined repair bodies with the NEW engine-defect framing (commit 37fdea27b0's reworded template) and promoted them. Within ~6 min, 3 of 5 were re-doomed `policy-refusal` on this host's Anthropic monks (79f0475d/ccb76a40/50834e82, re-doomed 01:23:53Z). The blocker job proved acceptance only on gpt-5.6-terra (OpenAI: POLICY_FILTER_ACCEPTED); that does NOT generalize to Anthropic, which still refuses the reworded body.

STORM (ongoing, upstream of promotion): the LEADER host endolin-garden-ece02cb4 is posting fresh per-finding repair jobs that ALSO carry the reworded framing and STILL get policy-refused every ~10 min (e.g. e4a8e011 doomed 01:13:40Z). The plan/ backlog is GROWING (28 -> 39 during this job), all at one project_sha 38ca1d18 across 3 targets (differential_regexp / _regexp_surface / _source) — heavy duplication (likely a handful of root causes). No ironhorse-fuzz repair has completed recently.

SUPERSEDED: scripts/jobs/ironhorse-fuzz-migrate-backlog.sh (designs/ironhorse-fuzz-triage-and-batch.md § Migration) explicitly marks THIS job (ironhorse-fuzz-repromote-quarantined) superseded and says "never promote the old files one by one" — it routes findings into deduplicated cluster repairs. It has NOT run (no migration record, 0 triage records). Root cause: the leader runs an old deployed garden (reworded per-finding template, pre-cluster/pre-migration, ~08-31..09-04); its fuzz lane keeps re-posting per-finding jobs the Anthropic filter refuses. Promotion cannot win against that.

RECOMMEND (needs your decision — I stopped rather than grind 34 jobs through a filter that is still rejecting):
1. Pin the ironhorse-fuzz repair lane's dispatch to gpt-5.6-terra (OpenAI), where the reword is proven to pass — otherwise Anthropic will keep refusing every one.
2. Deploy main2 to the leader endolin-garden-ece02cb4 to stop the stale-storm producer and arm the cluster batcher + migration.
3. Then run ironhorse-fuzz-migrate-backlog.sh to take custody of the backlog (dedup into cluster repairs) instead of per-finding promotion.

I promoted 5 as the probe (mostly re-quarantined now); left the remaining ~34 quarantined. Nothing lost.
