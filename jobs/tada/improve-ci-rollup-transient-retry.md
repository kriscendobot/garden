The requested work is already present in the worktree's HEAD (`origin/main2`), landed by two commits that merged after this job was posted. No further changes are needed. Here's my report.

---

**Completion report: improve-ci-rollup-transient-retry**

**Finding:** The job asks to wrap the raw `gh pr view "$pr" -R "$repo" --json …` call (then at line 47) in a bounded transient-network retry. That exact work is **already landed in HEAD** (`f7dccc82d`, `origin/main2`) — the job spec was written against an older tree.

Two commits, both ancestors of the current worktree HEAD, satisfy it:
- `3739f2c03 jobs: bounded transient-network retry for the ci-rollup gh read` — the initial bounded retry.
- `a89146728 jobs: route ci-rollup gh pr view through the canonical transient absorber` — refactored it to route through `common.sh`'s shared `gh_pr_view_retry`, which is strictly better than an inline loop (single source of truth, no drift with the `gh api` path).

**Current behavior (`scripts/jobs/handlers/ci-rollup-gh.sh:56-57`) verified against every requirement in the spec:**
- **Bounded retry reusing the backoff idiom:** the read goes through `gh_pr_view_retry` (`common.sh:1040`), which drives `backoff "$attempt"` with full-jitter up to `GARDEN_GH_API_ATTEMPTS` (default 4) — the same idiom as `gh_api_retry`.
- **Absorbs transient TLS/DNS/reset in-call:** retries only on `_gh_api_stderr_is_transient` matches (`GARDEN_TRANSIENT_GH_API_SIGNATURES` includes `net/http: TLS handshake timeout`, `dial tcp`, `no such host`, `i/o timeout`, 5xx, throttle) — turning the `#472` TLS-timeout skip into a sub-second recovery.
- **Conservative semantics intact:** after the budget is spent it still returns nonzero, and line 57's `|| { log …; exit 1; }` preserves the captured-stderr WARN and skip-never-guess exit. A definitive 404/401/403/422 fails fast+loud, never retried.
- **No steady-state volume increase:** only failures retry; the happy path is one call.
- **Circuit breaker untouched:** the ci-watcher's rate-limit breaker still trips on a real cascade (unchanged code path).

**Changes made:** none required — the desired end-state already exists. Syntax-checked both files clean. Inbox empty. Nothing to commit or push.

**Follow-ups:** none.
