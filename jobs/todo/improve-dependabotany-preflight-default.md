---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/set-schedule.sh
Automatically attach and preserve `dependabotany-preflight.sh` for every `dependabotany-recheck-*` schedule, then migrate the existing schedule. The current ungated daily backstop repeatedly dispatches a gardener for a provably empty Dependabot set and produces verbose clean-confirmation journal entries.
