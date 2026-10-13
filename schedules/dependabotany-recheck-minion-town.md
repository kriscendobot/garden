cadence: daily
last_dispatched: 
job_basename_prefix: dependabotany-recheck-minion-town
preflight: dependabotany-preflight.sh
handler-timeout: 7200
---
---
role: botanist
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Wear `roles/botanist/AGENT.md` and re-evaluate every due or escalation-pending Dependabot row for project `minion-town` / repo `kriscendobot/minion.town`, executing each available terminal verdict on this bot-owned repository. Recover the cumulative ledger with `grep -rl '^project: minion-town$' journal/entries/ | xargs grep -il '^# *dependabotany'`; re-fetch live PR/base state and do not rely on stale rows. For PR #185, do not bypass the named `claude-harness-refresh` hook: its prior attempt failed closed because the refresh generated manifest files outside the hook's declared output set.
