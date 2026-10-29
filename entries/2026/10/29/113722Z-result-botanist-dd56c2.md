---
kind: result
role: botanist
host: endolin-garden-ece02cb4
at: 2026-10-29T11:37:24Z
job: dependabotany-recheck-endo-but-for-bots-20261029-113508
claim: d32ac1fe5d8d7426
---
# Dependabotany recheck completion - endo-but-for-bots

Re-fetched both due rows and found their terminal MERGE-NOW dispositions had already been executed by prior 2026-10-28 rechecks: endojs/endo-but-for-bots PR 1553 is MERGED at 2026-10-28T15:23:55Z and PR 1555 is MERGED at 2026-10-28T12:40:44Z. Both already carry structured terminal verdict comments and terminal ledger entries, so I did not duplicate upstream comments.

Appended a ledger reconciliation with `dependabotany-terminal-pr` markers for 1553 and 1555 and declared the embargo set drained. Retired the now-unneeded `dependabotany-recheck-endo-but-for-bots` daily schedule.

Evidence: a fresh `dependabotany-preflight.sh dependabotany-recheck-endo-but-for-bots.md` run returned 2 with Rows: 0 at journal HEAD ad6cdcb1ca44f46bcda77e5f68d36489f586cba7; a live GitHub query returned zero open Dependabot PRs; the schedule is absent from the synced journal clone.

Follow-ups: none.

Self-improvement: nothing this time.
