Broaden the transient-outage classifier `_fetch_stderr_is_offline()` in `scripts/jobs/common.sh` (currently 4 literals: "Could not resolve hostname", "Temporary failure in name resolution", "Could not read from remote repository", "Connection timed out"). It misses git-over-HTTPS's real DNS diagnostic `Could not resolve host:` (note: `host:`, not `hostname`) and the common HTTPS-transport blips: `Connection reset by peer`, `Recv failure`, `Early EOF` / `unexpected disconnect`, `RPC failed`, `HTTP 5\d\d` / `The requested URL returned error: 5`, `gnutls_handshake` / `SSL` / `TLS` errors, and `Operation timed out`. Any fetch failure whose stderr isn't matched falls through to `die "fetch failed in ... after bounded retries"` in `sync_clone`, killing every caller that runs through it (complete-job, post-job, bulletin, scheduler — not just the now-hardened claim path) on a self-resolving network blip. Convert the `case` to cover these signatures (case-insensitive) so a transient outage classifies as EX_TEMPFAIL (75) fleet-wide. Pair with a unit-test case in `scripts/jobs/test/run-test.sh` feeding each signature string through the classifier.

---
claim:
  host: endolinbot
  gardener: 18
  claimed_at: 2026-06-27T07:07:05Z
