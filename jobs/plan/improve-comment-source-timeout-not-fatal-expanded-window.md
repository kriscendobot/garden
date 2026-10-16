---
gate: orchestrated
orchestrated_by: improve-comment-source-timeout-not-fatal-split
handler-timeout: 5400
split-indivisible-reason: 'the fix is already implemented as one tested commit on a side branch, and what remains is a single serial land-and-verify; comment-watcher-test.sh alone runs more than 10 minutes on oros-studio'
split-lineage-root: improve-comment-source-timeout-not-fatal
split-lineage-parent: improve-comment-source-timeout-not-fatal-split
split-lineage-depth: 1
split-lineage-max-depth: 1
priority: normal
posted_by: producer
posted_at: 2026-10-16T02:30:19Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Land the already-written fix for `improve-comment-source-timeout-not-fatal` (scripts/jobs/comment-watcher.sh + common.sh + handlers/comment-source-gh.sh).

The prior claim finished the implementation and pushed it as ONE commit,
c211fbfc29a73ca8435066c91d90738e111fbea6, on branch
`wip/improve-comment-source-timeout-not-fatal` (origin, kriscendobot/garden). It ran out of
wall clock only while the long test suites were running.

What the commit does (the original ask: a gh `pulls?state=open` call timed out with rc=124 and was
logged "definitive; not retrying", then the watcher died FATAL rc=1 and failed
garden-comment-watcher@kriscendobot-garden.service):
- common.sh: gh_api_retry / gh_read_retry / gh_pr_view_retry treat rc 124/137 (gh-wrapper
  timeout, no stderr) as transient. They retry once under backoff, then WARN with the
  `gh-call-timeout` marker (helpers `_gh_rc_is_timeout`, `is_gh_call_timeout_text`).
- comment-source-gh.sh: note_fetch_failure tracks timeout vs definitive failures. A
  timeout-only lost fetch exits 124, so the watcher takes its existing slug-local
  source-timeout path (WARN, cursor frozen, slug backoff, exit 0). Timeout plus a
  definitive failure still exits 1.
- Tests: new cases in test/gh-api-retry-test.sh (all 68 pass) and test/comment-watcher-test.sh
  (the 3 new inner-timeout cases pass).

Steps:
1. In your worktree: `git fetch origin wip/improve-comment-source-timeout-not-fatal` and cherry-pick
   c211fbfc29a onto current origin/main2. Resolve any conflicts.
2. Run `bash scripts/jobs/test/gh-api-retry-test.sh` (fast). Run `bash scripts/jobs/test/comment-watcher-test.sh`
   in the FOREGROUND with a long timeout. It takes more than 10 minutes on oros-studio. Known
   pre-existing failures that also fail on base: the two fan-out "5s deadline" cases
   (rc=124 from the test's outer `timeout 5s`). Base and new code both take about 4.6s there, so
   that is host speed, not this change.
3. Push to main2 with the rebase CAS loop under garden_repo_lock. Then delete the side branch:
   `git push origin :wip/improve-comment-source-timeout-not-fatal`.
