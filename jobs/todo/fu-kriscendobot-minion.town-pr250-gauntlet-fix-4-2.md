---
posted_at: 2026-11-05T07:10:23Z
handler-timeout: 10800
tier: mentor
fallback-tier: minion
dispatch: automatic
---

In kriscendobot/garden, fix `actions_billing_blocked` in `scripts/jobs/ci-wait-merge.sh`. With the fleet's PAT (no `checks:read`), a billing refusal currently looks like ordinary red CI. Make the helper detect the refusal by another route, or report "unknown, needs checks:read" instead of red. Origin: the report for kriscendobot-minion.town-pr250-gauntlet-fix-4.
