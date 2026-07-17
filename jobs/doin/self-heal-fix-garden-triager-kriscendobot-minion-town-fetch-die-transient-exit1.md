In `scripts/jobs/triager.sh`, line 117 hard-`die`s (exit 1, FATAL) on a transient `git fetch --all --prune` failure: `git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"`. This crash-loops the `garden-triager@<slug>` systemd unit and fires self-heal on any network/DNS/GitHub-API blip — observed as `FATAL: fetch failed for kriscendobot-minion.town`. This contradicts the script's own design: the missing-clone self-provision path (lines 95–104) and the handler circuit breaker (lines 149–167) both treat the identical class of transient failure as a benign skip-and-retry-next-tick with `exit 0` plus a throttled `alert_maintainer` if it persists. Change line 117 to match that pattern: on a failed fetch, `log` a WARN, call `alert_maintainer` under a per-slug throttle dedup key (e.g. `triager-fetch-failed-${slug//[^A-Za-z0-9._-]/_}`) so a persistent unreachable source still surfaces at most once per window, then `exit 0` to retry next tick instead of `die`. Do not advance the cursor (there's nothing to advance to yet). Add/adjust a test in `scripts/jobs/test/` if the fetch path is covered, mirroring the existing missing-clone transient-skip cases.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 18
  worker_kind: gardener
  claimed_at: 2026-07-17T16:04:48Z
