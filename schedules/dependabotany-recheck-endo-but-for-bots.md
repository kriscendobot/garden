cadence: daily
last_dispatched: 2026-09-06T04:05:08Z
job_basename_prefix: dependabotany-recheck-endo-but-for-bots
preflight: dependabotany-preflight.sh
---
Wear `roles/botanist/AGENT.md` and re-evaluate every due Dependabot embargo row for project `endo-but-for-bots` / repo `endojs/endo-but-for-bots`, executing each now-due verdict on this bot-owned repository. Recover the cumulative ledger with `grep -rl '^project: endo-but-for-bots$' journal/entries/ | xargs grep -il '^# *dependabotany'`; re-fetch live PR/base state and do not rely on stale rows.
