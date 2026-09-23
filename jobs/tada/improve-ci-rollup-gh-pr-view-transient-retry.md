Empty inbox. Work is complete and pushed to `main2`.

## Completion report

**Job:** Route the ci-rollup handler's single-shot `gh pr view` read through the fleet's canonical bounded transient-retry absorber instead of a bespoke local loop.

**What I found:** The handler already carried a *bespoke* retry loop (local `is_transient_network` / `is_rate_limited` over `GARDEN_FETCH_RETRIES`), not a single-shot read as the job spec assumed — but it covered a narrower signature set than the canonical absorber and deliberately excluded throttling. The job's real intent (reuse `_gh_api_stderr_is_transient` + `backoff` under `GARDEN_GH_API_ATTEMPTS`) still applied.

**What I changed:**
- **`scripts/jobs/common.sh`** — added `gh_pr_view_retry`, a thin sibling of `gh_api_retry`. Same `_gh_api_stderr_is_transient` classifier, same `GARDEN_TRANSIENT_GH_API_SIGNATURES` set, same bounded full-jitter backoff under `GARDEN_GH_API_ATTEMPTS`. `gh pr view` doesn't route through `gh api`, so it needed its own wrapper; it drives the `gh pr view` transport (which shares the same Go net/http stack, hence the same transient wording). The gh binary is `${GARDEN_GH:-gh}` — the same test seam `ci-wait-merge.sh` uses.
- **`scripts/jobs/handlers/ci-rollup-gh.sh`** — replaced the local retry loop + helper functions with a one-line `gh_pr_view_retry "$pr" -R "$repo" --json …` call that fails fast into the unchanged `exit 1` skip-never-guess path. Switched the gh-binary seam from `GARDEN_CI_ROLLUP_GH` to the fleet-standard `GARDEN_GH`; rewrote the rationale comment.
- **`scripts/jobs/test/ci-watcher-test.sh`** — updated subtest L to assert a transient TLS-handshake stderr is retried to the budget, a throttle is *now also* retried (the canonical absorber owns throttling; the old bespoke rate-limit exclusion is gone), and a definitive 404 is not retried — all falling through to exit 1.

**Behavior change worth flagging:** the old handler deliberately excluded rate-limits from retry (reasoning: ci-watcher's cascade circuit-breaker owns throttling). The canonical absorber treats throttling as transient, and the job explicitly asked that "any signature in `GARDEN_TRANSIENT_GH_API_SIGNATURES` is retried," so throttles are now retried here under the bounded, jittered budget. The circuit-breaker still trips on a persistent unreadable cascade, so this doesn't defeat the throttle protection.

**Verification:** `gh-api-retry-test.sh` (25/25) and `ci-watcher-test.sh` (25/25, all A–L subtests) pass; `bash -n` clean; no dangling references to the removed `GARDEN_CI_ROLLUP_GH` / helper functions; shellcheck clean on the new code.

**Follow-ups:** none.
