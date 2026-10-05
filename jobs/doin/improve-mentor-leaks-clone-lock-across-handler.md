---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/mentor.sh
sync_clone intentionally keeps the per-clone lock (and its inner exclusive git repo-lock) held after returning, to be released by a later commit_and_push, a subshell wrapper, or an explicit clone_unlock — see reaper.sh:906-907 and worker-derotate.sh:179 for the two correct patterns. mentor.sh:36-38 calls `ensure_clone "$DIR"; sync_clone "$DIR"` directly, un-subshelled, then never pushes to `$DIR` and never calls `clone_unlock "$DIR"`, so the exclusive lock leaks for the rest of the process — through capture_blob (mentor.sh:155) and the multi-minute `claude -p` handler invocation at mentor.sh:179. Live symptom just reproduced: while the handler (this inner agent) was running, `git cat-file -p <sha>` against that same clone timed out after the 10s GARDEN_REPO_LOCK_WAIT reporting `busy pid=<mentor.sh pid>`, later `overdue-holder` past the 120s stale threshold — defeating the "inspect via `git cat-file`" design the digest hand-off relies on. Add `clone_unlock "$DIR"` immediately after mentor.sh:38, right after sync_clone returns, since mentor.sh only reads this clone (capture_blob) and never writes/pushes to it.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-05T01:55:33Z
