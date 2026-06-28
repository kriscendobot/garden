Inbox is empty. Work is complete.

---

## Completion report

**Job:** `improve-deadmail-timeout-and-surface-post-failures`

**What I did:** Hardened the promote call in `scripts/jobs/deadmail.sh` so a wedged or failing `post-job.sh` self-diagnoses instead of silently stalling the whole deadmail tick.

**What changed** (one commit, pushed to `origin/main2` as `705d27c01`):
- Wrapped the promote in `timeout "${GARDEN_POST_TIMEOUT:-120}"`. `post-job.sh` can hang indefinitely on a stale producer `journal.lock` (per `feedback_stale_producer_lock_wedges_posts.md`); the unbounded call wedged the entire tick and, under `Restart=always`, could crash-loop into systemd's start-limit. The timeout is overridable via `GARDEN_POST_TIMEOUT` for tests/tuning.
- Replaced `2>&1` (which swallowed all diagnostics) with stderr capture to a temp file, logged on failure via the existing `log` helper (`WARN`-prefixed, so it gets a syslog level in the journal).
- Distinguished the two failure modes: a `124` exit logs a timeout message with the stale-lock hint; any other non-zero exit logs the actual `rc`.
- Used the `if/else` form (not `if ! cmd`) so the else branch captures `post-job`'s **real** exit code — `! cmd` would clobber `$?` to the boolean negation and lose `timeout`'s 124. Verified the 124-capture behavior with a live `timeout 1 sleep 5` smoke test.

**Notes:**
- Built in an isolated worktree off `origin/main2` (the shared root tree was being concurrently mutated by other gardeners, and the root checkout is a deployed version, not a dev tree).
- A `verify_posted` guard landed concurrently on `main2` while I worked; my rebase integrated cleanly with it — the timeout/stderr handling and the post-verification guard now coexist (the verify runs only after a successful, bounded post). `bash -n` passes; no new shellcheck findings introduced.

**Follow-ups:** None required. The same unbounded-`post-job` pattern may exist in sibling producers (e.g. other promote/post call sites); worth a sweep, but out of scope for this job.
