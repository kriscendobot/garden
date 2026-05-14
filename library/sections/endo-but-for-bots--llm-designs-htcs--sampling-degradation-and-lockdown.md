---
title: Sampling, XS degradation, and lockdown sequencing — no new phase
source: designs/hardened-text-codecs-shim.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 6d2f3a03a0648edda82a0444898f1d1ff0c25806
source_date: 2026-05-04
source_authors: [Kris Kowal]
topics: [hardened-javascript, compartments]
status: current
---

## Sampling — the existing flow handles it

`packages/ses/src/intrinsics.js`'s `sampleGlobals(globalThis,
universalPropertyNames)` already tolerates missing properties: **a
permit whose name is absent on the global is simply skipped.** The
shim relies on this behavior.

On **XS**, where `TextEncoder` and `TextDecoder` are not defined,
lockdown proceeds without them and compartments observe their
absence exactly as they do today. The shim does **not** polyfill —
the design explicitly defers polyfill to a separate design "when
there is demand."

This is the same XS-degradation discipline named in
[[endo-but-for-bots--llm-designs-hurl--lockdown-sequencing-and-degradation]];
the framework SES already has for absent-on-host intrinsics is the
mechanism that makes per-feature degradation automatic.

## Lockdown sequencing — no new phase

The new permits hook into the existing `intrinsics.js` flow with **no
new lockdown phase**:

1. `getGlobalIntrinsics` collects `TextEncoder` and `TextDecoder`
   from the host global (or skips them on XS).
2. The whitelist pass walks the permits graph and prunes any
   non-listed properties.
3. `harden` is applied to the closure of permitted intrinsics.

**No code outside `packages/ses/src/` changes.** The shim is fully
internal to SES.

## Test plan

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

## Compatibility consideration

> *Code that monkey-patches the codecs.* Any code that today does
> `TextEncoder.prototype.foo = ...` after `@endo/init` will throw,
> because the permitted intrinsics are frozen. Such code must
> perform its mutation before lockdown (the same rule that already
> applies to every other intrinsic).

The design recommends noting this in the SES changeset for the
release that ships the shim.
