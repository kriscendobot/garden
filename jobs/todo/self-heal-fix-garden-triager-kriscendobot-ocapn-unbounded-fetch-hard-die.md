In `scripts/jobs/triager.sh`, the primary bare-clone fetch at line 117 —
`git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"` — is
unbounded (no `timeout`, so a hung connection is only killed externally, producing the
`Terminated` line) and hard-`die`s (exit 1) on any failure. A transient network blip
therefore crashes the whole `garden-triager@` service and trips systemd restart +
self-heal, instead of skipping the tick and retrying — inconsistent with the
self-provision clone path just above (lines ~96–104) which logs, skips, `exit 0`, and
only escalates a *persistent* failure via throttled `alert_maintainer`.

Fix: replace the raw `fetch || die` with a bounded, graceful equivalent that mirrors the
existing discipline. Concretely: wrap the fetch in
`timeout --kill-after="$GARDEN_FETCH_KILL_AFTER" "$GARDEN_FETCH_TIMEOUT"` with the
`GARDEN_FETCH_RETRIES`/`backoff` retry loop (lift a `bounded_fetch_all`/`--all --prune`
variant into common.sh next to `bounded_clone`/`bounded_fetch`, or inline the same
pattern), and on final failure `log` + `alert_maintainer` (throttled per
`triager-fetch-failed-<slug>` dedup key) + `exit 0` (skip, retry next tick) rather than
`exit 1`. This keeps a network blip from crashing the service while still escalating a
genuinely persistent unreachable-remote condition exactly once per window.
Failure signature: `FATAL: fetch failed for <slug>` preceded by `Terminated`, exit 1.
