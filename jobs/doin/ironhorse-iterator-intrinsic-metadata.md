---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:39:28Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# fix Ironhorse %IteratorPrototype% / %AsyncIteratorPrototype% intrinsic metadata

Follow-up carved while shepherding endojs/endo-but-for-bots PR #1046
(test(hardened262): add Ironhorse coverage agents).

## Context

The hardened262 differential baseline now records a known Ironhorse-vs-XS
divergence on two test262-style probes the llm base added in #1070:

- `packages/hardened262/test/intrinsics/IteratorPrototype/intrinsic-metadata.js`
- `packages/hardened262/test/intrinsics/AsyncIteratorPrototype/intrinsic-metadata.js`

They fail under **every** Ironhorse and Ironhorse+SES scenario (48 baseline
`failed` entries recorded in commit c2c00906c on branch
`feat/ironhorse-coverage-matrix` to keep CI green). The earlier
`fix(ironhorse): harden VM dispatch and intrinsic metadata` (fc5e18338)
completed only the **generator-family** toStringTag metadata; the iterator
prototypes were left diverging.

## The ask

Make Ironhorse agree with XS so these two tests move from `failed` to
`passed`, then regenerate the hardened262 baseline (`yarn workspace
@endo/hardened262 test262:update baseline`) and drop the recorded failures.

What the probes assert (see the test bodies):
- a single shared `%IteratorPrototype%` reached through array/string/Map/Set
  iterators;
- `%IteratorPrototype%[Symbol.iterator]` is a function named `[Symbol.iterator]`,
  length 0, returns `this`, and `%IteratorPrototype%`'s prototype is
  `Object.prototype`;
- the analogous `%AsyncIteratorPrototype%[Symbol.asyncIterator]` metadata and
  its prototype chain up to `Object.prototype`.

Engine work lives under `rust/engine/ironhorse-vm/` (interp.rs / lib.rs, where
the generator-family metadata fix landed).

## Done when

- both intrinsic-metadata probes pass under Ironhorse and Ironhorse+SES;
- hardened262 baseline regenerated and the 48 recorded failures removed;
- `yarn workspace @endo/hardened262 test:xs` green locally.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-17T00:10:28Z
