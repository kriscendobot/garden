In `scripts/jobs/triager.sh` line 117, the periodic fetch hard-dies on failure:
`git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"`.
`die()` exits 1, so a transient network fetch failure (here the fetch was
SIGTERM-killed — the captured tail is `Terminated` then `FATAL: fetch failed for
kriscendobot-agoric-sdk`, a hung `git fetch --all` on the large agoric-sdk fork)
crashes the `garden-triager@<slug>` systemd unit and makes it restart-flap.

Change this fetch failure to the same transient-skip treatment already used by the
bare-clone self-provision failure path immediately above (lines 94–104): on fetch
failure, `log "WARN: ..."`, call `alert_maintainer` with a throttled dedup key
(e.g. `triager-fetch-failed-${slug//[^A-Za-z0-9._-]/_}`) explaining the fetch could
not complete (offline/DNS/half-open connection reaped by a timeout, or a killed
hang) and that it will retry next tick, then `exit 0` — skip this tick instead of
`die`. Optionally bound the fetch with a `timeout`/`bounded_*` wrapper so a hung
connection is reaped cleanly rather than by an external SIGTERM. Do NOT advance the
activity cursor on a skipped tick (leaving it here already does that, since the
early `exit 0` runs before the cursor block), so the change re-triages once the
network recovers. This keeps a network blip from flapping the unit while still
surfacing a persistent fetch outage once per throttle window.
