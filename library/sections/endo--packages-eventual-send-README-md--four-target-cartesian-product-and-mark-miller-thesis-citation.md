---
title: "@endo/eventual-send README.md — four-target cartesian product (local/remote × value/promise); Mark Miller thesis citation; two long-haul citation arcs close (cycles 66 + 146); sixth package, substrate-shape README"
source: endo--packages-eventual-send-README-md
url: https://github.com/endojs/endo/blob/master/packages/eventual-send/README.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/eventual-send/README.md
total-lines: 332
ingest-cycle: 321
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-four-target-cases-as-cartesian-product
  - the-named-cartesian-product-of-locality-and-resolution
  - the-named-Mark-Miller-thesis-cited-as-original-source
  - the-named-citation-to-original-academic-source
  - the-named-eval-twins-as-named-coordination-hazard
  - the-named-acknowledged-in-group-vocabulary
  - the-named-citation-arc-from-cycle-66-takes-255-cycles-to-close
  - the-named-citation-arc-from-cycle-146-takes-175-cycles-to-close
  - the-named-promise-pipelining-IS-named-canonical-benefit
  - the-named-canonical-pipeline-example-IS-named-money-flow
  - the-named-four-numbered-benefits-section
  - the-named-write-local-code-deploy-distributed-promise
  - the-named-message-ordering-IS-named-guaranteed-per-target
  - the-named-cross-package-link-list-with-roles
  - the-named-relative-path-link-as-cross-package-citation
  - the-named-two-Integration-sections-pattern
  - the-named-resolveWithPresence-IS-named-third-settle-mode
  - the-named-handler-intercepts-operations
  - the-named-most-users-don't-need-this-disclaimer
  - the-named-API-with-honesty-about-low-utility-paths
  - the-named-Use-in-Tests-section
  - the-named-shim-section-explains-eval-twins-coordination
  - the-named-twelve-section-README-shape-IS-named-substrate-package
  - twelve-cycles-with-named-pivot-domain-stay
  - six-named-packages-in-the-pivot-cluster
  - six-README-shapes-now
  - ten-cycles-with-named-Hardened-JS-discipline
  - three-citation-arc-closures-in-pivot-now
---

# `@endo/eventual-send README.md` — sixth package, substrate-shape README, two long-haul citation arcs close

The 332-line README for `@endo/eventual-send` — by far the deepest README ingested in the pivot cluster. Twelve sections; cross-references to four sibling packages; novel terminology ("eval twins"); and a citation to Mark Miller's PhD thesis ("Concurrency Among Strangers"). Cycle 321 is **designs-lane after cycle 320's chat-lane @endo/lp32 writer.js**. **Twelfth consecutive non-garden source after the pivot** (cycles 310-321). **§twelve-cycles-with-named-pivot-domain-stay**. **§six-named-packages-in-the-pivot-cluster** (nat + memoize + hex + lp32 + stream + eventual-send — sixth package adds).

## The single most structurally interesting move

**§the-named-four-target-cases-as-cartesian-product** — the README's engineering claim is that `E()` works *uniformly* across four cases (line 61-65):

> - A local object
> - A local promise for an object
> - A remote presence in another vat
> - A promise for a remote presence

These four cases are the **cartesian product of two independent binary dimensions**:

| | Local | Remote |
|---|---|---|
| **Value** | local object | remote presence |
| **Promise** | local promise | remote promise |

**§the-named-cartesian-product-of-locality-and-resolution** — first-explicit-observation as a named cross-product. This is the *same structural pattern* as cycle 317's **§the-named-pair-shape-IS-named-cross-product-of-order-and-gap** (pair shapes parameterized by order × gap). **§two-cycles-with-named-cartesian-product-structural-pattern** (317 pair shapes + 321 target cases). The pattern itself is a tier-3 meta-observation: *structural enumerations as cross-products of independent binary dimensions make the enumeration not just exhaustive but reasonable-about by axis*.

The cartesian-product framing makes the claim **falsifiable**: if `E()` works for three of the four cases but breaks on the fourth, the framing surfaces the gap. A flat "works for many cases" wouldn't. §the-named-cross-product-enumeration-IS-named-falsifiable-claim.

## Two long-haul citation arcs close

**§the-named-citation-arc-from-cycle-66-takes-255-cycles-to-close** — cycle 66 was the *very first* comment-fragment ingest in the library (handled-promise.js handler protocol). Cycle 321's README describes the same handler protocol at line 269-276:

```js
const handler = {
  get(target, prop) { /* ... */ },
  applyMethod(target, verb, args) { /* ... */ }
};
```

The cycle 66 ingest named the *forwarding-graph as union-find forest* and the SendOnly/applyMethod reductions; cycle 321 names the handler protocol in user-facing docs. The arc is 255 cycles long — the **longest citation arc to close in the library so far**. First-explicit-observation.

**§the-named-citation-arc-from-cycle-146-takes-175-cycles-to-close** — cycle 146 ingested E.js as a comment-fragment (the E proxy-handler trio + this-receiver check + makeE factory + all five surface API forms: E() / E.get / E.sendOnly / E.when / E.resolve). Cycle 321 *is* the README that introduces those same five surface API forms. The arc is 175 cycles long. **Second-longest citation arc** to close in the library.

**§three-citation-arc-closures-in-pivot-now**: cycle 319 closed cycle 315's four-cycle arc (lp32 → stream); cycle 321 closes cycle 146 (175 cycles) and cycle 66 (255 cycles). The pivot has now closed three citation arcs of widely varying lengths (4, 175, 255).

## Mark Miller's thesis cited as original source

**§the-named-Mark-Miller-thesis-cited-as-original-source** — the See Also section (line 329-330) cites:

> Concurrency Among Strangers — Mark S. Miller's thesis on eventual send

This is the **first time in the pivot cluster** (and likely the library) that a foundational academic source — a PhD thesis — is cited as the genealogical origin of an API. **§the-named-citation-to-original-academic-source** as a discipline. The README earns the right to make its engineering claims (cartesian-product uniformity, promise pipelining, message ordering, future-proof code) by *grounding them in the academic genealogy*. A simpler README would have just shown E()'s syntax; this one says: *here's the thesis*.

This is also the maintainer's stated intellectual lineage. (Standing context from earlier in this session: "Mark Miller has been my mentor for fifteen years.")

## Other key moves

- **§the-named-eval-twins-as-named-coordination-hazard** (line 31-33) — *"The shim ensures that every instance of Eventual Send can recognize every other instance's handled promises. This is how we mitigate, what we call, 'eval twins'."* §the-named-eval-twins is novel terminology for the hazard where the same package is loaded multiple times in different evaluation contexts and each instance maintains its own handler tables. §the-named-acknowledged-in-group-vocabulary — the meta-discourse phrase *"what we call"* explicitly marks this as in-group terminology, signaling to outsiders that the term is local. **§the-named-vocabulary-IS-named-acknowledged-as-local** as a documentation discipline. First-explicit-observation.

- **§the-named-shim-section-explains-eval-twins-coordination** (line 18-33) — the Shim section is structurally about *coordination across instances of the same package*, not about polyfilling missing language features. The shim ensures global handler-table coordination so multiple-loaded instances recognize each other's handled promises. **§the-named-instance-coordination-via-shim-discipline** — first-explicit-observation. Contrasts with the polyfill/ponyfill discipline from cycle 314/317 hex (which is about local feature provision).

- **§the-named-promise-pipelining-IS-named-canonical-benefit** (line 138-173) — promise pipelining gets its own dedicated section with two side-by-side examples (with pipelining: messages sent immediately; without: 4 round trips). **§the-named-canonical-pipeline-example-IS-named-money-flow** (mint → purse → payment → deposit). The example is *Agoric-economy-flavored*, signaling the package's deployment context. §the-named-domain-flavored-canonical-example.

- **§the-named-four-numbered-benefits-section** (line 175-220) — "Why Eventual Send?" has four numbered subsections. The numbering makes each benefit name-able by ordinal. §the-named-numbered-list-IS-named-canonical-enumeration; §the-named-Uniform-API + §the-named-Message-Ordering + §the-named-Pipeline-Optimization + §the-named-Future-Proof-Code.

- **§the-named-write-local-code-deploy-distributed-promise** (line 191) — *"Write local code, deploy distributed, no changes needed."* The marketing-tagline-as-engineering-promise; the README states the promise explicitly so it can be reasoned about. §the-named-tagline-IS-named-engineering-promise. First-explicit-observation.

- **§the-named-message-ordering-IS-named-guaranteed-per-target** (line 193-204) — *"Messages to the same target are delivered and processed in send order"* — **per target**, not globally. §the-named-per-target-FIFO; §the-named-order-IS-guaranteed-locally-not-globally; §the-named-FIFO-scope-IS-named-discipline (per-target FIFO, not cross-target). First-explicit-observation.

- **§the-named-cross-package-link-list-with-roles** (line 305-318) — the Integration with Endo Packages section gives each cross-package link a *role label*:

  > - **Foundation**: @endo/pass-style ...
  > - **Validation**: @endo/patterns ...
  > - **Defensive Objects**: @endo/exo ...
  > - **Network Transport**: @endo/captp ...

  **§the-named-role-label-before-package-name discipline** — each cross-reference identifies the *function* the cited package plays in the architecture, not just its name. §the-named-cross-package-citation-IS-named-architectural-role; first-explicit-observation.

- **§the-named-two-Integration-sections-pattern** (Integration with Exo + Integration with Endo Packages) — *Integration* sections at two different scopes: tight integration (with one named package, Exo, via worked example) and loose integration (with four packages, via role labels). **§the-named-tight-vs-loose-integration-distinction**; first-explicit-observation.

- **§the-named-relative-path-link-as-cross-package-citation** (line 224, 307, 309, 311, 313, 316, 331) — `../exo/README.md`, `../pass-style/README.md`, etc. — sibling packages cited via relative paths within the monorepo. §the-named-monorepo-relative-path-citation; §the-named-cross-package-link-graph-via-relative-paths. First-explicit-observation.

- **§the-named-resolveWithPresence-IS-named-third-settle-mode** (line 264-269) — *"Three ways to settle the promise: resolve(value); reject(reason); resolveWithPresence(h);"*. Most JS promises have two settle modes (resolve/reject); HandledPromise has *three*. **§the-named-promise-with-three-settle-modes**; §the-named-presence-IS-named-third-mode. The third mode resolves the promise to a *remote presence* rather than a value. First-explicit-observation.

- **§the-named-handler-intercepts-operations** (line 271-275) — the handler protocol with `get(target, prop)` and `applyMethod(target, verb, args)`. **§the-named-citation-arc-closure-with-cycle-66**. First-explicit-observation as a closure-marker.

- **§the-named-most-users-don't-need-this-disclaimer** appears *twice* in this README (line 136 for E.resolve, line 278 for HandledPromise). **§two-mentions-of-the-named-most-users-don't-need-this** within one README. **§the-named-API-with-honesty-about-low-utility-paths** — the README admits that two of the exported APIs are low-utility for most users, rather than presenting them as equally important. First-explicit-observation.

- **§the-named-Use-in-Tests-section** (line 281-303) — the README dedicates a section to using `E()` in tests with explicit four-benefit enumeration (tests mirror production + async tested + easy to mock + same code local-or-remote). **§the-named-test-discipline-section-in-README**; §four-named-test-benefits. First-explicit-observation.

- **§the-named-vat-as-undefined-but-used-vocabulary** — *vat* appears as core vocabulary without being defined in the README (line 9, 64, 219). The README assumes the reader knows the term. §the-named-domain-vocabulary-as-given; §the-named-jargon-without-definition-discipline; **§the-named-jargon-IS-named-marker-of-intended-audience** — undefined vocabulary signals the README expects the reader to be already-in-the-tradition. First-explicit-observation.

- **§the-named-presence-as-named-remote-proxy** — *remote presence* as a noun (line 64, 65, 268). The terminology comes from the E-language / capability-security tradition. §the-named-presence-IS-named-remote-proxy-in-vat.

- **§the-named-twelve-section-README-shape-IS-named-substrate-package** — twelve sections + heading-less intro. **§six-README-shapes-now** in the pivot:
  - 311 nat: six sections
  - 313 memoize: six sections
  - 315 lp32: six sections
  - 317 hex: four sections (no Overview, no License)
  - 319 stream: seven content sections (no Install, no License — library-author-oriented)
  - **321 eventual-send: twelve sections + heading-less intro (substrate-package-oriented)**

  §the-named-README-shape-IS-named-tailored-to-package-depth-and-audience-extends. Substrate packages get *more* sections, not fewer: because they sit at a foundation, they must introduce vocabulary, justify benefits, show pipelining canonical examples, ground in academic genealogy, and cross-link to multiple sibling packages.

- **§the-named-ECMAScript-proposal-citation-with-link** (line 322-324) — *"This package implements the ECMAScript eventual-send proposal"* with linked URL. **§three-cycles-with-named-TC39-or-ECMAScript-proposal-citation** (314 source URL + 317 README text + 321 README link); §three-citation-shapes (source URL inside file + README plain text + README hyperlink). First-explicit-observation as a triple-shape pattern.

## Patterns the cycle extends

- **§twelve-cycles-with-named-pivot-domain-stay** (310 + 311 + 312 + 313 + 314 + 315 + 316 + 317 + 318 + 319 + 320 + 321)
- **§six-named-packages-in-the-pivot-cluster** (nat + memoize + hex + lp32 + stream + eventual-send — sixth package adds)
- **§six-README-shapes-now** (six-section × 3 + four-section × 1 + seven-section content-first × 1 + twelve-section substrate × 1)
- **§ten-cycles-with-named-Hardened-JS-discipline** (310 + 312 + 313 + 315 + 316 + 317 + 318 + 319 + 320 + 321; Hardened-JS appears in Shim section's "HardenedJS, HandledPromise and related shims")
- **§three-citation-arc-closures-in-pivot-now** (cycle 319 closes cycle 315 = 4 cycles; cycle 321 closes cycle 146 = 175 cycles; cycle 321 closes cycle 66 = 255 cycles)
- **§two-cycles-with-named-cartesian-product-structural-pattern** (317 pair shapes + 321 target cases)
- **§three-cycles-with-named-TC39-or-ECMAScript-proposal-citation** (314 + 317 + 321; three citation shapes)

## Tier-1 borrowing (twenty-plus first-explicit-observations)

All §-tags marked first-explicit-observation above. The strongest portable observations: the four-target cartesian product framing (locality × resolution); the Mark Miller thesis citation as architectural genealogy; the eval-twins terminology with explicit *"what we call"* meta-discourse; the role-label-before-package-name discipline for cross-package citations; the API-with-honesty-about-low-utility-paths (twice-named "most users don't need this"); the per-target FIFO message ordering.

## Tier-2 borrowing (multi-cycle patterns extended)

- §twelve-cycles-with-named-pivot-domain-stay (310-321)
- §six-named-packages-in-the-pivot-cluster
- §six-README-shapes-now
- §ten-cycles-with-named-Hardened-JS-discipline
- §three-citation-arc-closures-in-pivot-now
- §two-cycles-with-named-cartesian-product-structural-pattern (317 + 321)
- §three-cycles-with-named-TC39-or-ECMAScript-proposal-citation (314 + 317 + 321)

## Tier-3 borrowing (meta-patterns)

- **§the-named-cartesian-product-of-locality-and-resolution** as one instance of a broader **§the-named-cross-product-enumeration-IS-named-falsifiable-claim** — structural enumerations as cross-products of independent binary dimensions are exhaustive *and* falsifiable
- **§the-named-citation-to-original-academic-source** — ground engineering claims in academic genealogy; cite PhD theses by name and link
- **§the-named-acknowledged-in-group-vocabulary** — meta-discourse phrases like *"what we call"* explicitly mark in-group terminology
- **§the-named-instance-coordination-via-shim-discipline** — shims for coordination between instances, not just polyfill of missing features
- **§the-named-role-label-before-package-name discipline** — cross-package citations identify the *function* the cited package plays
- **§the-named-API-with-honesty-about-low-utility-paths** — the README admits that some exports are rarely-used rather than presenting them as equally important
- **§the-named-tagline-IS-named-engineering-promise** — marketing-flavored taglines stated explicitly so they can be reasoned about
- **§the-named-jargon-IS-named-marker-of-intended-audience** — undefined vocabulary signals expected reader-in-the-tradition
- **§the-named-substrate-package-README-IS-named-deeper-not-shallower** — packages at the foundation get more sections, not fewer; the depth signals the package's load-bearing position
- **§the-named-citation-arcs-of-widely-varying-lengths-close-in-the-same-cycle** — cycle 321 closes a 175-cycle arc (cycle 146) and a 255-cycle arc (cycle 66) simultaneously; arc length depends on how foundational the cited material is

## Synthesis-target

Slot machine library **§`@game/messaging/README.md`** — eventual-send-style messaging for game-server-renderer-and-betting-engine communication:

1. **First-sentence one-line frame**: "Eventual send: a uniform async messaging API for local and remote objects."
2. **Bullet list of enabled properties**: uniform communication; promise pipelining; message ordering; future-proof code.
3. **Shim section explaining instance coordination**, not just polyfill — multiple loads of the same library must recognize each other's handled promises.
4. **Name novel terminology with meta-discourse**: "what we call 'eval twins'" — explicit marking of in-group vocabulary.
5. **Four-target cartesian-product enumeration**: local object; local promise; remote presence; remote promise. Make the claim falsifiable by axis.
6. **Promise pipelining as named canonical benefit** with side-by-side with-and-without-pipelining examples (multi-step bet placement is a natural game-context analog of mint→purse→payment→deposit).
7. **Numbered benefits section**: 1. Uniform API; 2. Message Ordering; 3. Pipeline Optimization; 4. Future-Proof Code.
8. **Per-target FIFO message ordering** stated explicitly; FIFO scope named.
9. **Role-label-before-package-name** for cross-package citations: **Foundation**: @game/pass-style; **Validation**: @game/patterns; **Defensive Objects**: @game/exo; **Network Transport**: @game/captp.
10. **API-with-honesty-about-low-utility-paths**: two-times "most users don't need this" for the rare-use APIs.
11. **Use in Tests section** with four benefits enumeration.
12. **Background section** citing the TC39 proposal as conceptual genealogy.
13. **See Also section** citing the original academic source (Mark Miller's thesis or analogous foundational paper for whatever the package implements).
14. **Twelve-section substrate-package README shape** for foundational packages; shorter shapes for utility packages.
15. **Tagline-IS-engineering-promise**: state any "write X, deploy Y" promise *explicitly* in user-facing prose so it can be reasoned about.
