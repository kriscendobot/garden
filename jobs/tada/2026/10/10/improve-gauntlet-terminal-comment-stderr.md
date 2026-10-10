I fixed the terminal-comment failure path in `scripts/jobs/gauntlet.sh` and pushed it to main2 as `d1b7c3337c1`. `scripts/jobs/test/gauntlet-test.sh` passes 96/0 and `shellcheck -S warning` is clean.

**What changed**
- **The cause is now in the log:** a failed terminal PR comment's WARN line now ends with the first ~200 characters of gh's stderr, with newlines flattened. It reads `(no stderr)` if gh printed nothing. The "could not check for terminal PR status comment" WARN on the comment-list read gets the same tail. The 2026-10-10 pr346 case would now show whether it was a rate limit, an auth error or a missing PR.
- **Permanent failures stop retrying:** a new check, `is_gh_permanent_failure_text`, matches 404, 410, "Not Found", "Could not resolve to a PullRequest/Repository/Issue", "was deleted", locked conversations and closed issues/PRs. A match logs one WARN marked "permanent; not retrying" and gives up, so no pending receipt is created and an existing one is dropped. The rate-limit check runs first, so a quota 403 is still treated as retryable and starts the cooldown as before.
- **The read is covered too:** a deleted PR fails the comment-list read before the post is ever tried, so a write-only check would never have caught it.

**Behaviour changes to know about**
- When an existing pending receipt is dropped this way, the journal commit says "delivered", because that function treats "posted" and "can never be posted" alike. The WARN line is the accurate record.
- 404 is now final. A token that has lost access to a private repo also gets a 404, so that receipt is dropped rather than retried for up to 7 days.

**Tests**
- The g14 case now feeds two lines of stderr into the failing write and checks the WARN contains them flattened onto one line.
- A new g14p case writes a "issue is locked" error and checks that the gauntlet finishes, no pending receipt is created, no comment is posted, and the "not retrying" WARN carries the stderr.
- The test stub's read failure used to print a 404, which would now count as permanent and break the read-retry test (subtest 14). It now prints a 401 "Bad credentials" error, which is still retried.

**Follow-up:** the deployed root checkout needs to advance past `d1b7c3337c1` before production logs show the new WARN text.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-gauntlet-terminal-comment-stderr.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (715945 cached reads)
- Output: 8241 tokens
- Cost: $0.8534089999999999
- Wall-clock: 301s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
