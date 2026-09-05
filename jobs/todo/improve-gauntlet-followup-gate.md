---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/assert-followup-posted.sh
Recognize completed gauntlet-stage reports (for example `fix=done`) as driver-owned continuation when their “Follow-ups / notes” merely states that the gauntlet driver posts the next panel stage. The current generic prose gate blocks an otherwise complete fix after it has pushed green work, causing needless rc=1 retries; add a regression case for this exact report shape while preserving blocks for actual unposted successor work.
