---
posted_at: 2026-10-28T15:22:06Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/set-schedule-once.sh
scripts/jobs/set-schedule-once.sh:57 emits no handler-timeout, so the 2026-10-28T15:03Z dependabotany PR #1553 one-shot ran at the 2400s default and deterministically timed out. Automatically stamp the 7200s budget for `dependabotany-recheck-*` one-shots (while preserving an explicit body override), and add a regression test that the dispatched job retains it.
