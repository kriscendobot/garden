---
title: §Borrowable patterns
source-slug: endo--packages-captp-src-types-js
source-url: https://github.com/endojs/endo/blob/master/packages/captp/src/types.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/captp/src/types.js
total-lines: 49
ingest-cycle: 249
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-captp-src-types-js--typedef-only-file-and-three-method-TrapImpl-and-TrapCompletion-as-tuple-and-Out-of-band-sync-over-async
---

**Tier-1 (highest borrowing value):**

- §`export {};`-typedef-only-file-pattern as named module-without-runtime-exports.
- §Three-method-TrapImpl distinct from six-method-handler-protocol (sync vs async axis).
- §`applyMethod`-as-atomic-lookup-of-method-and-apply — security-by-construction against method-detach.
- §TrapCompletion-as-discriminator-payload-tuple — encode-rejections-as-tuples-not-throws-when-crossing-out-of-band-boundaries.
- §The-non-thenable-constraint-as-explicit-sync-guarantee — typedef encodes the invariant.
- §`keyof InterfaceName`-as-defense-by-construction-against-string-union-drift.
- §Out-of-band-communications-as-named-sync-over-async-mechanism.
- §AsyncIterator-as-async-side-of-sync-over-async-bridge.

**Tier-2 (TypeScript discipline patterns):**

- §`Required<Iterator<void, void, any>>` — completeness-of-implementation + all-three-iterator-type-params-named.
- §Iterator-with-`void, void, any` as pure-control-flow-coordination encoding.
- §`AsyncIterator<...> | undefined`-as-optional-return-encoding.
- §Branded-string-typedef-for-domain-specific-meaning (CapTPSlot).

**Tier-3 (file-shape patterns):**

- §Forty-nine-lines-as-a-complete-protocol-contract-via-typedefs.
- §Five-named-typedefs in 49 lines (CapTPSlot + TrapImpl + TrapCompletion + TrapRequest + TrapGuest + TrapHost).
