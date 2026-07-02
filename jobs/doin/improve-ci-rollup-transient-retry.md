In `scripts/jobs/handlers/ci-rollup-gh.sh`, wrap the `gh pr view "$pr" -R "$repo" --json …` call (line 47) in a bounded retry (2–3 attempts with a short `backoff`, reusing the `GARDEN_FETCH_RETRIES`/`backoff` idiom from `common.sh`) so a transient network failure — TLS handshake timeout, DNS, reset — is absorbed in-call rather than costing the PR a full watcher tick. Keep the conservative semantics intact: after the retry budget is spent the call still exits nonzero with the same captured-stderr WARN, so a persistent failure still skips (never guesses) and the ci-watcher's existing rate-limit circuit breaker still trips on a real cascade. This turns the observed single `#472` TLS-timeout skip into a sub-second recovery without increasing steady-state GraphQL volume (only failures retry).

---
claim:
  host: endolinbot2
  gardener: 20
  claimed_at: 2026-07-02T23:22:00Z
