---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/journal-contention-watch.sh
scripts/jobs/journal-contention-watch.sh:279 lets clone inspection wait on a busy producer repository lock until the 240s unit timeout, as repeated 08:43–09:22Z failures show. Make inspection use a short bounded shared-lock attempt and defer that clone on contention, preserving the heartbeat and retrying next tick; update journal-contention-lib.sh as needed.
