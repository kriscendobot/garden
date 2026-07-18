In `scripts/jobs/triager.sh:117`, the watched-repo refresh is a bare, unguarded fetch that `die`s (exit 1) on any failure:
`git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"`.
Observed failure signature (`garden-triager@kriscendobot-finbot`, exit 1): bash prints `Terminated` (the `git fetch` child killed by SIGTERM — a hung/reaped connection) immediately followed by `FATAL: fetch failed for kriscendobot-finbot`. A transient network condition (offline, DNS, half-open connection reaped) marks the systemd unit Failed instead of skipping the tick.

Fix: give this fetch the same transient-tolerant treatment the self-provision *clone* path a few lines above already uses (`triager.sh:87-114` → `bounded_clone` in `common.sh:717`). Concretely: wrap the fetch in `timeout --kill-after="$GARDEN_FETCH_KILL_AFTER" "$GARDEN_FETCH_TIMEOUT"` with `GARDEN_FETCH_RETRIES` bounded retries and `backoff` between attempts — reuse the existing `bounded_fetch` helper (`clone-keeper.sh:135`), lifting it to `common.sh` next to `bounded_clone` so the triager can call it. On persistent failure, do NOT `die`/`exit 1`; instead `log` a WARN + throttled `alert_maintainer "triager-fetch-failed-${slug//[^A-Za-z0-9._-]/_}"` and `exit 0` (skip this tick, retry next), matching the clone path's transient-vs-persistent handling. This keeps the unit from flapping into Failed on ordinary network blips while still surfacing a genuinely wedged remote once, throttled.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 5
  worker_kind: cleric
  claimed_at: 2026-07-18T08:54:49Z
