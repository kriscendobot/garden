## Completion report: `ebfb-sturdyref-layer1-shim-design-20260930`

The layer-1 design PR is open as draft **endojs/endo-but-for-bots#1389** (head `design/sturdyref-shim-contract`, base frozen `llm-7ff30af`, which is the current `llm` tip `7ff30afbce`). It adds `designs/sturdyref-shim-contract.md` and one row in `designs/README.md`. Nothing was built.

**What the contract says**
- **Surface:**
  - `new SturdyRef(handler)` returns an opaque, frozen ref. The handler must have an `enliven` function, and it is kept in a private `WeakMap` inside the one shared constructor.
  - `SturdyRef.enliven(ref)` calls the hook in a later turn and returns a promise.
  - `SturdyRef.isSturdyRef(value)` is a brand check that grants no authority. Layer 3 needs it to recognize refs.
  - What a ref captures is decided entirely by its handler.
- **#774:** keeps first-wins install (`selectSturdyRef`/`provideSturdyRef`, non-writable global, rejects a malformed global), lazy hardening after lockdown, and the opacity, no-identification and cross-copy tests. It replaces `fromLocation`/`toLocation` and the locator `WeakMap`. It also drops the `Far`/`@endo/pass-style` dependency, because that made layer 1 depend on layer 3. A table in the doc says which #774 tests are kept, dropped, rescoped or new.
- **The withdrawn HandledPromise-enliven vision:**
  - The `enliven` meta-trap is absorbed as the handler hook.
  - Rejected: modeling a sturdyref as a HandledPromise, and `HandledPromise.enliven`.
  - Deferred: `E.enliven` and the `Promise.delegate` spackle.
- **"Withheld from child compartments" vs. layer 2:** that property only mattered because #774's `toLocation` exposed locators through the global. The new global exposes nothing, so the shim leaves propagation to SES. #774's "withheld" test becomes a "default without a SES permit" test, and layer 2 owns the change that makes the global propagate.
- **Also in the doc:** an ownership map, a one-paragraph sketch of how layers 3–5 use the contract, and 7 open questions (hook timing, hook argument, when the hook is looked up, whether to harden the handler, prototype, `E.enliven`, whether one CapTP can carry another's refs). None of them reopen the directive's shape.

**Other actions**
- The PR body follows the repo's template, links endojs/endo-but-for-bots#695 and kriscendobot/garden#47, and carries the 1–9 stack index.
- I commented on kriscendobot/garden#47 with the new PR number: https://github.com/kriscendobot/garden/issues/47#issuecomment-5904286162.
- The inbox was empty.

**Follow-ups**
- The layer-1 build job (reworking #774 in place) should implement this contract.
- The PR is left draft for the automatic design-panel review.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer1-shim-design-20260930.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1324690 cached reads)
- Output: 16464 tokens
- Cost: $1.21269
- Wall-clock: 284s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
