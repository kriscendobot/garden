---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/common.sh
Canonicalize `handler-budget-role: fix` to `fixer` before budget resolution, with regression coverage, so a common stage-name alias cannot silently fall through to the 2400-second default and trigger a deterministic deadline-overrun.
