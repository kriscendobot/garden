---
role: gardener
tier: mentor
handler-timeout: 7200
split-indivisible-reason: 'the fix is one critical section inside gh_api_retry (scripts/jobs/common.sh:5451): take the gh-api cooldown flock, re-check the all-API marker under it, issue the request, and on a primary-quota refusal write the latch BEFORE releasing the flock. Admission, re-check, and latch-before-release must land together; any partial child (lock without latch, or latch without serialized admission) leaves the exact 19:35:34-35 race in place and ships no observable fix, and its regression test (concurrent stubbed callers, exactly one doomed request) exercises all three at once.'
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-29T21:56:38Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 7200
split-indivisible-reason: the fix is one critical section inside gh_api_retry (scripts/jobs/common.sh:5451): take the gh-api cooldown flock, re-check the all-API marker under it, issue the request, and on a primary-quota refusal write the latch BEFORE releasing the flock. Admission, re-check, and latch-before-release must land together; any partial child (lock without latch, or latch without serialized admission) leaves the exact 19:35:34-35 race in place and ships no observable fix, and its regression test (concurrent stubbed callers, exactly one doomed request) exercises all three at once.
---
# improve-gh-api-primary-quota-singleflight-expanded-window

Expanded-window re-run of `improve-gh-api-primary-quota-singleflight` (the ordinary claim hit its 2400s wall once).

## Task (garden repo, main2)

`scripts/jobs/common.sh` `gh_api_retry` (≈line 5451) lets concurrent REST calls pass before the primary-quota latch is written; at 19:35:34–19:35:35 two comment sources were refused. Serialize gh-api admission with the cooldown lock (`GARDEN_API_COOLDOWN_LOCK`, see `api_cooldown_active` / `start_api_cooldown` ≈lines 924–1073), re-check the all-API marker under it, and latch primary-quota failures (`start_api_cooldown <tag> "$(api_primary_quota_secs)"`) before releasing it, so sibling watchers skip without another doomed request.

Guidance to stay inside the window:
- Keep the change local to `gh_api_retry` plus a small helper; do not re-plumb callers. Honor the `GARDEN_API_COOLDOWN_SECS=0` disable hatch (no lock, old behavior) and do not hold the flock across transient backoff sleeps longer than needed — decide whether admission is serialized per attempt (recommended) vs. the whole retry loop, and document it.
- Beware deadlock: callers that already hold fd 9 / call `start_api_cooldown` inside the lock must not re-enter the same flock (use a distinct fd or pass-through).
- When admission finds a live all-API (or REST) marker, return nonzero without calling gh, with a distinct log line.
- Extend `scripts/jobs/gh-api-retry-test.sh` / `api-cooldown-test.sh` (stub `gh-api-primary-rate-limit-stub.sh` exists): N concurrent callers against a primary-quota stub produce exactly one gh invocation and a latched marker. Run both tests plus any comment-latency/ci-watcher tests that source common.sh.
- Update the prose in CLAUDE.md § Monitoring safety (latency-watch paragraph) only if the latch semantics it describes change.

Commit explicit pathspecs and push to main2 with the rebase CAS loop under `garden_repo_lock`.

split-indivisible-reason: the fix is one critical section inside gh_api_retry (scripts/jobs/common.sh:5451): take the gh-api cooldown flock, re-check the all-API marker under it, issue the request, and on a primary-quota refusal write the latch BEFORE releasing the flock. Admission, re-check, and latch-before-release must land together; any partial child (lock without latch, or latch without serialized admission) leaves the exact 19:35:34-35 race in place and ships no observable fix, and its regression test (concurrent stubbed callers, exactly one doomed request) exercises all three at once.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-29T22:08:21Z
