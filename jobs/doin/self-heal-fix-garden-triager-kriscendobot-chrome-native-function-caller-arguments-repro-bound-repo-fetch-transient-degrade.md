In `scripts/jobs/triager.sh:117`, replace the bare unbounded project-clone fetch — `git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"` — with the same bounded+classified pattern the sibling watchers already use, so a transient network stall degrades to a clean skip-this-tick (exit 0) instead of a FATAL that marks the unit Failed and fires self-heal. Concretely: run the fetch under the fleet's bounded fetch (`journal_fetch "$BARE"` / the `GARDEN_FETCH_TIMEOUT` + `--kill-after` + `GARDEN_FETCH_RETRIES` discipline in `common.sh`), capture its stderr, and on failure call `is_transient_net_error`: if transient (rc 124/137 SIGTERM/SIGKILL wall-clock kill, or a `GARDEN_OFFLINE_SIGNATURES` match — the current failure is the rc-124/"Terminated" case), `log "WARN: ..."` and `exit 0` (retry next tick), mirroring the transient-tolerant clone-provision path already present at lines 95–104; only `die` on a genuine structural fetch error. Failure signature: `triager.sh` tail = `Terminated` + `FATAL: fetch failed for <slug>`, exit 1, from the unbounded `git fetch` at line 117.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 9
  worker_kind: gardener
  claimed_at: 2026-07-17T20:14:45Z
