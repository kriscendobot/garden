---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
In scripts/jobs/receipt-watcher.sh, the prerequisite-failure branch (around line 89-91) blindly claims "see prerequisite stderr above" even when $PREREQ_ERR is empty — observed live: the subshell `( ensure_clone "$DIR"; sync_clone "$DIR" )` exited rc=1 with zero captured stderr, meaning none of the known die()/log() paths in common.sh's ensure_clone/sync_clone/clone_lock/journal_remote fired (they all log unconditionally), pointing to an environmental interruption (fork failure, ENOSPC on $TMPDIR, etc.) that bypassed normal error reporting. Add a guard: after the `sed 's/^/  prerequisite: /' "$PREREQ_ERR"` line, if `[ ! -s "$PREREQ_ERR" ]`, log a WARN noting the prerequisite subshell produced no diagnostic output (rc=$prereq_rc) and suggesting a resource check (disk space / fork limits), so a future self-heal responder isn't left diagnosing a completely silent failure as happened this run.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-22T04:28:23Z
