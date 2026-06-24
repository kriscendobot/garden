---
title: Common confusions
source: packages/exo/src/exo-tools.js
source_repo: endojs/endo
source_branch: master
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
source_date: 2025-10-09
source_authors: [Kris Kowal]
source_lines: "1-346 (sentinels + defendSyncArgs + buildMatchConfig + defendSyncMethod + desync + defendAsyncMethod + defendMethod + bindMethod)"
topics: [hardened-javascript, exo]
status: current
notes: |
  Nineteenth comment-fragment ingest. Kris Kowal-authored
  *method-defense machinery* file — *the* implementation that
  cycle 108's exo-makers.js imports `defendPrototype` and
  `defendPrototypeKit` from. Section 1 of 2 covers the per-method
  defense layer (sync + async + raw-guard handling); section 2
  covers the prototype-building layer (`defendPrototype` +
  `defendPrototypeKit` with interface-guard validation).
  
  Three structurally interesting moves in section 1: (1) the
  *REDACTED_RAW_ARG-sentinel-for-raw-guard-pass-through* — raw-
  guarded positions are *replaced with a string sentinel for the
  matchConfig check*, then the original (un-redacted) arg passes
  through to the actual method; `mustMatch` validates the
  matchable form; the method receives the unmodified value; (2)
  the *desync transformer* that pulls awaitable args out of the
  method guard, returns awaitIndexes + rawMethodGuardPayload; the
  async wrapper does `Promise.all(awaitList)` before
  defendSyncArgs; (3) the *TOCTTOU-aware context lookup* — *Get
  the context after all waiting in case we ever do revocation by
  removing the context entry. Avoid TOCTTOU!* — the context is
  resolved *after* awaitable args complete, ensuring revocation
  between arg-await and method-execution is caught.
  
  Plus: the *concise method syntax* (`{ syncMethod(...syncArgs)
  { ... } }.syncMethod`) is used to make `this` work correctly
  via the destructure-pattern; the §`.catch` chained after the
  `mustMatch` is *deliberately positioned* — *Done is a chained
  `.catch` rather than an onRejected clause of the `E.when`
  above in case the `mustMatch` throws*. Cycle 118 papers-lane
  pivot to comments-lane (12+ consecutive papers-lane blocks).
parent: endo--packages-exo-src-exo-tools-js--method-defense-with-raw-guards-and-async-await-handling
---

- **"`REDACTED_RAW_ARG` looks like a real value — could it collide with a real arg?"** It's *deliberately distinctive*: `<redacted raw arg>` is an unlikely real value, and the matching pattern at raw positions explicitly *expects* this string. The §discipline: *raw guards never actually validate*; the sentinel is just for paramsPattern bookkeeping.
- **"`defendSyncArgs` could just `mustMatch` syncArgs directly."** It could *if no raw guards*. When raw guards exist, the matchable form *must* have the sentinel at those positions (because the matching paramsPattern has sentinel there). The §copy-when-redaction-needed avoids modifying the caller's args.
- **"`buildMatchConfig` being slow is a problem."** It's called *once* per method definition (when the prototype is built). The hot path is `defendSyncArgs` which uses the precomputed config. The §amortization-discipline is *compile-once-execute-many-times*.
- **"The concise-method-syntax destructure-pattern is over-clever."** It's *the correct idiom for `this`-preserving wrappers* with a named function. An equivalent named-function-expression approach (`function syncMethod(...args) {...}`) works but the destructure-pattern is the @endo idiom.
- **"`toThrowable(thrownThing)` is just `new Error(thrownThing)`."** It's *pass-style coercion*. Some thrown values are already pass-style Errors (or wrapped exotics); `toThrowable` ensures the thrown thing is a passable Error before re-throwing. Non-Error throws (strings, numbers, plain objects) get wrapped.
- **"TOCTTOU in single-threaded JavaScript? That's not a thing."** It is — *asynchronously*. JavaScript is single-threaded *per turn*, but multiple turns interleave. A revocation that runs in a turn *between* the await-completion-turn and the method-execution-turn would create the TOCTTOU window. The §discipline closes the window by deferring the context lookup.
- **"The `.catch` after `E.when(resultP, fulfillment => mustMatch(...))` is just standard promise chaining."** It's *deliberately positioned to catch the mustMatch throw*. If `mustMatch` is inside the onFulfilled clause of the *same* `E.when`, its thrown value *doesn't* propagate to the onRejected of *that* `E.when` — it propagates to the *next* link. The §discipline puts the catch at the next link explicitly.
- **"Why a `desync` transformer? Can't the async method just check await-arg-guards inline?"** It could — but the §discipline *separates the await-extraction (one-time) from the per-call validation (every-call)*. desync runs once at method-definition; the per-call wrapper consumes the precomputed awaitIndexes.
- **"`bindMethod` setting `.length = behaviorMethod.length` is cosmetic."** It's *for introspection-correctness*. `Function.prototype.length` is the *declared parameter count*. Code that uses `method.length` for arity-aware dispatch (rare but real) sees the original method's arity, not the wrapper's. The §discipline preserves the user-visible behavior.
- **"`Rest args may not be awaited` (line 196) is an arbitrary restriction."** It's a *coherence restriction*. Rest args are *a variable-length array*; awaiting the rest would mean *await each element of the unbounded array*. The §discipline: *if you need awaitable rest, use an array argument with `M.awaited(M.arrayOf(...))` semantics instead* (or similar — the design forbids the syntactic shortcut).
