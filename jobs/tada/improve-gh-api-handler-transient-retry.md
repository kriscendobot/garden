Inbox empty. Work is complete and landed on `main2`.

---

## Completion report

**Job:** `improve-gh-api-handler-transient-retry` — add a shared bounded-retry wrapper for read-only gh handlers so a transient GitHub blip no longer escalates a self-healing tick to a Failed unit.

**What I did**

1. **Added `gh_api_retry` + `_gh_api_stderr_is_transient` to `scripts/jobs/common.sh`** (placed beside the existing `_fetch_stderr_is_offline` classifier). `gh_api_retry <gh-api-args…>` wraps `gh api` in a bounded full-jitter loop (`GARDEN_GH_API_ATTEMPTS`, default 4) using the canonical `backoff "$attempt"`. It captures stdout and stderr separately and:
   - prints captured stdout and returns 0 **only** on a clean success;
   - on a **definitive** failure (404/401/403/422 — anything not matching the transient signature set `GARDEN_TRANSIENT_GH_API_SIGNATURES` = 5xx / 429 / rate-limit / secondary-rate / abuse + the shared `GARDEN_OFFLINE_SIGNATURES` network set) it does **not** retry — breaks immediately so the caller's `|| die` fires fast and loud;
   - on a **transient** failure it retries under backoff; once exhausted it still returns nonzero with **empty** stdout, so the caller never acts on a guessed state. The captured gh stderr is surfaced in a WARN log on final failure so triage isn't blind.

2. **Converted all 8 read-only gh handlers** to call `gh_api_retry` instead of a bare `gh api`: `mirror-pr-state-gh.sh` (the endojs/endo#3137 trigger), `pr-author-gh.sh`, `mention-trust-gh.sh`, `mention-source-gh.sh` (4 calls), `mention-reactji-gh.sh`, `comment-source-gh.sh` (5 calls, including the structural open-PR/rids walk whose stderr-buffer plumbing I preserved), `comment-reactji-gh.sh`, `issue-source-gh.sh` (3 calls). Each keeps its existing fail-open / `|| die` / `2>/dev/null` semantics — the only new behavior is transient-blip absorption. The two reactji POSTs are idempotent (dedup no-op), so retrying them is safe; I noted that in their comments. Updated the stderr-policy comments in `comment-source` / `issue-source` to reflect the retry.

3. **Added `scripts/jobs/test/gh-api-retry-test.sh`** (follows the sibling classifier-test pattern): SUBTEST 1 drives the pure classifier (5xx/429/network → transient; 404/422/401/empty → definitive); SUBTEST 2 shadows `gh` with a counter-backed shell function and asserts the helper's success / flaky-then-heal (3 calls) / exhausted-transient (exactly 4 calls, nonzero+empty) / definitive-404-not-retried (1 call) paths and the `|| die` caller idiom. **17/17 pass.**

**Verification**
- `bash -n` clean on all touched files (the CI gate).
- shellcheck: no new warnings in my additions (the pre-existing common.sh/handler warnings are untouched; the one test warning is the verbatim `unset $(…)` scrub the sibling tests also carry).
- Regression run, all green: gh-api-retry (17), mirror-closer (29), comment-watcher (95), mention-watcher (19), issue-inbox-watcher (25), plus the signal-kill/timeout/empty-output/fetch-timeout/stale-lock classifier tests — 0 failures.

**Landed:** commit `f20b18144`, pushed to `origin/main2` (first-attempt CAS, HEAD = origin/main2).

**Notes / follow-ups**
- The local sandbox mounts `/tmp` noexec, so a PATH-stub approach for the test was impossible; I used a `gh` shell function instead, which is both sandbox-proof and CI-portable. No follow-up needed.
- `scripts/jobs/test/*-test.sh` are not wired into the CI workflow (CI runs only `bash -n` over `scripts/` + a narrow shellcheck set + the `tests/checks/` gate). The new test is runnable manually like its siblings; wiring a master test-runner is a separate, pre-existing gap I left untouched.
