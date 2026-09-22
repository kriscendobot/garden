---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
In scripts/jobs/triager.sh around line 538, the post-triage CURSOR_KEY advance (`printf ... | "$HERE/cursor-set.sh" "$CURSOR_KEY"`) is unguarded, unlike the FAIL_KEY writes at lines 534 and 557 which both use `|| log "WARN: ..."`. Under `set -euo pipefail` a non-zero, possibly-silent exit from cursor-set.sh here aborts triager.sh immediately with no FATAL/WARN log — the failure signature observed on garden-triager@kriscendobot-minion.town: capture ends right after "[triage-claude] posted 0 job(s) from kriscendobot-minion.town triage" with rc=1 and no further diagnostic. Wrap the CURSOR_KEY write so a cursor-set.sh failure is captured and logged loudly (rc + any diagnostic) before propagating, matching the FAIL_KEY sibling pattern, so a recurrence is diagnosable instead of producing an empty capture.
