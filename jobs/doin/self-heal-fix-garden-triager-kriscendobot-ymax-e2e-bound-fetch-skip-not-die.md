In `scripts/jobs/triager.sh` line 117, the per-repo fetch is unbounded and hard-dies:
`git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"`.
Failure signature (garden-triager@kriscendobot-ymax-e2e, exit 1): the fetch was
SIGTERM'd mid-flight (`Terminated`) → git exited nonzero → `die "fetch failed for
kriscendobot-ymax-e2e"` → exit 1 → systemd restarts → next tick re-runs the same
fetch → crash-loop/flap.

Fix: make the fetch bounded and skip-tolerant, mirroring the treatment the same
script already gives missing/corrupt/self-provision-failed clones (exit 0, retry
next tick) and `common.sh`'s `bounded_clone`/`journal_fetch`:
  - Wrap the fetch in `timeout --kill-after="$GARDEN_FETCH_KILL_AFTER"
    "$GARDEN_FETCH_TIMEOUT"` with up to `GARDEN_FETCH_RETRIES` attempts (backoff),
    capturing stderr, so a hung/half-open connection is killed and retried instead
    of running until systemd's TimeoutStartSec SIGTERMs it.
  - On persistent failure, do NOT `die`. Classify with `is_transient_net_error`:
    transient (DNS/TLS/read-timeout/outage) → `log WARN` and `exit 0` (retry next
    tick), with a throttled `alert_maintainer "triager-fetch-failed-<slug>" ...`
    so a persistent outage surfaces at most once per dedup window; structural
    (auth/404/deleted or renamed fork) → `alert_maintainer` once and `exit 0`.
  - Never hard-die on a fetch failure, so the unit stops flapping — same invariant
    the rest of triager.sh already upholds. Consider factoring a small
    `bounded_bare_fetch <bare>` helper in common.sh alongside `bounded_clone` so
    ci-watcher / other bare-clone fetchers can reuse it.
Add a test alongside the existing triager clone-handling cases asserting a failing
`GARDEN_FETCH_CMD`-injected fetch results in exit 0 (skip) plus one throttled
maintainer alert, not exit 1.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 6
  worker_kind: gardener
  claimed_at: 2026-07-19T08:25:00Z
