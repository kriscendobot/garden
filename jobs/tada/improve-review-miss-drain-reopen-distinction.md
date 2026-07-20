Inbox empty. Work is complete.

## Completion report

**Job:** `improve-review-miss-drain-reopen-distinction` — move the "genuine recurrence vs. backlog-drain artifact" judgment out of the prosecutor's head into the deterministic store writer.

**What changed** (`scripts/jobs/review-miss-record.sh`):
- Added two helpers: `is_before` (normalizes two timestamps through `date -d` to epoch seconds so mixed ISO-8601 spellings — `Z`, `+00:00`, offsets — compare correctly; returns false on any empty/unparseable input) and `cluster_improvement_time` (derives the improvement instant from the `improved_by` commit's committer date via `git show -s --format=%cI`, taking the latest of several SHAs; falls back to the `improvement_job` dispatch time — the commit date of the cluster's `→ improvement-dispatched` transition).
- Replaced the blanket `if [ "$oldstatus" = closed ]; then status=open; recurrence=1; fi` with a timestamp comparison: a reopening miss whose `review_at` **predates** the improvement gets `drain_reopen=1` (stays `closed`, no `recurrence`); one that **postdates** it keeps today's `recurrence=1` reopen. Undeterminable timing (no `review_at` or no derivable improvement time) falls back conservatively to `recurrence=1`.
- Surfaced `drain_reopen=<0|1>` in both the `log` line and the `recorded=... recurrence=...` stdout contract; updated the header doc for the new `review_at` field and summary format.

**Tests** (`scripts/jobs/test/review-miss-record-test.sh`): extended `mk_miss` with an optional `review_at` arg; added case 7 (pre-improvement reopen → `drain_reopen=1`, stays closed, member still recorded) and case 8 (post-improvement reopen → `recurrence=1`, reopens). Full suite: **28 passed, 0 failed**. Case 6 (undeterminable timing) still passes, confirming the conservative fallback.

**Docs** (`skills/review-retrospective/SKILL.md`): § 2 now instructs the prosecutor to always set `review_at`; § 6 rewritten to describe the mechanical gate (recurrence vs. drain-reopen vs. conservative fallback) instead of a per-prosecutor eyeball.

**Verification:** shellcheck shows only pre-existing warnings (no new ones). Committed and pushed to `main2` (rebase CAS, first attempt). Activates on the fleet after the next deploy.

**Follow-ups:** none required. The prosecutor must include `review_at` in future records for the distinction to engage on genuinely closed clusters; older records without it use the safe `recurrence=1` fallback.
