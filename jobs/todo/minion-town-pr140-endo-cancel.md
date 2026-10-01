---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# minion.town: replace AbortController with @endo/cancel in Claude delegation inference (follow-up to merged #140)

Repo: kriscendobot/minion.town, base `main`.

kriskowal's approving review on the already-merged PR #140
(https://github.com/kriscendobot/minion.town/pull/140#pullrequestreview-5375087214)
left one inline ask, on `src/endo/claude/agents.ts:604`
(https://github.com/kriscendobot/minion.town/pull/140#discussion_r4151939502):

> Use endo/cancel. In general, we do not use AbortSignal and AbortController
> except in endo/cancel adapters to interact with a platform specific capability.

PR #140 merged (af7af61803) before this ask could be addressed, so this job opens a
follow-up PR. Today `agents.ts` (around line 604) builds a `new AbortController()`
and wraps its `signal` `abort` event into the `cancelled: Promise<never>` that it
passes to `exo.infer(prompt, { cancelled })`, and stores a closure in
`childRecord.inferences` that calls `cancellation.abort(...)`.

Task:
- Replace that AbortController/AbortSignal construction with the `@endo/cancel`
  idiom (a cancel kit / cancellation promise from `@endo/cancel`). Add the
  dependency if it isn't present, pinned consistently with the other `@endo/*` deps.
  Check how endo-but-for-bots `llm` uses `@endo/cancel` for the idiomatic shape.
- Sweep the rest of `src/` (especially `src/endo/claude/`) for other
  AbortController/AbortSignal uses outside a platform-adapter boundary and convert
  them the same way; where a platform API genuinely needs an AbortSignal, confine
  that to an `@endo/cancel` adapter.
- Keep behavior identical (teardown still fires every in-flight inference's
  cancellation); run the existing tests.
- Open a draft PR via ensure-pr.sh; link the review thread above in the body; reply
  on that inline thread with the follow-up PR link once opened.
