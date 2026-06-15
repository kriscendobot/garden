---
title: "@endo/promise-kit README.md — thirteenth package; deliberately-imperfect-ponyfill discipline (ponyfill for Promise.withResolvers WITH named eventual-send accommodations); closes cycle 152 memo-race arc at 183 cycles"
source: endo--packages-promise-kit-README-md
url: https://github.com/endojs/endo/blob/master/packages/promise-kit/README.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/promise-kit/README.md
total-lines: 71
ingest-cycle: 335
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-deliberately-imperfect-ponyfill
  - the-named-ponyfill-with-named-deliberate-divergence
  - the-named-makePromiseKit-IS-named-canonical-promise-deferred
  - the-named-eventual-send-pipelining-IS-named-accommodation
  - the-named-example-with-both-branches
  - the-named-three-named-returns
  - the-named-multiple-promise-kits-example-shows-composability
  - the-named-License-section-Apache-2.0
  - the-named-six-section-README-shape
  - the-named-Agoric-smart-contract-OR-JavaScript-program
  - twenty-six-cycles-with-named-pivot-domain-stay
  - thirteen-named-packages-in-the-pivot-cluster
  - forty-nine-citation-arc-closures-in-pivot-now
  - two-cycles-with-named-ponyfill-vs-polyfill-distinction
---

# `@endo/promise-kit README.md` — thirteenth package; deliberately-imperfect-ponyfill

The 71-line README for `@endo/promise-kit`. Cycle 335 is **designs-lane after cycle 334's chat-lane @endo/common/object-map.js**. **Twenty-sixth consecutive non-garden source after the pivot** (cycles 310-335). **§twenty-six-cycles-with-named-pivot-domain-stay**. **§thirteen-named-packages-in-the-pivot-cluster** (nat + memoize + hex + lp32 + stream + eventual-send + exo + captp + pass-style + patterns + marshal + common + **promise-kit** — THIRTEENTH package adds; previously in library via cycle 152 memo-race.js comment-fragment).

The §seven-cycles-with-named-one-cycle-README-source-arc streak ends at seven. Cycle 335 doesn't close a one-cycle README↔source arc with cycle 334 (different packages: common → promise-kit). **§the-named-one-cycle-streak-ends-at-seven** — first-explicit-observation. The dense pair-landing rhythm was a *streak*, not a sustained tempo; the pivot now varies between dense-pair-landings and cross-package README additions.

Closes **three citation arcs**:

| Closes arc with | Arc length | Subject |
|---|---|---|
| Cycle 152 (memo-race.js) | 183 cycles | This is the README of the package that memo-race.js belongs to |
| Cycle 317 (hex README) | 18 cycles | First-explicit-observation of ponyfill terminology; cycle 335 uses it |
| Cycle 321 (eventual-send README) | 14 cycles | promise-pipelining benefit; cycle 335 names it as the accommodation |

**§forty-nine-citation-arc-closures-in-pivot-now** (46 + 3).

## The single most structurally interesting move

**§the-named-deliberately-imperfect-ponyfill** — line 4 of the README:

> Note that this serves as a "ponyfill" for `Promise.withResolvers`, making certain accommodations to ensure that the resulting promises can pipeline messages through `@endo/eventual-send`.

A *ponyfill* (terminology from cycle 317 @endo/hex README) usually means a *faithful* shim for a not-yet-available native API: exports a function that doesn't mutate globals, providing the same surface as the native version. Cycle 335 introduces a structural variant: **the ponyfill is deliberately imperfect**.

The README acknowledges both:
1. **Identity** — *"serves as a 'ponyfill' for `Promise.withResolvers`"*
2. **Divergence** — *"making certain accommodations to ensure that the resulting promises can pipeline messages through `@endo/eventual-send`"*

**§the-named-ponyfill-with-named-deliberate-divergence** — first-explicit-observation. The pattern is transferable: when a package is *almost* a ponyfill for a standard API but needs behavioral differences, name BOTH the shim relationship AND the divergence. Don't pretend the ponyfill is faithful when it isn't; don't hide the relationship to the standard either.

This is sibling to cycle 317 @endo/hex README's **§the-named-ponyfill-IS-named-precise-over-polyfill** (ponyfill = no global mutation = SES-compatible) but with the *named imperfection* twist added. **§two-cycles-with-named-ponyfill-vs-polyfill-distinction** (317 + 335). The discipline now has two shapes:
- **Faithful ponyfill** (cycle 317 @endo/hex): the ponyfill matches the spec exactly
- **Deliberately imperfect ponyfill** (cycle 335 @endo/promise-kit): the ponyfill deviates from the spec for named integration reasons

§the-named-two-shapes-of-ponyfill-discipline (faithful vs deliberately-imperfect) — first-explicit-observation as a tier-3 meta-pattern.

## §the-named-eventual-send-pipelining-IS-named-accommodation

The README names *promise-pipelining* (cycle 321's canonical benefit) as the **reason for the divergence**. The accommodations exist to make promise-kit's resulting promises *compatible with @endo/eventual-send's pipelining semantics*.

This is the inverse of cycle 321's framing. Cycle 321 named promise-pipelining as a benefit *enabled by* `E()`; cycle 335 names eventual-send-pipelining as something *promise-kit accommodates*. The two READMEs describe the same protocol relationship from opposite sides. **§the-named-protocol-described-from-both-ends-discipline** — first-explicit-observation. Sibling to cycle 321's eventual-send README's §the-named-cross-package-link-list-with-roles (which described how packages relate from one side).

## Other key moves

- **§the-named-makePromiseKit-IS-named-canonical-promise-deferred** (line 3, 13, 17) — the central API. Returns `{ promise, resolve, reject }`. **§the-named-three-named-returns** — the canonical "deferred" pattern that many JS libraries provide; @endo/promise-kit names it canonically.

- **§the-named-Agoric-smart-contract-OR-JavaScript-program** (line 8) — *"in an Agoric smart contract or JavaScript program"* — names two example contexts. Sibling to cycles 321 + 323 Agoric-citation discipline. **§three-cycles-with-named-Agoric-citation** (321 money-flow + 323 Agoric-modules + 335 Agoric-smart-contract).

- **§the-named-example-with-both-branches** (line 12-40) — Basic Example shows BOTH the success path AND the failure path via `if (success) ... else { reject(...) }`. The comment *"Simulating success or failure"* hints at both branches even though the variable is hardcoded to `true`. Sibling to cycle 327 patterns README's §the-named-Quick-Start-shows-error-output discipline. **§two-cycles-with-named-example-with-both-branches** (327 + 335).

- **§the-named-multiple-promise-kits-example-shows-composability** (line 42-56) — second worked example explicitly titled *"Creating Multiple Promise Kits"*. Shows that multiple kits are independent and composable. **§the-named-second-example-for-composability**. First-explicit-observation.

- **§the-named-API-section-minimal** (line 58-66) — six lines of API documentation: function signature + three Returns bullets. **§the-named-minimal-API-section** — the API documentation is *terse* because the function is *simple*. First-explicit-observation. Compare to cycle 321's twelve-section substrate README (deep API with many subsections) vs cycle 333's seventeen-line collection README (no API section at all). The package's API-section-depth tracks the package's complexity.

- **§the-named-Links-section** (line 68-69) — single-link section pointing to the package's GitHub repository. Different from cycle 321's See Also (multiple links) or cycle 327's Deep Dives (internal docs). **§the-named-single-link-Links-section** — first-explicit-observation. The minimalism matches the simplicity of the package.

- **§the-named-License-section-Apache-2.0** (line 71-72) — explicit License section. Compare to cycle 333 @endo/common which had NO License section (the LICENSE file is authoritative). The two utility-packages made *different* choices about License sections. **§the-named-License-section-presence-varies** — first-explicit-observation. The variation isn't arbitrary; it tracks the README's purpose: collection-package (cycle 333) defers to LICENSE file; utility-package (cycle 335) includes inline.

- **§the-named-six-section-README-shape** — heading-less intro + Usage (with two examples) + API + Links + License. Six sections including the heading-less intro. Mid-size utility-package shape. Compare to cycle 317 hex (4 sections, 60 lines) and cycle 311 nat (6 sections, 116 lines).

- **§the-named-ponyfill-with-named-API-name** — the ponyfill names `Promise.withResolvers` *with full path*. The reader can find the standard via the name. §the-named-cite-the-spec-API-by-name.

## Patterns the cycle extends

- §twenty-six-cycles-with-named-pivot-domain-stay (310-335)
- §thirteen-named-packages-in-the-pivot-cluster (thirteenth: promise-kit)
- §forty-nine-citation-arc-closures-in-pivot-now (46 + 3)
- §two-cycles-with-named-ponyfill-vs-polyfill-distinction (317 + 335)
- §two-cycles-with-named-example-with-both-branches (327 + 335)
- §three-cycles-with-named-Agoric-citation (321 + 323 + 335)
- §the-named-citation-arc-from-cycle-152-takes-183-cycles-to-close

## Patterns the cycle breaks

- **§the-named-one-cycle-streak-ends-at-seven** — cycle 334 → 335 is cross-package (common → promise-kit), NOT a README↔source pair of the same package. The §seven-cycles-with-named-one-cycle-README-source-arc streak from cycles 323-334 ends. First-explicit-observation. The rhythm was a *streak*, not a sustained tempo.

## Tier-1 borrowing (twenty-plus first-explicit-observations)

All §-tags marked first-explicit-observation. Highest-portability:

- **§the-named-deliberately-imperfect-ponyfill** with **§the-named-ponyfill-with-named-deliberate-divergence**
- **§the-named-two-shapes-of-ponyfill-discipline** (faithful vs deliberately-imperfect)
- **§the-named-protocol-described-from-both-ends-discipline** (cycle 321 from E() side; cycle 335 from promise-kit side)
- **§the-named-License-section-presence-varies** (collection-package omits; utility-package includes)
- **§the-named-API-section-depth-tracks-package-complexity**
- **§the-named-second-example-for-composability**

## Tier-2 borrowing (multi-cycle patterns extended)

- §twenty-six-cycles-with-named-pivot-domain-stay
- §thirteen-named-packages-in-the-pivot-cluster
- §forty-nine-citation-arc-closures-in-pivot-now
- §two-cycles-with-named-ponyfill-vs-polyfill-distinction
- §three-cycles-with-named-Agoric-citation
- §the-named-citation-arc-from-cycle-152-takes-183-cycles-to-close

## Tier-3 borrowing (meta-patterns)

- **§the-named-deliberately-imperfect-ponyfill** — when a package is *almost* a ponyfill for a standard API but needs behavioral differences, name BOTH the shim relationship AND the divergence
- **§the-named-two-shapes-of-ponyfill-discipline** — faithful (cycle 317) vs deliberately-imperfect (cycle 335)
- **§the-named-protocol-described-from-both-ends-discipline** — when two packages cooperate via a protocol, each README can describe the same relationship from its own perspective
- **§the-named-License-section-presence-varies** — collection-packages defer to LICENSE file; utility-packages include inline License section; choice tracks README's purpose
- **§the-named-API-section-depth-tracks-package-complexity** — minimal API for simple packages; deep API for substrate packages

## Synthesis-target

Slot machine library **§`@game/promise-kit/README.md`** — deferred-promise utility:

1. **Deliberately-imperfect-ponyfill** framing if the package shims a standard API with named accommodations
2. **Three-named-returns** (`promise`, `resolve`, `reject`) for the canonical deferred shape
3. **Example with both branches** (success + failure)
4. **Second example for composability** (multiple kits)
5. **Minimal API section** if the API is simple
6. **License section** as a choice (depending on whether the README defers to the LICENSE file)
7. **Single-link Links section** if there's no further reading needed
8. **Six-section README shape** for mid-size utility-packages
9. **Cite the spec API by name** (`Promise.withResolvers`-equivalent) so readers can locate the standard

## Library state after cycle 335

- §library-reaches-847-sections from 381 source documents
- §one-hundred-and-sixty-eighth consecutive designs-chat alternation
- §twenty-six-cycles-with-named-pivot-domain-stay
- §thirteen-named-packages-in-the-pivot-cluster
- §forty-nine-citation-arc-closures-in-pivot-now
- §the-named-one-cycle-streak-ends-at-seven — the dense pair-landing rhythm was a seven-cycle streak; cycle 335 breaks it by being a cross-package README addition
- §two-shapes-of-ponyfill-discipline established as a tier-3 meta-pattern
