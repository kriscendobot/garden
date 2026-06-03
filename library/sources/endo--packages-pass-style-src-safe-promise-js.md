---
source: packages/pass-style/src/safe-promise.js
source_repo: endojs/endo
source_branch: master
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
source_date: 2026-02-24
source_authors: [Kris Kowal]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Twenty-eighth comment-fragment ingest. 158-line file by Kris
  Kowal in commit `e56bf00f` — same coordinated-update cluster
  as cycles 108/110/115/118/123/125/132/134/136. Defines what a
  *safe promise* is for Hardened JS — a promise whose `.then`
  method can be called synchronously without giving the promise
  an opportunity for a reentrancy attack.

  Two exports: isSafePromise (false rejector → boolean) and
  assertSafePromise (Fail rejector → throws). Both wrap the
  private confirmSafePromise. The §rejector-as-callback pattern.

  §Four-conjunction safety check:
    (1) isFrozen(pr) — must be frozen (no post-check tamper)
    (2) isPromise(pr) — uses @endo/promise-kit's detector
        (realm-independent)
    (3) getPrototypeOf(pr) === Promise.prototype — strict
        prototype check rules out subclasses
    (4) confirmPromiseOwnKeys(pr, reject) — own-keys allowlist
        check

  Single most structurally interesting move: the §Node-async_
  hooks-explicit-allowlist with cited verbatim source code from
  Node:
    ```js
    function destroyTracking(promise, parent) {
      trackPromise(promise, parent);
      const asyncId = promise[async_id_symbol];
      const destroyed = { destroyed: false };
      promise[destroyedSymbol] = destroyed;
      registerDestroyHook(promise, asyncId, destroyed);
    }
    ```
  The §three-allowed-shapes: undefined-or-number (the asyncId);
  frozen empty Object-prototype object; frozen `{destroyed:
  false}` Object-prototype object. The §exact-shape-match
  discipline: each Node-async_hooks addition has a *specific*
  expected shape; deviations fail. The §cite-Node-source-
  verbatim-in-comment discipline: when the safety check
  tolerates host-specific quirks, the host's exact source code
  becomes *part of the safety surface*.

  §@@toStringTag tolerance — the only allowed symbol own
  property. Three sub-invariants: must be a data property (not
  accessor); value must be string; must be non-enumerable.
  §TODO note: *should we also enforce anything on the contents
  of the string, such as that it must start with 'Promise'?* —
  current implementation accepts any string.

  §reentrancy-via-test-itself meta-hazard: the JSDoc cites
  agoric-sdk issue #9 — *raises the issue of testing that a
  specimen is a safe promise such that the test also does not
  give the specimen a reentrancy opportunity. That is well
  beyond the ambition here*. The §honest-limitation discipline:
  the safety check itself touches the specimen (via
  getPrototypeOf, ownKeys, etc.); a perfectly-paranoid
  implementation would test without calling into the specimen
  at all.

  §hideAndHardenFunction (vs plain harden) wraps both exports
  — same rationale as cycle 134's assertIface: when an
  assertion throws, its name appears in stack traces;
  hideAndHardenFunction *reduces information leak* from the
  assertion's call site.

  §pass-style relationship: safe-promises are *not themselves* a
  pass-style (cycle 71's passStyleOf doesn't return a 'promise'
  style). They're a *pre-condition* for safe pass-by-reference
  of promises through @endo/eventual-send (cycle 66's
  handled-promise + cycle 132's local.js).

  Cycle 138 was nominally chat-lane (cycle 137 was designs).
  Chat-lane exhausted at 20/20. Papers-lane has been blocked for
  32+ consecutive cycles. Cycle 138 pivoted to comments-lane to
  continue the @endo/pass-style exploration after cycles 71 +
  87 + 134 + 136.
---

> Abstract: `packages/pass-style/src/safe-promise.js` (158
> lines, Kris Kowal, commit `e56bf00f`) defines what a *safe
> promise* is for Hardened JS — a promise whose `.then` method
> can be called synchronously without giving the promise an
> opportunity for a reentrancy attack.
>
> §Four-conjunction safety check: isFrozen + isPromise +
> Promise.prototype-direct-inheritance + own-keys-clean.
> Two exports (isSafePromise / assertSafePromise) wrap the
> private confirmSafePromise via the §rejector-as-callback
> pattern.
>
> **The single most structurally interesting move**: the
> §Node-async_hooks-explicit-allowlist with the §cite-Node-
> source-verbatim-in-comment discipline. The safety check
> tolerates Node's three specific async_hooks shapes
> (undefined/number; frozen empty Object; frozen `{destroyed:
> false}`); deviations fail. The host's exact source code
> becomes *part of the safety surface*.
>
> §@@toStringTag tolerance: the only symbol own property
> allowed (non-enumerable data property with string value).
>
> §Reentrancy-via-test-itself meta-hazard (cited via agoric-sdk
> #9): the safety check itself touches the specimen; a
> perfectly-paranoid implementation would test without calling
> in. §Honest-limitation discipline — the JSDoc names the gap.
>
> §hideAndHardenFunction (vs plain harden) wraps both exports
> — assertion functions hide their identity from stack traces.
>
> Safe-promises are *not themselves* a pass-style (cycle 71
> doesn't classify promises). They're a *pre-condition* for
> safe pass-by-reference of promises through @endo/eventual-
> send.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [safe-promise-definition-with-toStringTag-tolerance-and-node-async-hooks-explicit-allowlist](../sections/endo--packages-pass-style-src-safe-promise-js--safe-promise-definition-with-toStringTag-tolerance-and-node-async-hooks-explicit-allowlist.md) | pass-style, eventual-send | current |

Tight 158-line file. The four-conjunction check + the
own-keys-allowlist + the two exports form one mechanism: *what
counts as a safe promise*. One cohesion-honest section.

## Provenance

- Fetched 2026-06-03 from `endojs/endo@e56bf00f` (`master`) via
  the local bare-clone.
- Last touched 2026-02-24 by Kris Kowal in commit `e56bf00f`.
  Same coordinated-update commit as cycles 108, 110, 115, 118,
  123, 125, 132, 134, 136.
- Verified file existence and structure via the local bare-clone:
  158 lines + 2 exports (isSafePromise, assertSafePromise) + 2
  private helpers (confirmSafePromise, confirmPromiseOwnKeys).
- **Twenty-eighth comment-fragment ingest.** Pairs with the
  pass-style remotable surface (cycle 71 + cycle 87 + cycle 134
  + cycle 136) and the eventual-send substrate (cycle 66 + cycle
  132 + cycle 130).
- Cycle 138 was nominally **chat-lane** (cycle 137 was
  designs). Chat-lane is exhausted (20/20). Papers-lane has been
  blocked for **32+ consecutive cycles** due to lack of
  PDF-fetching infrastructure. Cycle 138 pivoted to comments-lane.
- One cohesion-honest section.
