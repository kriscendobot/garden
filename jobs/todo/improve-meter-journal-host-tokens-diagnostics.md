---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/usage-meter.sh
`meter_journal_host_tokens` (usage-meter.sh:508-529) collapses three distinct failure causes — missing jq/usage dir, empty/unsynced ledger, and unmetered-row data quality error — into the same `return 1`, and `budget-level.sh:39`'s `pool_failure` then logs the generic `operation=read-remote-spend failed exit_status=1` regardless of which. This recurred twice in one 30-minute window (18:35:08 and 18:50:08 warnings, pool=claude-oros host=oros-studio-garden-ce242c49) with no way to tell from the log whether it's a transient journal-sync lag (self-resolving) or a genuine unmetered-row bug in the ledger (needs a fix). Change the three return sites to distinct exit codes (e.g. 2=no-jq/no-dir, 3=empty-ledger, 4=unmetered-rows) and have `pool_failure` map the code to a short reason string in its WARN line. This turns an opaque repeating warning into an actionable one without changing the fail-open behavior itself.
