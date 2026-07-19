In `scripts/jobs/triager.sh`, harden the steady-state upstream fetch at line 117 (`git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"`) so a transient/killed fetch clean-skips instead of dying exit 1. Failure signature: the service `garden-triager@kriscendobot-ymax-stdio-mcp` exited 1 with a two-line log — `Terminated` (SIGTERM-killed git fetch child) followed by `FATAL: fetch failed for kriscendobot-ymax-stdio-mcp` — which trips self-heal on a network blip. Mirror the existing `sync_clone` pattern in `scripts/jobs/common.sh:2491-2510`: run the fetch under a `timeout` wrapper capturing stderr into `GARDEN_FETCH_STDERR` (as `journal_fetch` does), and when it fails, treat rc 124/137 (timeout SIGTERM/SIGKILL) or a `_fetch_stderr_is_offline "$GARDEN_FETCH_STDERR"` match as transient — `log "offline; skipping tick"` and `exit "$GARDEN_OFFLINE_RC"` — and only `die "fetch failed for $slug"` for a genuinely non-transient rc. Both helpers and `GARDEN_OFFLINE_RC` are already available since triager.sh sources common.sh; use `if git ...; then rc=0; else rc=$?; fi` so `set -euo pipefail` does not abort before classification (same idiom as common.sh:2491).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 9
  worker_kind: cleric
  claimed_at: 2026-07-19T08:24:42Z
