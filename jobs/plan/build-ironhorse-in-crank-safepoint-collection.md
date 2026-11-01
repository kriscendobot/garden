---
gate: awaiting-maintainer
maintainer_question: 'Agree to amend ironhorse-quiescent-gc to admit a native-depth-zero dispatch safepoint collection inside a crank (design #1622, open question 1), or wait for ropes?'
asked_at: https://github.com/endojs/endo-but-for-bots/pull/1622
priority: normal
posted_by: builder
posted_at: 2026-11-01T17:58:55Z
---

---
role: builder
arc: ironhorse-test262-ratchet
dispatch: automatic
tier: mentor
fallback-tier: minion
---
# Build: safepoint collection from endojs/endo-but-for-bots#1622

Repo: https://github.com/endojs/endo-but-for-bots. Design PR: https://github.com/endojs/endo-but-for-bots/pull/1622 (`designs/ironhorse-in-crank-string-garbage.md`, § Recommended design: safepoint collection).

Build the in-crank dispatch-safepoint collection: the admission predicate (`at_dispatch_safepoint`: between instructions, native depth zero, no pending halt, `gc_failed` clear, no undeclared temporary roots), the deterministic chunk/slot pressure trigger (more than 1/2 of the ceiling used AND at least 1/4 of the ceiling allocated since the last collection), weak targets kept strong during in-crank collection, meter neutrality, and the design's test plan (100k append loop, MEM-1 loop of 2M iterations, reduce-callback still halts, WeakRef deref, anti-thrash counter, determinism, and the ~820 property-escapes/unicodeSets/CharacterClassEscapes rows moving from `skip:ironhorse-aborted-limit` to `pass`). Open a DRAFT PR.

Gate: the design amends the `ironhorse-quiescent-gc` contract, so it needs the maintainer's agreement (the first open question on #1622). Also read the design's second open question (whether the trigger constants are fixed per profile) before starting. Prerequisites: #1618 (matcher run compression). The RegExp half already shipped as https://github.com/endojs/endo-but-for-bots/pull/1624 (job build-ironhorse-in-crank-string-garbage-chunk-ceiling).
