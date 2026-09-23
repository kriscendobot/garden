Job complete.

## Completion report

**Job:** Harden `scripts/jobs/handlers/ci-rollup-gh.sh` against transient GitHub network blips.

**Finding:** The core of this job was already implemented and merged into `main2` by earlier commits (`36a2bf0c7`, `3739f2c03`, `a89146728`):
- `common.sh` has `gh_pr_view_retry` (line 1040) — the `gh pr view` sibling of `gh_api_retry`, driving the same `_gh_api_stderr_is_transient` + full-jitter `backoff` loop bounded by `GARDEN_GH_API_ATTEMPTS`. Definitive failures (404/401/403/422) fail fast with no retry; only transient signatures retry; exhaustion still fails nonzero (never a false green).
- `ci-rollup-gh.sh` line 56 already routes its read through `gh_pr_view_retry`, preserving the "never guess a state → exit 1" discipline.
- `ci-watcher-test.sh` subtest L already covers the handler end-to-end, including the transient-then-success recovery cases (RED→exit 0, GREEN→exit 10) proving a recovered read yields the real settled verdict rather than skipping.

**What I added:** The one genuine gap was that `gh-api-retry-test.sh` unit-tested `gh_api_retry` directly but had **no direct unit test of the `gh_pr_view_retry` sibling** (only integration coverage via the handler). I added **SUBTEST 3** driving `gh_pr_view_retry` directly over a stubbed `gh pr view`:
- clean success → single call, payload returned;
- transient-then-success (real `net/http: TLS handshake timeout` wording) → retried to a **settled verdict, not a skip** (the job's core case, at the helper level);
- transient-always → nonzero + empty after exactly `GARDEN_GH_API_ATTEMPTS`;
- definitive error → not retried (single call, nonzero, empty).

I made the shared `gh` stub honor a `GH_STUB_TRANSIENT_STDERR` override (defaulting to the existing 503, so SUBTEST 2 is unchanged) so the new case exercises the actual TLS-timeout signature.

**Verification:** `gh-api-retry-test.sh` 29/0 (was 25/0); `ci-watcher-test.sh` 29/0. Committed and pushed to `main2` (`7cf55fc46..304f3dcba`). Inbox drained (empty).

**Follow-ups:** None.
