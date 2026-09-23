Empty inbox. Work is complete and pushed.

---

## Completion report

**Job:** `improve-scholar-preflight-broadcast-actionability-filter` — harden `scripts/jobs/scholar-preflight.sh` condition #3 so a fresh `role/scholar` broadcast only counts as work when it carries an actionable scholar marker, not on `sent_at` freshness alone.

**What I did**

1. **Fixed condition #3** (`scripts/jobs/scholar-preflight.sh`). The loop still confirms `sts > last` (freshness vs the schedule's `last_dispatched`), but now, before `exit 0`, it greps the message body for an actionable marker. A fresh broadcast without one is logged and `continue`d instead of dispatching.
   - **Markers derived from `roles/scholar/AGENT.md` § Per-job procedure step 2** (the inbox/topic-handling predicate: *"surface `library_action: ingest-source` asks and writeback-review requests"*): regex `^[[:space:]]*library_action:|writeback` (case-insensitive). The first covers `ingest-source` and any other ingest `library_action:`; the second covers the library-lookup writeback-review handoff (`send-msg.sh role/scholar "library-lookup writebacks this job: …"`).
   - **Read-only and fail-open:** the grep never writes; on a grep *error* (rc ≥ 2, e.g. unreadable file = parse ambiguity) it treats the message as a match and dispatches. Only an unambiguous absence of every marker (rc 1) skips a fresh broadcast.
   - Updated the file-header description of condition #3 to match.

2. **Added `scripts/jobs/test/scholar-preflight-test.sh`** (no prior scholar-preflight test existed; mirrors the hermetic `upgrade-monitor-test.sh` shape — throwaway bare journal as origin, gate clones from it via `GARDEN_SCHOLAR_PREFLIGHT_CLONE`). 10 assertions, all passing:
   - fresh **informational** broadcast (mirrors the leaked `…154517Z-423c15.md`) → **exit 2** + skip logged;
   - fresh **`library_action: ingest-source`** → **exit 0**;
   - fresh **writeback-review** request → exit 0;
   - stale (pre-`last_dispatched`) ingest ask → exit 2;
   - mixed stale-ingest + fresh-informational → exit 2 (guards the timestamp-only regression);
   - plus the nothing-present and condition-#1 (unread inbox) short-circuits, confirming the filter didn't disturb conditions #1/#2.

**What changed:** `scripts/jobs/scholar-preflight.sh` (+39/−8), new `scripts/jobs/test/scholar-preflight-test.sh` (+180). Committed and CAS-pushed to `main2` (`c57e7f3d1`, clean on attempt 1; `origin/main2` now at that sha).

**Verification:** `bash -n` clean; full test suite 10/10 PASS.

**Follow-ups:** None required. The fleaked-idle behavior described in the spec (the 2026-06-29T16:35:14Z scholar-library-cycle) is now gated out deterministically. No test-runner registry needed updating — each `*-test.sh` under `scripts/jobs/test/` is standalone, and the new file follows that convention.

Self-improvement: the gate's marker set was derived from the role's *always-read* predicate (AGENT.md step 2) rather than invented, so the gate and the role agree on what "ingest work" means — consistent with the standing lesson that a directive belongs in the doc a role reads every job, not a one-off.
