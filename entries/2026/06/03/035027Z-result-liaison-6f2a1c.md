---
ts: 2026-06-03T03:50:27Z
host: endolin
role: liaison
kind: result
dispatch_id: liaison--6f2a1c
cycle: 138
---

# Cycle 138 — safe-promise.js (Kris Kowal, endo) — comments-lane

Ingested `packages/pass-style/src/safe-promise.js` (158 lines)
from `endojs/endo@e56bf00f` (master). **Twenty-eighth comment-
fragment ingest.** One cohesion-honest section:

- **safe-promise-definition-with-toStringTag-tolerance-and-node-
  async-hooks-explicit-allowlist** — defines what a *safe
  promise* is for Hardened JS: *a promise whose `.then` method
  can be called synchronously without giving the promise an
  opportunity for a reentrancy attack*.

## The single most structurally interesting move

The §Node-async_hooks-explicit-allowlist with the §cite-Node-
source-verbatim-in-comment discipline. The safety check
tolerates Node's three specific async_hooks shapes:

- `undefined` or `number` (the asyncId)
- frozen empty `Object`-prototype object
- frozen `{ destroyed: false }` `Object`-prototype object

The inline comment cites Node's exact source code; *the host's
exact source code becomes part of the safety surface*. If
Node's async_hooks changes the shape, this file must update.

## §Four-conjunction safety check

1. **isFrozen** — must be frozen (no post-check tamper)
2. **isPromise** — uses `@endo/promise-kit`'s detector (realm-
   independent, not `instanceof Promise`)
3. **getPrototypeOf(pr) === Promise.prototype** — strict-
   prototype-check rules out subclasses
4. **confirmPromiseOwnKeys** — own-keys allowlist (only
   @@toStringTag + Node async_hooks symbols allowed)

## §Reentrancy-via-test-itself meta-hazard

The JSDoc cites agoric-sdk issue #9: *raises the issue of
testing that a specimen is a safe promise such that the test
also does not give the specimen a reentrancy opportunity. That
is well beyond the ambition here*. The §honest-limitation
discipline: the safety check itself touches the specimen (via
getPrototypeOf, ownKeys, etc.); a perfectly-paranoid
implementation would test without calling in. *This file
doesn't achieve that; the JSDoc names the gap*.

## §hideAndHardenFunction wraps both exports

Same rationale as cycle 134's `assertIface`: when an assertion
throws, its name appears in stack traces; hideAndHardenFunction
*reduces information leak* from the assertion's call site.

## §Pass-style relationship

Safe-promises are *not themselves* a pass-style (cycle 71's
passStyleOf doesn't return a `'promise'` style). They're a
*pre-condition* for safe pass-by-reference of promises through
@endo/eventual-send (cycle 66's handled-promise + cycle 132's
local.js both *trust* the safe-promise invariant).

## Rotation note

Cycle 138 was nominally **chat-lane** (cycle 137 was designs).
Chat-lane is exhausted at 20/20. Papers-lane has been blocked
for **32+ consecutive cycles**. Cycle 138 pivoted to
comments-lane.

## Counts

- 641 → **642** sections (+1).
- 182 → **183** source documents (+1).
- Topic pages updated: `pass-style.md` (+1 row),
  `eventual-send.md` (+1 row — safe-promise is what
  eventual-send trusts).
- Keywords index extended with ~31 safe-promise-specific
  keywords.
- Sources/README.md updated (+1 row).
- Sections/README.md updated (+1 group; total adjusted).

## Next cycle

Cycle 139 wakes in 1500s. Rotation lands on **papers-lane**
nominally (still blocked at 32+). Expect another pivot.
