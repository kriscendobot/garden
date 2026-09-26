My worktree is gone and the work is landed on `origin/main2`. The job is complete.

---

## Completion report

**Job:** `issue-inbox-watcher: don't drop trusted comments on a closed (or reopened) issue` (kriskowal/garden #10).

**Root cause confirmed:** The closing-etiquette block in `issue-inbox-watcher.sh` applied its "submitter-close is terminal → dispatch nothing" rule to *every* row whose parent issue was currently closed — including `issue-comment` rows. So a trusted maintainer who comments on a closed issue (then reopens it) had those comments dropped and the cursor slid past them. That's exactly how two directives on #10 were lost.

**Fix (landed as `354b981e2` on `origin/main2`):**
1. **Thread a `closed_at` column** through `handlers/issue-source-gh.sh` (issue query + the cached `issue_meta` parent-join), carried with the same `-` sentinel convention as `closed_by` so the TAB-IFS `read` doesn't collapse empty middle fields. TSV grew from 10 → 11 columns.
2. **Re-engagement test in the watcher:** when an issue is closed-by-submitter, a `kind=issue-comment` whose `created_at > closed_at` is treated as re-engagement and **processed**; the close itself and anything at/before it stay terminal and are dropped. When `closed_at` is unknown (empty), the watcher errs toward *processing* a comment rather than risk dropping trusted feedback.
3. **No silent slide:** every genuine drop now logs `kind + id + reason` — the terminal-drop log and the non-maintainer trust-gate drop both name the comment `id`.
4. **Reopen safety** is automatic: a reopened issue is `state=open`, so the etiquette block is skipped entirely.

**Tests (new `scripts/jobs/test/issue-inbox-watcher-test.sh`, 13 assertions, all pass):** post-close trusted comment delivered + cursor advances (A); clean submitter-close dispatches nothing (B); pre-close comment terminal-dropped with id+reason logged (C); untrusted post-close comment dropped by the trust gate with id logged (D); reopen-safety (E); and the **#10 two-comment regression** — both post-close directives delivered, neither lost (F). Stubs use the established comment-watcher-test pattern (no GitHub, no claude). Also smoke-validated the source handler against live data: every emitted row (both kinds, 116 comment rows included) carries exactly 11 columns.

**Process notes:** Built in an isolated worktree off `origin/main2` (the deployed root is behind it — it lacks the per-tick verify-fetch and comment-id idempotency already on main2, so editing the root would have regressed those). Explicit-pathspec commit, rebase-CAS push (landed attempt 1), worktree + scratch dirs cleaned.

**Follow-ups:** None required. The `closed_at` field is additive and only consumed by the etiquette branch; no other consumer of the TSV needed changes. The deployed root will pick this up on the next deliberate deploy.
