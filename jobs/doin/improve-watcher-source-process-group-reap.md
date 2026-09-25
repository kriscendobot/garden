---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/pages-watcher.sh
pages-watcher.sh:130-138's cleanup() sends `kill -TERM "-$pid"` intending to signal the whole process group of the backgrounded `timeout ... &` (line ~172, `SOURCE_TIMEOUT_PID=$!`), but the script never sets `set -m` (only `set -euo pipefail` at line 52), so bash job control is off and the background job inherits the script's own pgid instead of getting a fresh one. `-$pid` therefore doesn't address a real group headed by `$pid`; the group kill silently no-ops and cleanup falls through to killing only the `timeout` process itself, leaving any `gh`/git credential-helper grandchildren it forked unreaped. That's the exact symptom in the journalctl tail (2026-09-25 13:08:46): three left-over git processes found in the `garden-pages-watcher.service` cgroup at next start, despite the KillMode=mixed + trap design meant to prevent it. Fix by launching the timed source under `setsid` (e.g. `setsid timeout --signal=TERM ... "$GARDEN_PAGES_SOURCE" ... &`) so `$!` is a real new process-group/session leader that `-$pid` can actually signal, or by `set -m` before backgrounding. `scripts/jobs/ci-watcher.sh` has the identical `SOURCE_TIMEOUT_PID`/`kill -TERM "-$pid"` pattern with no `set -m` either (line ~280-300) and should get the same fix.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-25T13:21:36Z
