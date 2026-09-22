---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/triager.sh
Make the optional shared pacing-clone refresh fail fast under live lock contention, using a short bounded acquisition and the existing fail-open warning latch. The current three 60-second waits produce recurring FATAL noise and delay many otherwise-complete triager ticks merely to calculate a nonessential next wake.
