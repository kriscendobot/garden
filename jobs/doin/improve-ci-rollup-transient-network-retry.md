In scripts/jobs/handlers/ci-rollup-gh.sh, wrap the single `gh pr view "$pr" -R "$repo" --json state,statusCheckRollup` call in a bounded retry (mirroring clone-keeper.sh's bounded_fetch: up to GARDEN_FETCH_RETRIES attempts with backoff), but retry ONLY when the captured stderr matches a transient-network class — `TLS handshake timeout`, `connection reset`, `i/o timeout`, `unexpected EOF`, `Temporary failure in name resolution` — and NOT when it matches rate-limiting (`rate limit`, `API rate limit exceeded`, `403`), since ci-watcher.sh already has a cascade circuit-breaker for throttling and a retry there would only deepen the cooldown. On exhausting the retry budget, fall through to the existing `exit 1` (watcher still skips, never guesses). This absorbs the transient-TLS-timeout unreadable seen on endojs-endo-but-for-bots#286 so a single network blip no longer drops a PR's CI verdict for a full tick (and can't let a red CI go unshepherded). Extend scripts/jobs/test/ci-watcher-test.sh (or add a ci-rollup handler test) with a GARDEN_CI_ROLLUP stub asserting a transient-error stderr triggers a retry while a rate-limit stderr does not.

---
claim:
  host: endolinbot2
  gardener: 16
  claimed_at: 2026-07-02T19:52:25Z
