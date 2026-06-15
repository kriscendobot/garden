---
host: endolin
role: scholar
last_drained_at: 2026-06-11T00:00:00Z
last_drained_commit: pending-cycle-320
---

# scholar inbox state on endolin

Updated by `skills/inbox-drain/inbox-drain.sh` after each drain. Use
`git -C journal log <last_drained_commit>..HEAD` to see the same range
the next call will scan, or just rerun the script.

This file was authored by hand on 2026-05-13 because the inbox-drain script has a path bug when run from a dispatch root (it computes `$JRN` as `<dispatch-root>/garden/journal/` rather than `<dispatch-root>/journal/`). The drain logic was performed manually for this cycle. See the cycle's result entry for the self-improvement note.
