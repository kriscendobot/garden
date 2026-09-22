---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
In scripts/jobs/receipt-watcher.sh around lines 83-94, the prerequisite failure
path can die with a `$PREREQ_ERR` file that is completely empty, producing the
misleading message "receipt journal prerequisite failed for <repo> (rc=N; see
prerequisite stderr above)" with literally nothing above it (observed in
production: garden-receipt-watcher@kriscendobot-minion.town failed with exit 1
and a captured stdout+stderr tail consisting of ONLY that die() line — no
`  prerequisite: ...` lines at all). This means some command inside the
`( ensure_clone "$DIR"; sync_clone "$DIR" )` subshell can return nonzero without
ever calling `log`/`die` first (an unclassified silent `set -e` exit), which is
itself worth auditing in `ensure_clone`/`sync_clone`/`journal_fetch` in
common.sh — but independent of finding that root cause, the die() message
should not claim there is diagnostic text above when there is none. Add a guard
around line 89 so that when `$PREREQ_ERR` is empty (`[ -s "$PREREQ_ERR" ]`
false), it logs a distinct fallback line instead of the no-op `sed`, e.g.
`log "  prerequisite: (no diagnostic captured — subshell exited rc=$prereq_rc with empty stderr)"`,
so the next occurrence of this failure is actually triageable from the
self-heal capture instead of reproducing today's dead end.
