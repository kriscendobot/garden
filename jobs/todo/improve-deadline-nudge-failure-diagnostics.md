---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/deadline-nudge.sh
`deadline-nudge.sh:427` emits only an opaque `rc=1`; five failures from 2026-09-28T23:50:43Z through 2026-09-29T00:00:42Z contain no failed stage or command. Add an ERR-trap/captured-command diagnostic around the tick subshell, preserving the current fail-open exit, so recurring failures identify the exact operation without supervisor investigation.
