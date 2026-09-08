---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/orchestrate.sh
Make orchestration status evaluation fully deterministic and silent while all children are freshly active: emit structured failure/timeout and terminal-completion notices directly, and retire/rescope routine agent “completion press” checks. The tick inspected seven newly claimed children and found only nominal board state, consuming an agent invocation for facts this watcher already derives from the board.
