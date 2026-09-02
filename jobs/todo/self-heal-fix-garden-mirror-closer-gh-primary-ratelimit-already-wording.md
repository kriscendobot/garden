---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
`GARDEN_GH_PRIMARY_RATE_LIMIT_SIGNATURES` in `scripts/jobs/common.sh` (~line 3529) misses gh's client-side primary-quota wording, defeating the primary-quota fast-fail in `gh_api_retry`.

Failure signature (garden-mirror-closer, exit 1, 4/4 mappings failed):
```
[mirror-pr-state] gh api graphql transient blip (rc=1); retry 2/4 after backoff: gh: API rate limit already exceeded for user ID 279080640.
... retry 3/4 ... retry 4/4 ...
[mirror-pr-state] WARN: gh api graphql failed after 4 transient attempt(s) (rc=1): gh: API rate limit already exceeded for user ID 279080640.
[mirror-pr-state] FATAL: gh api graphql pullRequest state for Agoric/agoric-sdk#11031 failed (no usable PR state for the closer)
```

Root cause: the signature is `API rate limit exceeded for user([[:space:]]+ID)?`, which matches GitHub's server body but NOT gh's client-side preflight refusal `API rate limit already exceeded for user ID <n>`. So `is_gh_primary_rate_limit_text` returns false, the generic `rate limit` alternative in `GARDEN_TRANSIENT_GH_API_SIGNATURES` matches instead, and the call is retried 4× under backoff — precisely the behavior the primary-quota branch exists to prevent. Each retry is a guaranteed-doomed request against an already-exhausted quota (16 per mirror-closer tick at 4 mappings).

What to change:
1. In `scripts/jobs/common.sh`, widen the primary signature to accept the optional adverb, e.g. `API rate limit (already )?exceeded for user([[:space:]]+ID)?`. Keep it narrower than the transient set — secondary-rate/abuse/HTTP-429 must still be retried; do not weaken that distinction. Update the adjacent block comment to note both wordings (server body vs gh client-side preflight) and that `already` is what was missed.
2. Add a regression case to `scripts/jobs/test/gh-api-retry-test.sh` alongside the existing line-93 assertion: `is_gh_primary_rate_limit_text "gh: API rate limit already exceeded for user ID 279080640."` must return 0, and the existing non-primary cases (secondary rate limit, abuse detection, HTTP 429) must still return 1 so the widening cannot swallow the retryable throttles.
3. Verify the fast-fail path end-to-end with the existing `GARDEN_GH` stub seam (a stub printing the `already exceeded` wording to stderr must produce exactly ONE attempt and a `RATE LIMITED by GitHub primary quota` WARN, not four `transient blip` lines).

Note the residual (do NOT fix in this job unless it is trivial and clearly in scope): even with the fast-fail restored, `mirror-closer.sh:212` still exits 1 whenever any mapping failed, so a fleet-wide quota exhaustion re-triggers this LLM self-heal responder on every tick until the hourly reset. `comment-watcher.sh:1521` and `handlers/comment-source-gh.sh:489` already model the alternative (freeze the cursor, log `RATE LIMITED`, degrade the tick). If a follow-up is warranted, post it separately rather than widening this one.
