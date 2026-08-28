---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Consolidate the sprawl of test262-coverage-ratchet PRs on
endojs/endo-but-for-bots (all base `llm`, all `test/hardened262-*`
intrinsic-metadata coverage slices, all opened today by successive turns
of the hourly test262-coverage-ratchet press) into a SINGLE open PR:

- https://github.com/endojs/endo-but-for-bots/pull/1064 (ArrayBuffer/view methods)
- https://github.com/endojs/endo-but-for-bots/pull/1074 (TypedArray intrinsic metadata)
- https://github.com/endojs/endo-but-for-bots/pull/1075 (AsyncFunction)
- https://github.com/endojs/endo-but-for-bots/pull/1076 (ThrowTypeError)
- https://github.com/endojs/endo-but-for-bots/pull/1077 (RegExp/Promise prototypes)
- https://github.com/endojs/endo-but-for-bots/pull/1078 (Map/Set/WeakMap/WeakSet prototypes, draft)
- https://github.com/endojs/endo-but-for-bots/pull/1079 (Reflect/Proxy/Math/JSON/Atomics, draft)

Pick one as the survivor (the earliest-opened, #1064, is a reasonable
default unless another is clearly more complete/foundational — use
judgment) and consolidate the other six's commits onto it as additional
commits on its branch, resolving any overlap between them (several touch
adjacent/overlapping hardened262 intrinsic-metadata territory, developed
independently in parallel — check for duplicate or conflicting test
additions, not just mechanical git conflicts). Run the full affected
test262/hardened262 suite afterward for real-execution evidence that the
consolidated set is coherent and non-regressive, not just that each slice
individually passed in isolation.

Close the six superseded PRs, each with a comment pointing at the
survivor. Update issue #51
(https://github.com/kriscendobot/garden/issues/51) with the consolidated
state: one open draft PR, its current coverage delta, and note that this
is now the sole target for future ratchet turns (a companion schedule fix
enforcing that is landing separately — don't also edit
schedules/test262-coverage-ratchet.md yourself).

Note: the ratchet's own deadline stop condition (2026-08-28T15:00Z) may
already have fired by the time this job runs — if the schedule has
retired itself, that's fine, this consolidation still stands on its own
merits regardless of whether the ratchet is still actively running.

<!-- garden-provider-quota-backoff: type=session reset-at=2026-08-28T15:00:00Z -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-28T14:27:32Z
