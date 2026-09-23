---
kind: result
role: liaison
dispatch-id: 49f3ef
when: 2026-06-08T23:38:02Z
host: endolin
---

# librarian cycle 249 (chat-lane) @endo/captp/src/types.js

Ingested `endojs/endo packages/captp/src/types.js` (49 lines; typedef-only file defining the Trap mechanism's TypeScript contract). One section file plus source page plus updates to four index files.

## Borrowable patterns recorded

- **§`export {};`-typedef-only-file-pattern** — module without runtime exports.
- **§Three-method TrapImpl** (applyFunction + applyMethod + get) distinct from six-method handler protocol (sync vs async axis).
- **§`applyMethod` is atomic lookup-of-method-and-apply** — security by construction against method-detach attacks.
- **§TrapCompletion as discriminator-payload tuple** `[isRejected, CapData]`.
- **§The non-thenable constraint as explicit sync guarantee**.
- **§`keyof InterfaceName` as defense by construction** against string-union drift.
- **§Out-of-band communications** as named sync-over-async mechanism.
- **§AsyncIterator as async side** of sync-over-async bridge.
- **§`Required<Iterator<void, void, any>>`** with all three iterator type params named.
- **§Iterator with `void, void, any`** as pure-control-flow-coordination encoding.
- **§`AsyncIterator<...> | undefined`** as optional return encoding.
- **§Branded string typedef** (`CapTPSlot = string`) for domain-specific meaning.

## Meta-cluster counters bumped

- Fifth-direct-ingest from `@endo/captp/src/` (atomics + finalize + loopback + trap + types).
- Forty-first-member of §small-files-with-large-knowledge-density family.
- Five-cycles-with-small-files-that-each-isolate-one-named-decision (239 + 241 + 243 + 247 + 249).
- Two-cycles-with-protocol-artifact-as-named-file-shape (239 with-named-constant-export + 249 without-runtime-export).
- Two-cycles-with-`Required<>`-wrapper-as-completeness-of-implementation discipline (241 + 249).
- Two-cycles-with-explicit-undefined-as-no-value-or-no-feature signal (239 + 249).
- Two-cycles-with-deferred-or-sync-bridge-patterns (241 + 249).
- Two-cycles-with-explicit-defense-against-method-detach-as-named-discipline (146 + 249).
- First-explicit-observation of seven patterns: §`export {};`-typedef-only-file-pattern + §applyMethod-as-atomic-lookup-of-method-and-apply + §discriminator-payload-tuple-as-named-sync-result-encoding + §the-non-thenable-constraint + §`keyof InterfaceName`-as-defense-by-construction + §out-of-band-communications-as-named-sync-over-async-mechanism + §the-three-method-vs-six-method-handler-protocol-distinction.

## Library scale

- 755 sections from 296 source documents (through 2026-06-08).
- Eighty-third consecutive designs-chat alternation cycle (cycles 166-249).
- Next cycle is designs-lane.
