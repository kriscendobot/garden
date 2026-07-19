In `scripts/jobs/triager.sh` line 117, the periodic fetch `git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"` hard-`die`s (exit 1, systemd unit failure/restart) on any transient fetch failure. Observed signature: `Terminated` followed by `FATAL: fetch failed for kriscendobot-cosgov` — the `git fetch` subprocess was SIGTERM'd (hung/slow upstream reaped) and `die` failed the unit. This contradicts the file's own design invariant (see the multi-paragraph comment above and the `bounded_clone` failure branch a few lines up: a transient/unreachable upstream must skip cleanly and retry next tick, never crash-loop the unit). Change the fetch failure to mirror the `bounded_clone`-failed branch: log a WARN, `alert_maintainer` under a throttled dedup key (e.g. `triager-fetch-failed-${slug//[^A-Za-z0-9._-]/_}`) so a persistent outage escalates at most once per window, and `exit 0` so the next timer tick retries — instead of `die`. A genuinely persistent unreachable upstream then surfaces via the throttled maintainer alert rather than an every-tick unit failure. Keep the downstream malformed-`new_sha` assert as-is (that one is deterministic and should still `die`).

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 8
  worker_kind: gardener
  claimed_at: 2026-07-19T03:04:13Z
