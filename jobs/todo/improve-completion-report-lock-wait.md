---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/claude-on-minion-town-completion-report.sh
The report wrapper failed twice with rc 124 under the default 10s `GARDEN_REPO_LOCK_WAIT` (common.sh:16, :71) while the producer journal clone lock was contended. A manual retry with `GARDEN_REPO_LOCK_WAIT=240` succeeded in 26s, so the lock was only briefly busy (journal entry in the 00:35Z–06:35Z window report, Operational note). Export a higher default for this script (for example `: "${GARDEN_REPO_LOCK_WAIT:=240}"`) before sourcing common.sh. Also retry once on rc 124 so a scheduled report doesn't need a human to rerun it.
