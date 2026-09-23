Done. Worktree cleaned up, inbox empty, change is live on origin/main2.

---

## Completion report — `comment-watcher-no-inactivity-anomaly`

**What I did:** Replaced the comment-watcher's inactivity-inference anomaly with a deterministic positive self-test, per the maintainer directive ("don't treat maintainer inactivity as a report-worthy anomaly. People sleep sometimes."). Built in an isolated worktree off `origin/main2`, committed explicit pathspecs, pushed `HEAD:main2` via a rebase-CAS loop (landed on attempt 1 as `ad31717c5`).

**What changed** (`scripts/jobs/comment-watcher.sh`):
- **Removed** the zero-result-streak block: the `GARDEN_COMMENT_ZERO_STREAK_THRESHOLD` / `GARDEN_COMMENT_ACTIVITY` activity-probe path, the `read/write_zero_streak` helpers, `source_is_active`, and the `silent-comment-watcher-*` "0 comments for N ticks while active → page maintainer" alert. That path conflated a *blind* watcher with a merely *quiet* one (the probe saw an old already-seen comment and called the repo active).
- **Added** a positive self-test: on a zero-result tick, `source_path_healthy()` confirms the comment source path can still fetch a **known-existing** comment (the most-recent comment via the same `gh`+external-`jq` pipe the source uses — the exact 2026-06-24 outage signature). A PASS, or a `gh`/network-transient *inconclusive*, means "just quiet" → report nothing. Only a FAILED self-test (data returned by `gh` but the jq pipe yields nothing) raises a throttled `blind-comment-watcher-*` alert. Self-test is throttled to once per window (`GARDEN_COMMENT_SELFTEST_INTERVAL_SECS`, default 1h) and overridable for tests via `GARDEN_COMMENT_SELFTEST`.
- The `require_tools` hard-dependency guard (loud fail on a missing binary) is untouched.

**Tests** (`scripts/jobs/test/comment-watcher-test.sh`): rewrote cases I and J. **I** — a BLIND source (self-test fails) alerts once and throttles. **J** — a HEALTHY but quiet source produces **no** alert across 6 consecutive zero-result ticks (streak length made irrelevant by forcing the interval to 0). Both pass.

**Verification:** full comment-watcher test suite → 82 passed, 2 failed. The 2 failures (Q and Z) are **pre-existing and unrelated** — confirmed they fail identically on the pristine base with my edits stashed; they exercise `comment-source-gh.sh`'s empty-body review surfacing under a `gh` stub, which I did not touch.

**Follow-up:** Q/Z (`comment-source-gh.sh` not surfacing empty-body `[INLINE-REVIEW]`/`[APPROVED]` reviews under the test's `gh` stub) are failing on `main2` independently of this job — worth a separate investigation/job.
