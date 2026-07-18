In `scripts/jobs/triager.sh`, line 117 (`git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"`) hard-dies (exit 1) on a transient fetch failure, crash-looping the `garden-triager@<slug>` unit and tripping self-heal. Observed signature for kriscendobot-ymax-e2e: git printed `Terminated` (SIGTERM to the fetch subprocess — a hung/half-open network connection reaped externally) followed by `FATAL: fetch failed for kriscendobot-ymax-e2e`, exit 1.

Make the fetch transient-tolerant, mirroring the self-provision path directly above (lines 94–104) which deliberately skips-and-retries rather than wedging:
1. Bound the fetch with a timeout so a hung connection is reaped locally instead of leaving the process to be SIGTERM'd by systemd — e.g. wrap with `timeout` at the same duration the clone path uses (check `bounded_clone`/common.sh for the existing `GARDEN_*` timeout knob and reuse it for consistency).
2. On fetch failure (including timeout), do NOT `die`. Instead `log "WARN: ..."`, fire a throttled `alert_maintainer "triager-fetch-failed-${slug//[^A-Za-z0-9._-]/_}" "..."` (so a persistent bad remote still surfaces at most once per dedup window, but a blip is silent), and `exit 0` so the next tick retries. Match the exact wording/shape of the provision-failed branch (lines 101–104).

Net effect: a network blip on the fetch becomes a clean skip-and-retry like every other transient condition this script already handles, instead of a crash-loop that trips self-heal. Keep the genuinely-unrecoverable cases (already handled above) dying/escalating as they do.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: cleric
  claimed_at: 2026-07-18T06:14:20Z
