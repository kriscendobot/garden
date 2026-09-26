Inbox is empty. Work is complete.

## Completion report

**Job:** Make the source-failure watchers absorb GitHub's HTML/5xx overload pages as a transient blip instead of dying (which detonates a systemd restart storm).

**What I did:**
- **`scripts/jobs/common.sh`** — added a shared `is_transient_gh_source_error <stderr-file-or-string>` helper next to its siblings `is_transient_net_error`/`is_transient_auth_error`. It slurps a file or matches a string and defers to the existing `_gh_api_stderr_is_transient` / `GARDEN_TRANSIENT_GH_API_SIGNATURES` set (which already carries the `invalid character '<'`, `HTTP 5NN`, `HTTP 429`, `rate limit`, `EOF`, `server misbehaving` signatures from commit 9cf685607d), so the HTML-instead-of-JSON class is classified in one place.
- **`scripts/jobs/pages-watcher.sh`** — factored a `classify_source_failure` helper that WARNs + `exit 0` on a transient gh-api blip, and wired it into **both** die sites (first pass and post-401 retry) so they stay in sync. Ordered after the net/auth checks and before the final `die`.
- **`scripts/jobs/ci-watcher.sh`** (line ~262) and **`scripts/jobs/comment-watcher.sh`** (line ~1151) — added the same third transient bucket via `is_transient_gh_source_error`, ordered after the net check and before `die`.
- **`scripts/jobs/test/pages-watcher-test.sh`** — added hermetic sections **I** (HTML/decoder stub, rc=1 → asserts clean `exit 0` skip, no job) and **J** (structural 404 stub → asserts the loud die, no job), mirroring `mirror-closer-test.sh` §K.

A genuinely structural failure (real 404, malformed slug) still dies loud — the buckets narrow the die, they never swallow a real bug ("never guess a state" preserved).

**Verification:** `pages-watcher-test.sh` 16/16 pass (including new I/J); sibling suites green (`ci-watcher-test` 43, `comment-watcher-test` 213, `mirror-closer-test` 39); `bash -n` clean on all four scripts.

**Committed & pushed** to `main2` (`da38debdf4..50b75d434c`).

**Note / follow-up:** My initial edits accidentally landed in the deployed garden root (I used `/home/kris/garden2/...` absolute paths); I stashed them out of the deployed root, transferred them via patch into this job's worktree, dropped the deployed-root stash, and confirmed the deployed root's `scripts/` is clean. No stray changes remain there. No other follow-ups.
