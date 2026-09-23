Pushed to `main2` on the first attempt.

## Completion report

**Job:** Make the `garden-issue-inbox` enumeration FATAL diagnosable — the swallowed `gh` stderr was hiding the real HTTP cause.

**What I did** — in `scripts/jobs/handlers/issue-source-gh.sh`:
- Replaced `2>/dev/null` with per-pipeline stderr capture to temp files at all three `gh_api_retry` call sites: the section-1 NEW ISSUES enumeration (~L76), the section-2 NEW ISSUE COMMENTS enumeration (~L100), and the `issue_meta` parent-issue join (~L93). Distinct temp files so the three diagnostics never clobber each other; an `EXIT` trap reaps them even when `die` exits.
- Added a small `_errtail` helper (one-line, whitespace-squeezed tail, `<none>` when empty) and spliced its output into the three failure messages: both `die` calls (`… failed (rc=$?; gh: <tail>)`) and the in-loop `exit 3` FATAL for a failed parent-issue join.
- Updated the file's "Stderr policy" comment block to document the capture-not-discard behavior.

**Semantics preserved:** success path stays quiet (capture is only read on the failure branch); the `rc=$?` still reflects the pipeline exit; fail-the-tick / hold-the-cursor behavior is untouched. The change only makes the existing FATAL name its cause.

**Verification:**
- `bash -n` clean; `shellcheck -x` shows only the two pre-existing benign warnings (SC1091 source-follow, SC2034 `GARDEN_TAG` used via `common.sh`), no new ones.
- End-to-end with a fake `gh` emitting `HTTP 401: Bad credentials`, the FATAL now reads `… issues enumeration for kriskowal/garden failed (rc=1; gh: … HTTP 401: Bad credentials …); failing the tick so the cursor holds` — the HTTP status is now visible.

**Note:** the spliced tail includes `gh_api_retry`'s own final WARN line (it logs to fd 2, which the pipeline now captures), so the message nests the WARN inside the FATAL — slightly verbose but it carries the underlying status, which is the point.

**Follow-up:** As the job anticipated, the likely root cause of the live signature is the bot's `gh` token needing refresh (fast definitive fail while journal git reads succeed). The next occurrence's tail will confirm auth vs 403 rate-limit vs network for a responder. No code follow-up required.

**Commit:** `a6abf505f4` on `origin/main2`.
