Done.

## Completion report

**Job:** `improve-ci-watcher-detect-systemic-rollup-outage`

Modified `scripts/jobs/ci-watcher.sh` to distinguish a systemic gh outage from a healthy all-green tick:

1. **Added `unreadable=0`** to the per-tick counter initialization (line 183).
2. **Counted the `*)` case** — the rollup-unreadable branch now increments `unreadable` alongside its existing per-PR WARN (line 207).
3. **Included `unreadable` in the summary line** (line 244), so the tick total now reports `…N unreadable, …`.
4. **Post-loop systemic detection**: when `unreadable == ours` and `ours > 0`, emit a single distinct `WARN: N/N bot PR rollups unreadable this tick — likely a systemic gh outage (auth/rate-limit/network), not per-PR`.

This collapses the 350+ identical per-PR warnings a total outage produces into one actionable signal, and a total-outage tick no longer reads as "0 red, all fine."

Verified with `bash -n` (clean). Committed and pushed to `main2` via rebase-CAS.

**Follow-ups:** none. The change is additive and log-only; no behavioral change to shepherd dispatch.
