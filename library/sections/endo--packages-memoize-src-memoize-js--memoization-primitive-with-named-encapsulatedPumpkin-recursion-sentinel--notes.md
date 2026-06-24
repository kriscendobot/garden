---
title: Notes
section-slug: endo--packages-memoize-src-memoize-js--memoization-primitive-with-named-encapsulatedPumpkin-recursion-sentinel
source-slug: endo--packages-memoize-src-memoize-js
url: https://github.com/endojs/endo/blob/master/packages/memoize/src/memoize.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/memoize/src/memoize.js
total-lines: 54
ingest-cycle: 312
ingest-date: 2026-06-11
lane: chat
scope: full
parent: endo--packages-memoize-src-memoize-js--memoization-primitive-with-named-encapsulatedPumpkin-recursion-sentinel
---

- The encapsulatedPumpkin name IS a Cinderella reference. The Cinderella carriage turns back into a pumpkin at midnight; seeing the pumpkin signals "the spell has lifted; this value IS no longer what you expect." The naming IS a mnemonic for "if you see this, the result IS not real yet." **§the-named-narrative-naming-discipline**.
- The named-explicit-TS-limitation-comment IS a worked example of how to document TypeScript's flow-analysis gaps. Most JS code silently uses type assertions without comment; this one names *why* the assertion IS necessary, citing two limitations. **§the-named-cite-the-tool-limitation-discipline**.
- The named-dual-purpose-sentinel-set IS a structural pattern: one statement that serves two named purposes (recursion-detection + invalid-arg-detection). The comment names both. **§the-named-multi-purpose-statement-IS-named-named**.
- Cycle 312 IS the third consecutive @endo/* cycle. The cluster's pivot IS now demonstrably productive at three cycles. Future cycles may continue pivoting through fresh material before the next saturation.
- The named-WeakKey-constraint via `@template {WeakKey} A` IS modern TypeScript-style; the underlying type IS the union of object types that can be WeakMap keys (formerly required `object`; now allows symbol primitives that are unique).
