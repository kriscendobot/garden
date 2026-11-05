once: 2026-12-01T00:30:00Z
job_basename_prefix: minion-town-ci-runner-to-hosted-202611
---
---
role: shepherd
handler-timeout: 10800
---
# Switch minion.town CI back to GitHub-hosted runners after the November reset

Follow `skills/minion-town-ci-runner-switch/SKILL.md`, direction **To GitHub-hosted**. Probe a recent `test.yml` run first; leave `CI_RUNS_ON` set to `"ubuntu-latest"` only if hosted jobs start successfully. If billing is still blocked, restore the self-hosted target, recover the probe run, and reschedule for one day later.
