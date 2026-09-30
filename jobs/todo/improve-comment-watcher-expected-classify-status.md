---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-watcher.sh
scripts/jobs/comment-watcher.sh:2067 invokes `classify` with expected rc=2, but its `ERR` trap logs it as FATAL; this recurred at 02:43:51Z and 02:45:47Z. Capture classification through an `if` conditional so Bash suppresses the ERR trap for the documented 1/2 outcomes while retaining genuine failures.
