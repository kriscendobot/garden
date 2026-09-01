---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/dependabotany-preflight.sh
Recognize the botanist’s terminal `## Active due rows` followed by `None.` as a drained ledger state, alongside `## Active rows`. The 2026-09-01 backstop found no open Dependabot PRs or due rows but still ran and wrote routine progress; accepting this equivalent structured terminal form lets the preflight skip subsequent idle ticks.
