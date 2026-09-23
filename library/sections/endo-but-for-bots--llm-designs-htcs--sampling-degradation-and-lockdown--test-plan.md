---
title: Test plan
source: designs/hardened-text-codecs-shim.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 6d2f3a03a0648edda82a0444898f1d1ff0c25806
source_date: 2026-05-04
source_authors: [Kris Kowal]
topics: [hardened-javascript, compartments]
status: current
parent: endo-but-for-bots--llm-designs-htcs--sampling-degradation-and-lockdown
---

Tests live under `packages/ses/test/`. Six test cases:

1. **Presence on universals.** In a fresh post-lockdown compartment,
   `compartment.evaluate('typeof TextEncoder')` returns `'function'`
   when the host provides it, `'undefined'` otherwise.
2. **Identity across compartments.** `TextEncoder` from the start
   compartment and from any post-lockdown compartment are the same
   object (`startCompartment.globalThis.TextEncoder === compartment.globalThis.TextEncoder`)
   — this is the **universal-not-shared** test (universals are
   identity-equal across all compartments; shareds are tamed variants
   that may differ from the initial).
3. **Frozen.** `Object.isFrozen` returns `true` for `TextEncoder`,
   `TextEncoder.prototype`, `TextDecoder`, `TextDecoder.prototype`.
4. **Round-trip semantics preserved.**
   `new TextDecoder().decode(new TextEncoder().encode('hello')) ===
   'hello'`. **Guards against accidental over-pruning** — if the
   permits table accidentally cuts `encode` or `decode`, this test
   fails.
5. **Host without the codecs.** A test that deletes
   `globalThis.TextEncoder` and `globalThis.TextDecoder` before
   `lockdown()` exercises the degradation path. No throw; post-
   lockdown compartments lack the bindings.
6. **XS smoke test.** The existing XS test runner exercises (1) and
   (5) on a host that never provided the codecs.

The pattern (presence test + identity test + frozen test + round-trip
test + degradation test) is the **standard SES-intrinsics test
template**; any future taming PR can copy these six cases verbatim and
just rename the intrinsic.
