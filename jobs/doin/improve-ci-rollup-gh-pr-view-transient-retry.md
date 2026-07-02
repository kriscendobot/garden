Route the single-shot `gh pr view "$pr" -R "$repo" --json state,statusCheckRollup` read in `scripts/jobs/handlers/ci-rollup-gh.sh` (line ~47) through a bounded transient-retry loop instead of exiting 1 on the first failure. Reuse the existing absorber in `scripts/jobs/common.sh` — `_gh_api_stderr_is_transient` + `backoff "$attempt"` under `GARDEN_GH_API_ATTEMPTS` — so a `net/http: TLS handshake timeout` (or any signature in `GARDEN_TRANSIENT_GH_API_SIGNATURES`) is retried, while a definitive 404/401/403/422 still fails fast into the existing "skip, never guess" exit-1 path. This eliminates the recurring `#503/#313/#463 rollup unreadable (TLS handshake timeout)` WARNs where one retry would have recovered. `gh pr view` doesn't go through `gh api`, so either add a thin `gh_pr_view_retry` wrapper in common.sh mirroring `gh_api_retry`, or reimplement the read as a `gh_api_retry graphql …`/REST call so it inherits the absorber directly. Extend `scripts/jobs/test/ci-watcher-test.sh` to assert a transient stderr is retried and a definitive one is not.

---
claim:
  host: endolinbot2
  gardener: 18
  claimed_at: 2026-07-02T20:22:50Z
