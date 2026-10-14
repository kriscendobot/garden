---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/deadline-nudge.sh
scripts/jobs/deadline-nudge.sh:46 enables soft lock failure but supplies no caller-scoped cooldown, producing the busy-lock warning at 2026-10-14T06:37:11Z. Set a stable `GARDEN_CLONE_LOCK_SOFT_COOLDOWN_KEY` for all deadline-nudge clone stages and add a regression test that repeated ticks skip quietly until expiry.
