Harden the project-repo fetch in `scripts/jobs/triager.sh:117` so a transient connectivity blip is a clean skip, not a Failed unit. Today the line is a bare `git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"` with no timeout and no offline classification; a half-open/hung fetch gets SIGTERM'd ("Terminated") and `die` escalates it to exit 1, marking `garden-triager@kriscendobot-minion.town` Failed and waking the self-heal responder — even though the next tick would succeed. Failure signature in logs: `FATAL: fetch failed for <slug>` (via `die` on that line).

Fix: route this fetch through the same offline-tolerant pattern that `sync_clone`/`journal_fetch` already use (`scripts/jobs/common.sh` ~2483–2510). Concretely, capture the fetch stderr and, on failure, classify it with the existing `_fetch_stderr_is_offline "$stderr"` helper against `GARDEN_OFFLINE_SIGNATURES`; if it matches (DNS/TLS/reset/timeout/5xx/"error connecting to"), `log "offline; skipping tick"` and `exit "$GARDEN_OFFLINE_RC"` (75, EX_TEMPFAIL) so the wrapper/systemd retries next cadence instead of counting a fleet-wide blip as a per-worker failure. Also wrap the fetch in `timeout --kill-after="$GARDEN_FETCH_KILL_AFTER" "$GARDEN_FETCH_TIMEOUT"` (git has no IO timeout of its own; this is why the run got SIGTERM'd as "Terminated") and, ideally, a small bounded retry loop under `backoff` mirroring `bounded_clone`/`bounded_fetch` before the offline classification. Only a fetch failure that matches NO offline signature (a real repo error) should still `die "fetch failed for $slug"` — preserve the fail-loud path for genuine, non-transient errors. Keep the change minimal and reuse the common.sh helpers rather than open-coding a new signature list, so the two stay from drifting.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  claimed_at: 2026-07-19T11:24:35Z
