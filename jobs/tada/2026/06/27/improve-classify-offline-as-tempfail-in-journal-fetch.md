The job is already complete — the implementation matches the spec exactly and is committed on `origin/main2`. No code changes were needed.

---

## Completion report: `improve-classify-offline-as-tempfail-in-journal-fetch`

**Outcome: already implemented and landed; nothing to change.**

The requested behavior is fully present in `scripts/jobs/common.sh` on `origin/main2` (and in the local working tree, which is byte-identical). It was landed by commit `e122c8a12 jobs/common: classify connectivity outage in sync_clone as EX_TEMPFAIL (75)`. The job carried `<!-- garden-reaped: 1 -->`, indicating it was reaped/requeued after the work had already merged, so this claim re-ran an already-satisfied spec.

**Verified against each requirement of the spec:**
- **`GARDEN_OFFLINE_RC=75` constant** — defined at `common.sh:56` (`: "${GARDEN_OFFLINE_RC:=75}"`, EX_TEMPFAIL), overridable for tests.
- **Deterministic stderr capture in `journal_fetch`** — the final fetch's stderr is captured into `GARDEN_FETCH_STDERR` in *both* branches (`GARDEN_FETCH_CMD` injection path at line 407 and the real `timeout … git fetch` path at line 409), so classification never re-runs the fetch and tests can drive it via injection.
- **Outage classifier** — `_fetch_stderr_is_offline()` (lines 425–433) matches all four required signatures: `Could not resolve hostname`, `Temporary failure in name resolution`, `Could not read from remote repository`, `Connection timed out`.
- **`sync_clone` distinguishes outage from real error** — on `rc == 128` *and* an offline-matching stderr it logs the single line `offline; skipping tick (rc=75)` and `exit "$GARDEN_OFFLINE_RC"` (lines 449–451); every other failure still falls through to `die "fetch failed in $dir after bounded retries"` (line 453, the former `common.sh:413`).

**Caller/wrapper side also already wired:** `scripts/jobs/self-heal-run.sh` recognizes the code (`if [ "$rc" -eq "${GARDEN_OFFLINE_RC:-75}" ]` at line 111), so a connectivity blip surfaces as a self-describing transient skip rather than a fleet-wide false failure.

**Changes made:** none (working tree already identical to `origin/main2` for this file).

**Follow-ups:** none. Inbox was empty at completion.
