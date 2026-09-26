---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
`scripts/jobs/common.sh`: `garden-ci-watcher@kriscendobot-oros-ckm-data-readiness` FATAL'd (exit 1) on "cannot acquire clone lock /home/kris/garden/.garden-state/ci-watcher/verify.lock after 3 waits of 60s and 0 reclaim attempt(s)". Confirmed the holder was a live, legitimate peer (`ci-watcher.sh kriscendobot-minion.town`, pid still running its reclone at inspection time, `verify.reclone.<pid>.1` present) — not a crashed/stale lock, so the existing steal logic correctly declined to reclaim it. All `garden-ci-watcher@<repo>` instances share ONE `GARDEN_CI_VERIFY_CLONE` path and its lock, so whenever one repo's tick triggers a reclone (can run past the 60s×3 wait ladder), every sibling repo's concurrent tick loses the race and dies loud.

`clone_lock`'s FATAL message here isn't recognized by either outage classifier in common.sh: `_fetch_stderr_is_offline` (network signatures) or `journal_bounded_fetch_is_ambiguous_outage` (matches only `journal fetch in .* failed after N attempt|clone of .* failed`). So `ensure_clone_or_latch_outage` (used by ci-watcher.sh:198 and every sibling watcher) falls through to its loud re-raise path instead of latching the shared outage cooldown and exiting quietly with `GARDEN_OFFLINE_RC`, even though this is the same "ambiguous, self-resolving, not a definite fault" shape that commit `86c94ab973d` already fixed for slow VERIFY-clone fetches — just reached via `clone_lock`'s own `die` inside `ensure_clone` rather than the fetch step.

Fix: extend `journal_bounded_fetch_is_ambiguous_outage()` (or add a sibling check consulted by `ensure_clone_or_latch_outage`) to also match `cannot acquire clone lock .* busy` (or scope narrowly to `.* after [0-9]+ waits of [0-9]+s and [0-9]+ reclaim attempt`), guarded the same way by `! journal_diagnostic_is_definite_failure` (verified no overlap with the auth/upstream-gone/corrupt/local-failure patterns, which key on git's own `unable to create .*\.lock`/`cannot lock ref` phrasing, distinct from this custom message). This lets concurrent, live-holder clone-lock contention across the shared per-repo ci-watcher/etc. fleet latch the shared journal-outage cooldown and skip quietly instead of FATAL-restart-looping.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-26T23:59:36Z
