---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
`garden-mirror-closer` exits 1 every tick during GitHub primary-quota exhaustion, spawning an LLM self-heal responder per tick and burning ~16 doomed API calls against an already-exhausted quota.

Failure signature (unit journal): repeated `[mirror-pr-state] gh api graphql transient blip (rc=1); retry 2/4..4/4 after backoff: gh: API rate limit already exceeded for user ID 279080640.` → `FATAL: gh api graphql pullRequest state for <repo>#<n> failed` → `[mirror-closer] WARN: 4 mapping(s) failed this tick and were left unresolved` → exit 1.

Fix 1 — `scripts/jobs/common.sh`, `GARDEN_GH_PRIMARY_RATE_LIMIT_SIGNATURES` (~line 3480). The pattern `API rate limit exceeded for user([[:space:]]+ID)?` does not match GitHub's actual wording, which interposes `already`: `API rate limit **already** exceeded for user ID <n>.` The stderr therefore misses the primary-quota fast-fail branch in `gh_api_retry` and is misclassified TRANSIENT by `_gh_api_stderr_is_transient` (it matches the generic `rate limit` alternative), so each call is retried 4× under backoff against a quota that cannot recover before the hourly reset. Widen to tolerate the optional adverb, e.g. `API rate limit ([a-z]+ )?exceeded for user([[:space:]]+ID)?`. Keep the predicate narrower than the transient set — secondary-rate/abuse/HTTP 429 must still be retried. Add a case to `scripts/jobs/test/gh-api-retry-test.sh` (near line 93, which today asserts only the non-`already` variant) covering `gh: API rate limit already exceeded for user ID 279080640.` as PRIMARY, and re-assert that `secondary rate limit` / `HTTP 429` remain non-primary.

Fix 2 — `scripts/jobs/mirror-closer.sh` (handler calls ~line 161 and ~line 178; exit at line 209-212). Fix 1 alone stops the wasted retries but the tick still exits 1, so a quota outage keeps failing the unit and spawning a responder every tick for the whole hour. Capture the handler's stderr per call (temp file, as `gh_api_retry` does) and classify it with `is_gh_primary_rate_limit_text`; count quota-blocked failures separately from real ones. When **every** failure this tick was quota-blocked and nothing else failed, log a WARN naming the quota and exit 0 (degraded, not unhealthy) — the mapping is correctly left unresolved and retried next tick either way. Any non-quota failure keeps the current exit 1. This mirrors the degrade-don't-die handling already in `scripts/jobs/handlers/comment-source-gh.sh:156,221`, and follows the precedent in `mirror-pr-state-gh.sh`'s header comment, where a definitive-but-unactionable error forcing exit 1 forever was treated as the bug. Do not weaken "never guess a state": no mapping may be stamped `closed_at` on an unread state.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-01T23:42:25Z
