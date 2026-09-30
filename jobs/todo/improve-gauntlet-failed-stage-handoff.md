---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/assert-followup-posted.sh
scripts/jobs/assert-followup-posted.sh:249 blocks a gauntlet fix child that correctly emitted `orchestration-failed` and `gauntlet-stage-result: fix=still-pending` at 2026-09-30T01:12:21Z, leaving it to an agent to describe a CI investigation. Treat that exact structured failed-stage disposition as driver-owned, so the child can settle failed and `orchestrate.sh` can deterministically halt and notify on the recorded failure. Keep ordinary substantive follow-ups gated unless the job metadata, exact stage marker, and orchestration-failure marker all agree.
