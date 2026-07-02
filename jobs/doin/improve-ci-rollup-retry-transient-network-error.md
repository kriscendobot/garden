In `scripts/jobs/handlers/ci-rollup-gh.sh` (line ~47), a single `gh pr view … --json state,statusCheckRollup` failure surfaces as rc=1 and the watcher skips the PR's CI state ("never guess"). This tick that skip was caused by a purely transient network fault — `Post https://api.github.com/graphql: net/http: TLS handshake timeout` — not a rate-limit throttle. The connection never established, so it consumed no rate-limit budget, which means the ci-watcher's anti-cascade rule (don't re-fire GraphQL at an already-throttled API) does NOT apply here. Harden it: before treating the gh failure as unreadable, inspect the captured stderr (`$gh_err`) and, only when it matches a transient network signature (`TLS handshake timeout|net/http|connection reset|timeout|EOF|i/o timeout`) and NOT a rate-limit/403/secondary-limit signature, retry the `gh pr view` once or twice with a short sleep (e.g. 2s, 5s) before giving up and emitting the existing skip. Leave 403 / rate-limit / auth failures on the immediate-skip path untouched so the cascade fix is preserved. This recovers CI states that are currently dropped to a guess-free skip on a recoverable blip, without deepening any real throttle.

---
claim:
  host: endolinbot2
  gardener: 10
  claimed_at: 2026-07-02T22:21:40Z
