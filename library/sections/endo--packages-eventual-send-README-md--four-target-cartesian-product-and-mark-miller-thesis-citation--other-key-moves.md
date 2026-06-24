---
title: Other key moves
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
parent: endo--packages-eventual-send-README-md--four-target-cartesian-product-and-mark-miller-thesis-citation
---

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
