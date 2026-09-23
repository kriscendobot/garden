## Completion report

**Finding:** The retry hardening this job asks for was **already implemented** in prior commits `3739f2c03` and `a89146728`. `scripts/jobs/handlers/ci-rollup-gh.sh` no longer does a bare `gh pr view` — it routes through `common.sh`'s canonical `gh_pr_view_retry`, which absorbs a transient blip (any signature in `GARDEN_TRANSIENT_GH_API_SIGNATURES`, including `net/http: TLS handshake timeout`) under a bounded full-jitter `backoff` up to `GARDEN_GH_API_ATTEMPTS`, surfaces the gh stderr, and only after the budget is spent falls through to `exit 1` (watcher skips, never guesses). Definitive failures (404/401/403/422) are not retried. This satisfies the harden-the-read half of the job exactly as specified.

**Gap I closed:** The existing test section L only exercised **budget exhaustion** (always-fail transient/throttle → exit 1) and **definitive no-retry**. The one case the job explicitly requests — a stub that **fails once then succeeds**, asserting the retry yields the real verdict rather than a skip — was missing. That recovery path is the actual point of the retry.

**What changed** (`scripts/jobs/test/ci-watcher-test.sh`):
- Added a fail-once-then-succeed gh stub (`GH_STUB_FAIL_TIMES` transient failures, then emits configured rollup JSON).
- Assertion 1: one transient TLS blip → exactly 2 attempts (retried once), handler returns the **RED verdict (exit 0 → shepherd trigger)**, not a skip.
- Assertion 2: same recovery with a settled **GREEN** rollup → exactly 2 attempts, handler returns the **actual parsed verdict (exit 10)** — proving it's the real verdict, not merely "some success."
- Updated the section-L header docstring to document the recovery coverage.

**Verification:** Full `ci-watcher-test.sh` run is green — **29 passed, 0 failed**, including the 4 new assertions.

**Follow-ups:** None. The job's two deliverables (bounded transient retry + a recovery test) are both satisfied and pushed to `main2` (commit `c017f7aa5`).
