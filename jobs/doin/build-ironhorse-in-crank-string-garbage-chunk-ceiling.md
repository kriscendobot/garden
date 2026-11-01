---
role: builder
tier: mentor
arc: ironhorse-test262-ratchet
posted_at: 2026-11-01T16:13:09Z
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-11-01T17:08:12Z cleared=none -->

---
role: builder
arc: ironhorse-test262-ratchet
dispatch: automatic
tier: mentor
fallback-tier: minion
---
# Build: the design in endojs/endo-but-for-bots#1622

Repo: https://github.com/endojs/endo-but-for-bots. Design PR: https://github.com/endojs/endo-but-for-bots/pull/1622.

Build exactly the design produced by the completed designer job `design-ironhorse-in-crank-string-garbage-chunk-ceiling` (its report is in `jobs/tada/`). Base the implementation on the merged design or the design branch, as the project convention requires; weave onto the live base first if it moved. Open a DRAFT PR: completion stages its gauntlet. Report a gap rather than weaken a property the design requires.

Dispatched by design-build-handoff.sh from the design report's follow-ups:

> - **The design depends on PR #1618 (matcher run compression), which is still open.** It is step 1 of the build order.
> - **Build:** `build-ironhorse-in-crank-string-garbage` (the completion handoff posts it). Order:
>   1. The RegExp changes (catchable limit, quantifier clamp). These are small and don't depend on the collection decision.
>   2. Safepoint collection, once the maintainer agrees to the change to the quiescent rule.
> - Ropes for the string-append slowdown (review finding NVAL-3) would be a separate design. Not yet filed.
> - I'm leaving the PR as a draft; the design-review gauntlet is recorded automatically when this job completes.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-01T17:21:06Z
