---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/comment-source-gh.sh
scripts/jobs/handlers/comment-source-gh.sh:464-470 exempts a whole review fanout from per-request admission; at 08:57:47 three `/reviews` requests still hit an exhausted primary quota before cancellation. Recheck/admit each post-canary batch conservatively (or serialize it when quota freshness is uncertain) so the shared cooldown is published before peers issue doomed calls, with a regression test for one refusal per exhaustion episode.
