---
kind: result
role: liaison
dispatch-root: dispatches/liaison--3ad844
cycle: 335
lane: designs
host: endolin
date: 2026-06-15
---

# Result — liaison cycle 335: @endo/promise-kit README.md (designs-lane; thirteenth package; deliberately-imperfect-ponyfill; one-cycle-streak ends)

Cycle 335 ingest: **@endo/promise-kit README.md** (71 lines). Designs-lane after cycle 334. **Twenty-sixth consecutive non-garden source after the pivot** (cycles 310-335). **§twenty-six-cycles-with-named-pivot-domain-stay**. **§thirteen-named-packages-in-the-pivot-cluster** (thirteenth: promise-kit; previously in library via cycle 152 memo-race.js comment-fragment).

## Two milestones this cycle

**§the-named-one-cycle-streak-ends-at-seven** — cycle 334 → 335 is cross-package (common → promise-kit), NOT a README↔source pair of the same package. The §seven-cycles-with-named-one-cycle-README-source-arc streak from cycles 323-334 ends here. The dense pair-landing rhythm was a *streak*, not a sustained tempo. First-explicit-observation as a discipline-break.

**§the-named-citation-arc-from-cycle-152-takes-183-cycles-to-close** — cycle 152 ingested memo-race.js from @endo/promise-kit; cycle 335 IS the README of that package. Long arc closure.

Closes **three citation arcs**:

| Closes arc with | Arc length | Subject |
|---|---|---|
| Cycle 152 (memo-race.js) | 183 cycles | README of the package |
| Cycle 317 (hex README) | 18 cycles | Ponyfill terminology re-applied |
| Cycle 321 (eventual-send README) | 14 cycles | Promise-pipelining named as accommodation |

**§forty-nine-citation-arc-closures-in-pivot-now** (46 + 3).

## Single most structurally interesting move

**§the-named-deliberately-imperfect-ponyfill** — line 4 of the README:

> Note that this serves as a "ponyfill" for `Promise.withResolvers`, making certain accommodations to ensure that the resulting promises can pipeline messages through `@endo/eventual-send`.

The README acknowledges **both**:
1. **Identity** — *"serves as a 'ponyfill' for `Promise.withResolvers`"*
2. **Divergence** — *"making certain accommodations to ensure that the resulting promises can pipeline messages through `@endo/eventual-send`"*

A *ponyfill* (terminology from cycle 317 @endo/hex README) usually means a *faithful* shim for a not-yet-available API. Cycle 335 introduces a structural variant: **the ponyfill is deliberately imperfect**.

**§the-named-ponyfill-with-named-deliberate-divergence** — first-explicit-observation. **§two-shapes-of-ponyfill-discipline** now has two named subtypes:

| Subtype | Cycle | Behavior |
|---|---|---|
| **Faithful ponyfill** | 317 @endo/hex | Matches the spec exactly |
| **Deliberately imperfect ponyfill** | 335 @endo/promise-kit | Deviates from the spec for named integration reasons |

**§two-cycles-with-named-ponyfill-vs-polyfill-distinction** (317 + 335).

## §the-named-protocol-described-from-both-ends-discipline

Cycle 321 eventual-send README described promise-pipelining from the **E() side** ("messages can be sent to promises before they resolve"). Cycle 335 promise-kit README describes the same protocol from the **promise-kit side** ("certain accommodations to ensure that the resulting promises can pipeline messages through @endo/eventual-send").

Two READMEs, opposite perspectives, same protocol relationship. **§the-named-protocol-described-from-both-ends-discipline** — first-explicit-observation as a tier-3 meta-pattern.

## Other notable observations

- §the-named-makePromiseKit-IS-named-canonical-promise-deferred — central API returns `{ promise, resolve, reject }` three-tuple
- §the-named-example-with-both-branches — Basic Example shows BOTH success and failure paths; §two-cycles-with-named-example-with-both-branches (327 + 335)
- §the-named-multiple-promise-kits-example-shows-composability — second worked example
- §the-named-API-section-minimal (six lines total); §the-named-API-section-depth-tracks-package-complexity (minimal for simple package; deep for substrate)
- §the-named-License-section-presence-varies — cycle 333 @endo/common omitted; cycle 335 @endo/promise-kit included; choice tracks README's purpose
- §three-cycles-with-named-Agoric-citation (321 + 323 + 335)

## Multi-cycle patterns extended

- §twenty-six-cycles-with-named-pivot-domain-stay (310-335)
- §thirteen-named-packages-in-the-pivot-cluster (thirteenth: promise-kit)
- §forty-nine-citation-arc-closures-in-pivot-now
- §two-cycles-with-named-ponyfill-vs-polyfill-distinction (317 + 335)
- §two-cycles-with-named-example-with-both-branches (327 + 335)
- §three-cycles-with-named-Agoric-citation (321 + 323 + 335)

## Patterns the cycle breaks

- **§the-named-one-cycle-streak-ends-at-seven** — the §seven-cycles-with-named-one-cycle-README-source-arc streak from cycles 323-334 ends here

## Tier-3 meta-patterns

- **§the-named-deliberately-imperfect-ponyfill** — when a package shims a standard API but needs behavioral differences, name BOTH the shim relationship AND the divergence
- **§two-shapes-of-ponyfill-discipline** — faithful (cycle 317) vs deliberately-imperfect (cycle 335)
- **§the-named-protocol-described-from-both-ends-discipline** — two READMEs can describe the same protocol relationship from opposite perspectives
- **§the-named-License-section-presence-varies** — collection-packages omit; utility-packages include; choice tracks purpose
- **§the-named-API-section-depth-tracks-package-complexity** — minimal API for simple packages; deep API for substrate

## Synthesis-target

Slot machine library **§`@game/promise-kit/README.md`** — deferred-promise utility:

1. **Deliberately-imperfect-ponyfill** framing if shimming a standard API with named accommodations
2. **Three-named-returns** (promise + resolve + reject)
3. **Example with both branches** (success + failure)
4. **Second example for composability**
5. **Minimal API section** if API is simple
6. **License section as a choice**
7. **Single-link Links section** if no further reading needed
8. **Six-section README shape** for mid-size utility-packages
9. **Cite the spec API by name** so readers can locate the standard

## Library state after cycle 335

- §library-reaches-847-sections from 381 source documents
- §one-hundred-and-sixty-eighth consecutive designs-chat alternation
- §twenty-six-cycles-with-named-pivot-domain-stay
- §thirteen-named-packages-in-the-pivot-cluster
- §forty-nine-citation-arc-closures-in-pivot-now
- §the-named-one-cycle-streak-ends-at-seven — the dense pair-landing rhythm was a *streak*, not a sustained tempo; the pivot now varies between dense-pair-landings and cross-package README additions
- §two-shapes-of-ponyfill-discipline established as a tier-3 meta-pattern

## Next cycle pacing

Cycle 336 is chat-lane next. Candidate moves:

- **@endo/promise-kit/src/memo-race.js** — fifth complementary-lens re-ingest (cycle 152 ingested as comment-fragment); would form adjacent-reverse pair with cycle 335 README
- **@endo/promise-kit/src/promise-kit.js** — if it exists; would be the canonical source for makePromiseKit
- **@endo/init source** — would introduce a fourteenth package
- **@endo/harden source** — would introduce a fourteenth package

@endo/promise-kit/src/memo-race.js complementary-lens re-ingest is the most productive (fifth instance of librarian discipline; pairs with cycle 335 README; closes the 183-cycle arc with cycle 152 from both sides). Picking freely but tracking for future work.
