---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
The `garden-mirror-closer` unit exits 1 whenever the bot's GitHub primary hourly quota is exhausted, because `GARDEN_GH_PRIMARY_RATE_LIMIT_SIGNATURES` (scripts/jobs/common.sh:3478) does not match gh's client-side pre-flight wording. Observed stderr: `gh: API rate limit already exceeded for user ID 279080640.` — gh emits this "already exceeded" variant when it short-circuits from its cached rate-limit state instead of issuing the request. The signature only anchors `API rate limit exceeded for user( ID)?`, so the interposed `already` defeats it; verified by direct grep against both signature sets.

Two defects follow, fix both:

1. **Misclassification (scripts/jobs/common.sh:3478).** Widen the primary-quota signature to accept the optional `already` (e.g. `API rate limit (already )?exceeded for user([[:space:]]+ID)?`), so `is_gh_primary_rate_limit_text` matches and the existing fast-fail branches at common.sh:3529 (`gh_api_retry`) and common.sh:3654 (`gh_pr_view_retry`) fire as designed. Today the text falls through to the `rate limit` alternative in `GARDEN_TRANSIENT_GH_API_SIGNATURES` and is retried 4x under backoff per call — 3 `transient blip (rc=1); retry N/4` lines then `failed after 4 transient attempt(s)` for every one of 4 mappings in the captured tick — against a quota that cannot reset inside a millisecond-scale budget. Keep the predicate strictly narrower than the transient set: secondary-rate/abuse/HTTP 429 must still classify transient. Add both wordings to scripts/jobs/test/gh-api-retry-test.sh, which today asserts only the `exceeded for user ID … (HTTP 403)` variant at line 93 and so did not catch this; the `already` form must never regress to transient.

2. **Tick-level degrade (scripts/jobs/mirror-closer.sh:149-213).** Even correctly classified, the closer counts a quota refusal as a plain per-mapping failure and exits 1 (line 210-213), failing the unit and spawning an LLM self-heal responder on every tick for the entire ~1h quota window. Honor the contract common.sh:3527-3529 already states ("let the caller freeze/degrade the tick"): track quota-refused mappings separately from genuine failures and, when every failure this tick was a primary-quota refusal, log a loud WARN and exit 0 — nothing was mis-stamped (no `closed_at` is written on a failed read, so the next tick re-handles), so this is a deferred tick, not a lost close. A tick with any non-quota failure must keep exiting 1 as it does now. Propagation needs a channel the current code lacks: scripts/jobs/handlers/mirror-pr-state-gh.sh uses `die` (rc 1, common.sh:410) for every failure, so the closer cannot tell quota from 404 by exit code — have the handler exit a distinct reserved code (e.g. 75/EX_TEMPFAIL) when `is_gh_primary_rate_limit_text` matches the failure, and branch on it at both handler call sites (mirror-closer.sh:162 upstream read and :178 mirror read). Precedent for the degrade shape: `fetch_primary_quota` in scripts/jobs/handlers/comment-source-gh.sh:221. Preserve "never guess a state" throughout — a quota-refused mapping is skipped and left unresolved, never assumed open or closed. Extend test/mirror-closer-test.sh with a stub handler returning the quota code to pin exit 0 + unresolved mapping, and a mixed quota-plus-404 tick to pin exit 1.

Other `gh`-driven services on this host (ci-watcher, the comment/mention watchers) share these two helpers and were failing the same way during the window, so fix 1 is fleet-wide, not mirror-closer-specific.



<!-- garden-transient-elapsed: kind=signature through=1 values=2,1 -->

<!-- garden-reaped: 2 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 10
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-04T09:51:24Z
