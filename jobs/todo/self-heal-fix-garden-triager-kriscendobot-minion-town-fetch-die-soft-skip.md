In `scripts/jobs/triager.sh`, the standing-clone refresh at line 117 —
`git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"` —
is (a) unbounded and (b) a hard `die` (exit 1). The observed failure signature is
a two-line log: `Terminated` (git fetch killed by SIGTERM after wedging) followed
by `FATAL: fetch failed for kriscendobot-minion.town` from `die`, exit code 1,
which crash-loops the `garden-triager@kriscendobot-minion.town` systemd unit.

Fix, mirroring `bounded_clone()` in `scripts/jobs/common.sh` (line 717) and the
already-soft clone-provision-failed path in this same script (triager.sh:101–104):

1. Wrap the fetch in a bounded, retrying `timeout --kill-after="$GARDEN_FETCH_KILL_AFTER"
   "$GARDEN_FETCH_TIMEOUT" git --git-dir="$BARE" fetch -q --all --prune`, using the
   existing `GARDEN_FETCH_TIMEOUT` / `GARDEN_FETCH_KILL_AFTER` / `GARDEN_FETCH_RETRIES`
   constants (common.sh:203–228), so a SIGTERM-ignoring transport child cannot wedge
   the fetch and produce the bare `Terminated`. Consider factoring a shared
   `bounded_bare_fetch` helper into common.sh next to `bounded_clone`, since the
   journal already has `_journal_git_fetch` doing the same discipline.
2. On ultimate failure, do NOT `die`. Log a WARN and `exit 0` (skip this tick,
   retry next tick) — a fetch failure is a transient network condition and must not
   flap the unit. Route a persistently-unreachable source through `alert_maintainer`
   with a throttled dedup key (e.g. `triager-fetch-failed-${slug//[^A-Za-z0-9._-]/_}`)
   exactly as the provision-failed path already does, so a real outage escalates
   once per window instead of crash-looping silently.

Keep the existing consecutive-failure circuit breaker for the handler untouched;
this change only covers the fetch step that precedes it.
