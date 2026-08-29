---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardening/panel.sh
Bound each concurrent juror-seat invocation with a configurable timeout below the enclosing panel handler budget; preserve its stderr and classify/retry the timed-out seat deterministically. A single staged panel round exhausted its full 7200-second wall-clock budget, so an unbounded seat can currently consume the whole claim.
