cadence: daily
last_dispatched: 2026-08-14T16:50:04Z
job_basename_prefix: dependabotany-recheck-endo-but-for-bots
preflight: dependabotany-preflight.sh
---
---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Daily dependabotany backstop for endo-but-for-bots

Wear roles/botanist/AGENT.md. Recover the cumulative Dependabot ledger from journal message entries whose body contains both "# Dependabotany" and "project: endo-but-for-bots". Re-evaluate every due open row, including https://github.com/endojs/endo-but-for-bots/pull/923, against live base state, advisories, source maturity, and CI; execute terminal dispositions through the conductor spine.
