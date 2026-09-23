Pushed cleanly to main2. Work complete.

## Completion report

**Job:** Fix the last unguarded git fetch in `scripts/jobs/triager.sh` — the steady-state clone refresh at line 117 that crash-loops `garden-triager@<slug>` on transient network/SSH blips.

**What I did:**
- Replaced the unguarded `git --git-dir="$BARE" fetch -q --all --prune || die ...` with a **bounded fetch loop**: each attempt runs under `timeout --kill-after="$GARDEN_FETCH_KILL_AFTER" "$GARDEN_FETCH_TIMEOUT"`, retried with `backoff` up to `GARDEN_FETCH_RETRIES` — the exact helper vars and pattern used by `clone-keeper.sh` `bounded_fetch`, `common.sh` `journal_fetch`, `scheduler.sh`, and `fork-watch-provisioner.sh`.
- On a transient/timeout failure (rc 124/137 or any failure after the retry budget), it no longer `die`s: it logs a `WARN` and `exit 0` so the next tick retries (no crash loop), and escalates on persistence via the throttled `alert_maintainer` under dedup key `triager-fetch-failed-<slug>` — mirroring the existing `triager-provision-failed-*` escalation at lines 96–104.
- Success behavior is byte-for-byte identical (a healthy fetch still just refreshes and falls through).
- Added regression **case M** to `scripts/jobs/test/triager-test.sh`: a scoped `git` shim forces the steady-state fetch to fail (simulating an SSH connection timeout) and asserts exit 0, the WARN log, the throttled maintainer escalation, no handler invocation, and an un-advanced cursor.

**What changed:** `scripts/jobs/triager.sh` (fetch now bounded + non-fatal), `scripts/jobs/test/triager-test.sh` (+1 case).

**Verification:** `bash -n` clean; shellcheck shows only pre-existing findings (none from the new code); full triager suite **82 passed, 0 failed** (77 prior + 5 new). Committed and pushed to `origin/main2` (`38225af5a5`) on the first CAS attempt.

**Follow-ups:** None. This was the last unbounded git fetch in the triager.
