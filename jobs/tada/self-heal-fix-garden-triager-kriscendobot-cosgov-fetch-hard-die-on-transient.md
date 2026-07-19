Job complete. Landed on `origin/main2` as `fae75ed3d3`.

## Completion report

**Task:** Stop `triager.sh`'s steady-state fetch from hard-`die`ing (and crash-looping the systemd unit) on a transient/hung fetch — the observed `Terminated` → `FATAL: fetch failed for kriscendobot-cosgov` signature. Mirror the `bounded_clone`-failed branch: WARN + throttled `alert_maintainer` + `exit 0`, keeping only the malformed-`new_sha` assert as a `die`.

**What I found & changed (`scripts/jobs/triager.sh`):**
- The file had already evolved past the quoted `|| die` one-liner into a bounded retry loop (prior commits). But that loop carried a **latent capture bug**: `if timeout … git fetch; then …; fi; fetch_rc=$?` reads `$?` as **0** after a *failed* fetch (an `if…fi` with no else exits 0), so the failure block was **dead code** — a broken fetch silently sailed through and triaged stale refs, never retrying/alerting. Fixed by capturing the real exit with `… || fetch_rc=$?` (`set -e`-safe).
- Replaced the `die "fetch failed for $slug"` with: log a WARN (transient-vs-structural split, with `rc` and last-error diagnostic), a **throttled** `alert_maintainer "triager-fetch-failed-<slug>"`, and `exit 0`. Crucially, **all** failure classes (transient, timeout kill, unclassified) now escalate through the one dedup key — so a persistently hung upstream (the cosgov timeout case) surfaces at most once per window instead of never.
- Left the downstream malformed-`new_sha` / unresolvable-ref asserts as hard `die`s, per spec.

**Tests (`scripts/jobs/test/triager-test.sh`):** The M-section cases were **pre-existing failures on main2** — the fetch shim matched *any* `git fetch`, breaking the journal/cursor fetch (exit 75) before the steady-state fetch was even reached. Scoped the shim to `fetch --all` (steady-state only), set `GARDEN_FETCH_RETRIES=1`, and updated assertions: transient (rc 1), wall-clock kill (rc 124), and structural (rc 128) failures now each assert clean skip + no FATAL + a captured `triager-fetch-failed-<slug>` alert. **94/94 pass.**

**Merge note:** A peer landed a near-identical fix (`b20e03ff3c`) mid-flight. I rebased onto it; my commit supersedes it by additionally fixing the `fetch_rc` capture bug it retained and by escalating the transient/timeout branch (theirs `exit 0`-ed before alerting, so the cosgov signature would never have escalated).

**Follow-ups:** none. Inbox drained (empty).
