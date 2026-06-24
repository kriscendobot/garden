---
kind: result
role: liaison
dispatch-root: dispatches/liaison--dceef6
cycle: 323
lane: designs
host: endolin
date: 2026-06-15
---

# Result — liaison cycle 323: @endo/captp README.md (designs-lane; eighth package added to pivot; three citation arcs close; Hardened-JS-discipline streak breaks)

Cycle 323 ingest: **@endo/captp README.md** (65 lines). Designs-lane after cycle 322's chat-lane. **Fourteenth consecutive non-garden source after the pivot** (cycles 310-323). **§fourteen-cycles-with-named-pivot-domain-stay**. **Eighth package added to pivot cluster** (nat + memoize + hex + lp32 + stream + eventual-send + exo + captp); previously in library via cycles 154 + 156 + 158 comment-fragments.

## Single most structurally interesting move

**§the-named-API-with-honesty-about-relaxed-security-model** — TrapCaps section explicitly states (line 40-42):

> This is a specialized and advanced use case, not for mutually-suspicious CapTP parties, but instead for clear "guest"/"host" relationship.

CapTP's foundational guarantee is *mutual suspicion*; TrapCaps relaxes that. The README admits the relaxation in user-facing prose and gates the use case.

**§the-named-honesty-about-API-tradeoffs** now has **two parameterized subtypes**:

| Subtype | Cycle | Specific phrase |
|---|---|---|
| Low-utility-paths | 321 | "Most users don't need this" |
| Relaxed-security-models | 323 | "Not for mutually-suspicious parties" |

Both patterns share the form *"name the trade in user-facing prose so consumers can reason about fit"*. First-explicit-observation as a *parameterized meta-pattern*.

## Three citation arcs close

| Cycle 323 closes | Arc length | Subject |
|---|---|---|
| Cycle 154 | 169 cycles | trap.js comment-fragment → captp README's TrapCaps section |
| Cycle 158 | 165 cycles | loopback.js comment-fragment → captp README's Loopback section |
| Cycle 321 | 2 cycles | eventual-send README's "Network Transport: captp" → captp README |

**§seven-citation-arc-closures-in-pivot-now**: 2, 4, 165, 169, 175, 214, 255.

## The Hardened-JS-discipline streak breaks

**§the-named-discipline-breaks-in-pivot-at-cycle-323** — §eleven-cycles-with-named-Hardened-JS-discipline (310 + 312 + 313 + 315 + 316 + 317 + 318 + 319 + 320 + 321 + 322) **stops at cycle 323**. The captp README does not mention Hardened-JS, harden, or any related vocabulary — even though the captp source files (cycles 154 + 156 + 158) use harden extensively.

**§the-named-Hardened-JS-absent-from-README-but-present-in-code** — a documentation-side break of an implementation-side discipline. The captp README treats Hardened-JS as implicit-context rather than dedicating a section to it. First-explicit-observation as a pattern-break.

## Other first-explicit-observations (twenty-plus)

- §the-named-Trap-and-E-named-pair (symmetric shape, different semantics: sync vs async)
- §the-named-Loopback-as-named-test-fixture (closes citation arc with cycle 158)
- §the-named-async-barrier-between-near-and-far + §the-named-near-and-far-IS-named-canonical-CapTP-vocabulary
- §the-named-myconn-disclaimer + §the-named-library-boundary-explicitly-named (NOTE prefix)
- §the-named-three-return-values-from-makeCapTP
- §the-named-synchronous-iterator-drives-async-iterator-pattern (sync→async coupling via shared iteration)
- §the-named-sync-bridge-via-SharedArrayBuffer-and-Atomics
- §the-named-advanced-section-IS-named-longer-than-canonical-section (TrapCaps 33 > Usage 20 > Loopback 4)
- §the-named-explanation-by-analogy-to-named-abstraction ("consider X as Y" framing)
- §the-named-numbered-three-step-recipe-for-TrapCaps with §the-named-asymmetric-numbered-steps-for-asymmetric-roles
- §the-named-partial-support-disclaimer (Loopback's specific limitation; surgical precision)
- §the-named-Agoric-cited-as-genealogy
- §the-named-four-section-shape-recurs-with-different-content (cycle 317 hex same shape, different content)

## Multi-cycle patterns extended

- §fourteen-cycles-with-named-pivot-domain-stay (310-323)
- §eight-named-packages-in-the-pivot-cluster (eighth: captp)
- §seven-citation-arc-closures-in-pivot-now (2 + 4 + 165 + 169 + 175 + 214 + 255 cycles)
- §two-cycles-with-named-Agoric-as-named-genealogy (321 + 323)
- §two-cycles-with-named-four-section-README-shape (317 + 323)
- §two-cycles-with-named-CapTP-or-E-language-jargon-as-given (321 + 323)
- §two-cycles-with-named-Trap-and-E-named-pair (154 + 323)
- §two-cycles-with-named-Loopback-as-named-test-fixture (158 + 323)

## Tier-3 meta-patterns

- **§the-named-honesty-about-API-tradeoffs** parameterized as two subtypes (low-utility-paths + relaxed-security-models)
- **§the-named-API-with-honesty-about-relaxed-security-model** — when an API gives up a foundational security guarantee, name the relaxation and gate the use case
- **§the-named-synchronous-iterator-drives-async-iterator-pattern** — iteration as protocol-level synchronization point between sync and async
- **§the-named-sync-bridge-via-SharedArrayBuffer-and-Atomics** — JS-language mechanism for sync-from-async
- **§the-named-explanation-by-analogy-to-named-abstraction** — "consider X as Y" framing
- **§the-named-discipline-breaks-in-pivot-at-cycle-323** — a Tier-2 streak (eleven cycles) breaks; document the break as meaningful
- **§the-named-Hardened-JS-absent-from-README-but-present-in-code** — documentation can omit what implementation includes
- **§the-named-advanced-section-IS-named-longer-than-canonical-section** — section length proportional to complexity, not importance
- **§the-named-shape-recurs-content-differs** — README shapes recur; content varies; shape is form, not content
- **§the-named-library-boundary-explicitly-named** — when caller-supplied code interleaves with library code, name the boundary

## Synthesis-target

Slot machine library **§`@game/comms/README.md`** — game-server-to-renderer communication:

1. Minimal package-name + one-line description opening.
2. NOTE prefix at the start of Usage to mark library boundary.
3. Three return values destructured from the main maker.
4. Eight-line lifecycle example.
5. Explicit abort with Error argument for teardown.
6. Honest disclaimer for advanced features — if security relaxed, name the trade.
7. Numbered recipe with role-asymmetry.
8. Explanation by analogy ("consider the broadcast bus as a maker of AsyncIterators...").
9. Named limitation with specific mechanism for partial-support.
10. Four-section shape with advanced section longer than canonical.
11. JS-language sync-bridge named if sync-from-async supported.
12. Iteration-as-protocol-synchronization-point for sync→async coupling.
13. Library boundary explicitly named via NOTE.
14. Hardened-JS can be implicit when family-wide (the discipline can hold at the implementation level without naming in every README).

## Library state after cycle 323

- §library-reaches-835-sections from 372 source documents
- §one-hundred-and-fifty-sixth consecutive designs-chat alternation
- §fourteen-cycles-with-named-pivot-domain-stay
- §eight-named-packages-in-the-pivot-cluster
- §seven-citation-arc-closures-in-pivot-now
- **The Hardened-JS-discipline streak (11 cycles) breaks** — first pattern-break in the pivot

## Next cycle pacing

Cycle 324 is chat-lane next. Candidate moves:

- **@endo/captp/src/captp.js** (the main captp.js, if it exists) — chat-lane; would form adjacent-reverse pair with cycle 323 README → source, mirroring lp32 315-316 and exo 321-322 (but those were across different packages).
- **@endo/exo/src/exo-tools.js** (513 lines, already in library from cycle 118 as comment-fragment) — chat-lane; would be another complementary-lens re-ingest like cycle 322; would close another long citation arc.
- **@endo/patterns/src/...** — would introduce a ninth package; @endo/patterns was the "Validation" role-label citation in cycle 321 (still-open arc).
- **@endo/pass-style/src/index.js or similar** — would heavily extend an existing cluster; many existing pass-style files in library.

@endo/captp/src/captp.js or @endo/exo/src/exo-tools.js are the most directly productive choices. Picking freely but tracking for future work.
