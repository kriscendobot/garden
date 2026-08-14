---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Add the missing `is_transient_auth_error` rung to `scripts/jobs/comment-watcher.sh`'s source-failure classification ladder, porting the retry-once-then-degrade shape that `scripts/jobs/pages-watcher.sh:194-221` already implements.

Failure signature (self-heal blob `230eaefd5397612c6a8a184a32bacd6d7d35d7b5`):
```
source: WARN: gh api repos/endojs/endo-but-for-bots/pulls/790/comments?per_page=100 failed (definitive, rc=1); not retrying: gh: Bad credentials (HTTP 401)
source: FETCH-FAIL: surface pulls/790/comments (review-id map) failed to enumerate — freezing cursor
source: FETCH INCOMPLETE for endojs/endo-but-for-bots ... exiting nonzero
FATAL: comment source failed for endojs/endo-but-for-bots (rc=1; see source stderr above)
```

Why: GitHub serves a brief `HTTP 401: Bad credentials` while an OAuth/installation token rotates, then the identical call succeeds. `gh_api_retry` deliberately treats 401 as definitive (asserted in `scripts/jobs/test/gh-api-retry-test.sh:82`), and `comment-source-gh.sh`'s LOST-FETCH invariant correctly freezes the cursor and exits nonzero. Both layers are right. The gap is in the watcher: `comment-watcher.sh:1399-1427` absorbs `is_nonattributable_rc`, `is_transient_net_error`, and `is_transient_gh_source_error`, but has no rung for a 401 — and `is_transient_gh_source_error`'s contract (`common.sh:435`) explicitly excludes 401 rotations, deferring them to `is_transient_auth_error`. So a self-healing rotation blip reaches `die` and detonates a systemd restart + self-heal responder. Credential verified live at diagnosis time (`gh api user` → `kriscendobot`, rc=0; unit `NRestarts=0`), confirming rotation blip, not a revoked token.

What to change in `scripts/jobs/comment-watcher.sh`:
1. Factor the source invocation at lines 1382-1393 (the `timeout`-wrapped backgrounded path plus the no-`timeout` fallback, both writing `$SRC`/`$ERRF` and setting `src_rc`) into a `run_source()` function so it can be re-invoked, mirroring pages-watcher's seam. Preserve the `SOURCE_TIMEOUT_PID` set/clear around `wait` exactly — the cleanup trap depends on it to TERM the process group mid-fetch.
2. Insert an `is_transient_auth_error "$ERRF"` rung AFTER the `is_transient_gh_source_error` check and BEFORE the final `sed`/`die` at lines 1426-1427: log a WARN, sleep a short backoff behind a new `GARDEN_COMMENT_AUTH_RETRY_SLEEP` knob (defaulted next to the other `GARDEN_COMMENT_*` defaults, same shape as `GARDEN_PAGES_AUTH_RETRY_SLEEP`), then `run_source` once.
3. On retry success, fall through to the normal processing path unchanged.
4. On retry failure, re-classify against the retry's `$ERRF` (echo it prefixed `source(retry): `): transient-net → `exit 0`; still-401 → WARN "persistent 401" and `exit 0` so the warning repeats every tick until a human fixes the credential (never swallowed into "all green"); anything else → `die` as today.

Invariant to preserve and state in the commit message: every absorb path must `exit` BEFORE sorting `$SRC` or sliding `last_seen`, so the cursor stays frozen and the next healthy tick re-polls the un-enumerated comments. Absorbing the 401 must not weaken the LOST-FETCH guarantee — it only stops a recoverable blip from becoming a unit failure.

Test: extend `scripts/jobs/test/comment-watcher-test.sh` with a stub source that emits `gh: Bad credentials (HTTP 401)` at rc=1 on the first call and succeeds on the second (the shape already used by `scripts/jobs/test/pages-watcher-test.sh:151-159`), asserting the watcher exits 0, processes the retry's comments, and does not `die`; plus a twice-401 case asserting exit 0, the persistent-401 WARN, and an unmoved cursor. Run `scripts/jobs/test/comment-watcher-test.sh` and `scripts/jobs/test/gh-api-retry-test.sh`.
