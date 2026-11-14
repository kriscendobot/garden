cadence: daily
last_dispatched: 2026-11-14T02:50:15Z
job_basename_prefix: dependabotany-recheck-endo-but-for-bots
preflight: dependabotany-preflight.sh
handler-timeout: 7200
---
---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Wear roles/botanist/AGENT.md and re-evaluate every open PR in the endo-but-for-bots dependabotany ledger whose maturity date has arrived or whose recorded blocker has cleared. Recover the ledger with: grep -rl '^project: endo-but-for-bots$' journal/entries/ | xargs grep -il '^# *dependabotany'. Execute the now-due verdict for each PR: MERGE-NOW through ci-wait-merge.sh --dependabot-auto-merge, REJECT closes, EMBARGO re-defers. Current row: #1629 (setup-python 7.1.0) is held on endojs/endo-but-for-bots#1613 and #1646.
