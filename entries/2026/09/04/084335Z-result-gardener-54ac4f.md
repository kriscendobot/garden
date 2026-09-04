---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-04T08:43:37Z
---
Panel seat: decomplector (design panel), endojs/endo-but-for-bots PR #717 (designs/promise-debug-view.md), dispatch pr717-gauntlet-panel-4, diff base bbb1bd9fff.

### decomplector

**Verdict:** request-changes

**Findings:**

- **must-fix — `lowestRetainedId` derives a historical fact from current state, and cannot.** § Eviction policy says "the smallest `id` still present is a watermark: every `id` below it has aged out", then gives a different rule a sentence later ("each eviction advances a single `lowestRetainedId`"). Both are unsound for one reason: a scalar over a monotone id space conflates three histories — *evicted from `retained`*, *delivered and moved to `ring`*, and *never entered `retained` at all*. The third is the common case, so a plain never-settled finalization below the watermark gets `priorEntryEvicted: true`. That inverts Design Decision 3: "a lost correlation is visible rather than silently absent" becomes "an absent correlation is reported as lost". The section rejects a bounded `evictedIds` set for going silent under pressure; the scalar never goes silent because it fabricates. Make the flag honestly uncertain (`correlationUnknown`) or keep membership. [proposed-rule: a design may not claim `O(1)` certainty from a scalar over a monotone key space unless every key in that space provably entered the structure the scalar summarizes.]

- **should-fix — the long-pending threshold and cap complect query policy with buffer mechanism.** By the design's own account (§ What the debug view observes; Decision 4) `long-pending` is computed fresh from `liveSet` at inspection and never stored. Nothing recorded depends on `ENDO_PROMISE_DEBUG_VIEW_THRESHOLD` or `..._LONG_PENDING_LIMIT`, yet both bind at process start, so a debugger who asks "pending over 5s?" must restart the process to ask "over 60s?". Make them arguments — `debugView({ longPendingThreshold, longPendingLimit })` — with the env-options as defaults. `N` and `R` do belong to the env: they govern what is stored. [proposed-rule: a parameter that only shapes a read-time derived query belongs on the query, not in process-start configuration.]

- **should-fix — `entries` re-merges two structures whose bounds and counters the snapshot keeps split.** § Inspection surface reports `capacity` and `retainedCapacity` apart and splits `evicted` into `{ retained, ring }` because the two losses mean different things, then collapses the entries those bounds govern into one array, discriminated only by a tri-state `delivered` (`false` retained, `true` delivered-in-`ring`, absent `forever-pending`). A reader cannot attribute an entry to its governing bound and counter without re-deriving the eviction rule. Return two arrays, or carry a `structure` field. [proposed-rule: when a design splits a bound or counter per structure, entries stay attributable to their structure on the same surface.]

- **comment-only — `createdAt` spans two incommensurable time domains in one field** ("turn counter or wall-clock stamp", entry table), and the threshold comparison inherits it. However Open Question 5 resolves, the surface should name the unit. [proposed-rule: a design leaving a timestamp's domain open must still require the shipped surface to name the domain.]

**Notes (out of scope but worth flagging):**

- README integration is partial: summary-table row, intro entry and count sentence, but no milestone assignment, no milestone-table row, no dependency-graph node (it does depend on `pass-style-promise`), no size estimate. [rule: designs/AGENTS.md § Progress Tracking, Cross-document]
- Whether an implementation avoids the strong first-listener edge is code-panel work for the breaker and locksmith. [rule: roles/jurors/decomplector/AGENT.md § In-scope vs out-of-scope]
- Kept right: recorded events versus derived query held apart with separate bounds, and the value-only reason projection buying the weak-carrier invariant, harden containment, and the authority property from one modeling choice.

Self-improvement: the seat's highest-yield category on this design was (d) value-oriented vs place-oriented, applied not to mutation but to *derivation*: the `lowestRetainedId` scalar tries to answer a question about history ("was this id evicted?") from a summary of current state, which no scalar over a monotone key space can do. A design that praises its own choice for never going silent is worth checking for the dual failure — a signal that is never silent because it is sometimes fabricated. Worth adding to the decomplector's category walk as a named probe under (d).
