---
title: "@endo/ses/docs/guide.md — HardenedJS programming guide (renamed from SES); the three parts of HardenedJS (Lockdown + Harden + Compartment); Lockdown-IS-two-phases-with-vetted-shims-between (Repair Intrinsics + Harden Intrinsics); the Promise-queue vs I/O-queue two-queue-shape; the JavaScript historical narrative; OCap three-requirements"
section-slug: endo--pkg-ses-docs-guide--HardenedJS-renamed-from-SES-and-three-parts-and-Lockdown-two-phases-with-vetted-shims-between-and-Promise-queue-vs-IO-queue
source-slug: endo--pkg-ses-docs-guide
url: https://github.com/endojs/endo/blob/master/packages/ses/docs/guide.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/ses/docs/guide.md
total-lines: 652
ingest-cycle: 293
ingest-date: 2026-06-11
lane: designs
scope: full
---

# `@endo/ses/docs/guide.md` (full guide)

A 652-line comprehensive programming guide for HardenedJS (formerly SES) and Endo. Covers what HardenedJS is + what Lockdown does + what's removed + what's added + Realms + Compartments + the historical narrative + concrete code examples. Authored by the Endo project (collective) for new readers; complementary to cycle 291's `draft-standalone-spec.md` (which is the spec).

## Key moves

- **§the-`group: Documents` + `category: Guides`-TypeDoc-style-frontmatter** (first-explicit-observation): the doc opens with YAML frontmatter `group: Documents` + `category: Guides` + `children: []`. **§the-frontmatter-IS-the-documentation-site-grouping-vocabulary** — used by TypeDoc to organize the docs site navigation. The frontmatter IS not visible in the rendered Markdown; it's a build-system instruction.

§the-`children: []`-named-empty-leaf-marker: marks this doc as a leaf in the doc tree (no child docs nested below it).

- **§HardenedJS-as-named-rebranding-of-SES** (first-explicit-observation):

> "SES is an old umbrella term for the HardenedJS effort, and while we refer to these specific features as HardenedJS, the SES name lingers in a few places."

**§the-named-rebranding-with-named-lingering-instances**: the doc *explicitly acknowledges* that the name change is incomplete. The reader IS warned that they'll encounter both names; the doc IS honest about its naming evolution. **§three-cycles-with-named-naming-evolution** (cycle 277's outliner-cluster four-naming-conventions + cycle 291's "Draft Spec" + 293's HardenedJS/SES); §the-name-evolution-IS-part-of-the-pedagogy.

- **§the-three-parts-of-HardenedJS** (first-explicit-observation):

```
- Lockdown is a function that irreversibly repairs and hardens an existing mutable JavaScript environment.
- Harden is a function that makes interfaces tamper-proof, so objects can be shared between programs.
- Compartment is a class that constructs isolated environments...
```

**§three-named-primitives-of-HardenedJS**: Lockdown (one-time, irreversible) + Harden (per-object, repeated) + Compartment (constructor, multi-instance). **§the-three-named-distinct-shapes-of-API-units**: one-time-function + per-object-function + class-constructor.

§the-named-irreversibility-of-Lockdown: "irreversibly repairs and hardens" — once-only operation per realm.

- **§Lockdown-IS-two-phases-with-vetted-shims-between** (first-explicit-observation): Repair Intrinsics + (vetted shims) + Harden Intrinsics.

```javascript
// equivalent to:
repairIntrinsics(options);
hardenIntrinsics();

// allows vetted shims between the two:
import './ses-repair-intrinsics.js';
import './vetted-shim.js';  // runs in the middle
import './ses-harden-intrinsics.js';
```

**§the-named-two-phase-Lockdown** — extends cycle 291's §two-named-stages-in-SES-startup; cycle 293 names the *two-step decomposition of Lockdown itself* (not the two-stage SES startup story).

§the-named-vetted-shim-as-named-pre-Lockdown-modifier: vetted shims *add* to the intrinsics in the gap between Repair and Harden. Their effects persist into the hardened world. §the-vetted-shim-IS-explicitly-named-as-trust-boundary.

- **§the-OCap-three-requirements as named definition** (first-explicit-observation):

> "Any programming environment fitting the OCaps model satisfies three requirements:
> - Any program can protect its invariants by hiding its own data and capabilities.
> - Power can only be exercised over something by having a reference to the object providing that power...
> - The only way to get a capability is by being given one."

**§the-named-three-requirements-of-OCap**: protect-invariants + capability-IS-reference + only-way-to-get-IS-given. **§the-OCap-IS-three-named-axioms** as the named definition.

§the-named-pedagogy-via-numbered-axioms: the OCap definition IS three numbered claims; each axiom IS a load-bearing constraint on the runtime.

- **§the-historical-narrative-of-JavaScript** (first-explicit-observation):

> "JavaScript was created to let web surfers safely run programs from strangers. Web pages put JavaScript programs in a *sandbox* that restricts their abilities while maximizing utility. This worked well until web applications started inviting multiple strangers into the same sandbox..."

**§the-named-historical-narrative-as-design-rationale**: the doc starts with the *story of why JavaScript needs HardenedJS*, not with technical details. **§the-narrative-IS-the-named-motivation**.

§three-named-historical-moments: (1) JavaScript's-sandbox-for-strangers + (2) the-sandbox-broke-when-multiple-strangers-shared + (3) HardenedJS-restores-finer-grain-isolation-via-OCap.

§the-named-pedagogy-via-history: the doc trusts the reader to *empathize* with the historical problem before introducing the solution.

- **§the-`'ses'`-import-as-shim-pattern** (first-explicit-observation):

```javascript
require("ses");
lockdown();
```

**§the-named-shim-import-pattern**: importing `'ses'` *mutates the environment in place*. The shim's effect IS not local to the importing file; it's *global to the realm*. §the-named-side-effect-import as a discipline.

§the-`ses-lockdown.js`-wrapper-module-pattern: when you want to ensure modules import in a hardened order, wrap the shim+lockdown in a dedicated module that gets imported first. §the-named-ordering-via-module-import-order.

- **§the-UMD-build-IS-the-named-browser-distribution-format** (first-explicit-observation): `<script src="node_modules/ses/dist/ses.umd.min.js">` for browser script-tag use. **§the-UMD-IS-the-named-Universal-Module-Definition-for-non-bundler-targets**.

§three-named-distribution-shapes-for-SES: CommonJS-require + ESM-import + UMD-script-tag. **§three-named-shapes-cover-the-three-major-deployment-modes**.

- **§the-Promise-queue-vs-I/O-queue-two-named-queue-shape** (first-explicit-observation):

> "There are two queues: the *I/O queue* (accessed by `setImmediate`), and the *Promise queue* (accessed by Promise resolution). HardenedJS code can add to the Promise queue, but needs to be given a capability to be able to add to the I/O queue."

**§the-named-two-queues-in-the-event-loop**: Promise queue + I/O queue. **§the-named-priority-ordering**: Promise queue IS higher-priority. **§the-Promise-queue-IS-ambient-but-the-I/O-queue-IS-capability-gated**.

§the-named-capability-gate-on-the-I/O-queue: even though `setImmediate` IS a built-in in Node.js, HardenedJS removes it as ambient authority; the I/O queue can only be accessed via an explicit capability.

§two-named-named-queue-disciplines: timing-precision-via-Promise-resolution (synchronous-microtask) vs scheduling-via-I/O-queue-when-given (macrotask).

- **§the-Math.random + Date.now + new Date + Date() blocking reaffirmed** (extends cycle 291's pattern; now §two-cycles-with-the-three-named-Date-constructor-variants-all-block: 291 + 293).

- **§the-`permits.js`-IS-the-named-source-of-truth-for-globals** (first-explicit-observation):

> "[Agoric's SES source code](https://github.com/endojs/endo/blob/SES-v0.8.0/packages/ses/src/permits.js) defines a subset of the globals defined by the baseline JavaScript language specification."

**§the-named-file-IS-the-named-allow-list-of-permitted-globals**: the runtime behavior IS *driven by a data table* (`permits.js`) rather than by a series of conditional branches. §the-discipline-IS-data-driven-not-code-driven.

§the-named-versioning-of-the-permits-list: linked to `SES-v0.8.0`, anchoring the docs to a specific version of the source.

- **§three-named-Realms-vs-Compartments-distinctions** (first-explicit-observation):

> "Every realm has distinct intrinsics, whereas every compartment shares intrinsics."
> "Each [compartment] has a unique, initially mutable, global object."

**§the-named-distinction**: realm has distinct intrinsics; compartment shares intrinsics + has own global. §the-named-two-axes-of-isolation.

§three-named-claim-pairs about Compartments:
- `c.globalThis === globalThis` → `false` (compartments have own globals).
- `c.globalThis.JSON === JSON` → `true` (compartments share intrinsics).
- `c1.globalThis !== c2.globalThis` + `c1.globalThis.JSON === c2.globalThis.JSON` (two compartments share intrinsics with each other AND the realm).

**§the-named-claims-stated-as-code-equations**: the spec states its invariants as runtime equality assertions. §the-spec-states-its-invariants-as-equations (sibling to cycle 291's `Function !== Function.prototype.constructor`).

- **§the-`start compartment`-IS-the-named-bootstrap-compartment** (first-explicit-observation):

> "We call the one compartment in a realm that was not expressly constructed the start compartment. The start compartment receives some ambient authorities from the host..."

**§the-named-bootstrap-compartment**: the *initial* compartment that IS *not constructed*. **§the-named-asymmetry-of-the-initial-compartment-vs-constructed-compartments**: the start compartment HAS ambient authorities; constructed compartments don't (by default).

§the-named-pattern-of-delegating-from-the-start-compartment to children with reduced authority.

- **§the-SwingSet's-TimerService-as-named-out-of-band-time-access** (first-explicit-observation):

> "Any notion of time must come from exchanging messages with external timer services (the SwingSet environment provides a `TimerService` object to the bootstrap vat, which can share it with other vats)"

**§the-named-out-of-band-source-of-time**: HardenedJS has no `Date.now()`; getting time requires a `TimerService` capability. **§the-named-substitution-for-the-removed-ambient-authority**. §the-named-Agoric-specific-mechanism-mentioned-in-the-general-guide.

§the-pedagogy-bridge-from-the-platform-removal-to-the-named-application-replacement: the doc names what's gone *and* names what to use in its place.

- **§the-`harden(console.log)` as named-example-for-Compartment-construction** (first-explicit-observation):

```javascript
const c = new Compartment({
  print: harden(console.log),
});
```

**§the-named-discipline-of-hardening-the-capability-before-passing-it-in**: the host hardens `console.log` *before* passing it into the compartment. **§the-capability-IS-hardened-at-the-boundary**.

§the-named-capability-injection-via-Compartment-constructor-options-bag.

- **§the-`Compartment.evaluate` IS-named-string-source-evaluation** (first-explicit-observation):

```javascript
c.evaluate(`
  print('Hello! Hello?');
`);
```

**§the-named-string-source-evaluation** in the compartment's global scope.

- **§the-named-isolation-without-modules-vs-with-modules** (first-explicit-observation):

> "A single compartment can run a JavaScript program in the locked-down environment. However, most interesting programs have multiple modules. So, each compartment also has its own module system."

**§the-named-two-named-Compartment-shapes**: single-program-evaluation + multi-module-system. §the-named-progressive-disclosure-of-Compartment-features.

- **§the-named-cross-compartment-module-linking** (first-explicit-observation):

> "Compartments can be linked, so one compartment can export a module that another compartment..."

**§the-named-Compartment-as-named-module-system-boundary**: compartments can *re-export* each other's modules. §the-named-cross-compartment-import.

## §the-naming-evolution-discipline reaffirmed (cycle 293)

The doc tracks naming evolution explicitly:
- "SES" (old) → "HardenedJS" (new); §the-named-rebranding-acknowledgment.
- Project names (some still "SES"; standards proposals "bear the SES name").

**§the-naming-IS-a-named-evolutionary-process**: the doc IS honest about the *in-flight rename*. Compare cycle 277's four-named-naming-conventions (filename conventions evolving) — same kind of naming-meta-awareness, applied to project names.

§three-cycles-with-named-naming-evolution-as-pedagogy (277 filename-conventions + 291 Draft-Spec-tentative + 293 HardenedJS-IS-renamed-from-SES).

## §the-Markdown-link-to-tc39-terminology-glossary (first-explicit-observation)

The doc links to `https://github.com/tc39/how-we-work/blob/main/terminology.md#primordial` for the technical term "primordial". **§the-named-external-glossary-link IS-the-named-pedagogy-discipline**: rather than redefining a term, link to the canonical source.

§the-named-vocabulary-deference: the doc defers to tc39's terminology document for the standard names of JS-spec concepts.

## Patterns from prior cycles, reaffirmed

- **§two-cycles-with-the-three-named-Date-constructor-variants-all-block** (291 + 293).
- **§the-OCap-three-requirements** generalizes Mark Miller's domain (cycle 291 + 293).
- **§the-spec-states-its-invariants-as-equations** (cycle 291 `Function !== Function.prototype.constructor` + cycle 293's three-named-Compartment-equality-claims).
- **§the-named-cross-domain-stage-mapping** (cycle 291) generalizes here as §three-named-distribution-shapes-for-SES (CJS + ESM + UMD) for runtime substrate.

## Borrowing tiers

- **Tier 1 (direct, exact-shape)**: §the-`group: Documents` + `category: Guides`-frontmatter + §the-`children: []`-empty-leaf-marker + §HardenedJS-as-named-rebranding-of-SES + §the-named-rebranding-with-named-lingering-instances + §the-three-parts-of-HardenedJS + §three-named-distinct-shapes-of-API-units + §the-named-irreversibility-of-Lockdown + §Lockdown-IS-two-phases-with-vetted-shims-between + §the-named-vetted-shim-as-named-pre-Lockdown-modifier + §the-OCap-three-requirements + §the-OCap-IS-three-named-axioms + §the-historical-narrative-of-JavaScript + §the-narrative-IS-the-named-motivation + §three-named-historical-moments + §the-named-pedagogy-via-history + §the-`'ses'`-import-as-shim-pattern + §the-named-shim-import-pattern + §the-named-side-effect-import + §the-`ses-lockdown.js`-wrapper-module-pattern + §the-UMD-build-IS-the-named-browser-distribution-format + §three-named-distribution-shapes-for-SES + §the-Promise-queue-vs-I/O-queue-two-named-queue-shape + §the-named-priority-ordering + §the-Promise-queue-IS-ambient-but-the-I/O-queue-IS-capability-gated + §the-named-capability-gate-on-the-I/O-queue + §the-`permits.js`-IS-the-named-source-of-truth-for-globals + §three-named-Realms-vs-Compartments-distinctions + §the-named-claims-stated-as-code-equations + §the-`start compartment`-IS-the-named-bootstrap-compartment + §the-named-asymmetry-of-the-initial-compartment-vs-constructed-compartments + §the-SwingSet's-TimerService-as-named-out-of-band-time-access + §the-named-substitution-for-the-removed-ambient-authority + §the-pedagogy-bridge-from-the-platform-removal-to-the-named-application-replacement + §the-`harden(console.log)` as named-example + §the-capability-IS-hardened-at-the-boundary + §the-named-capability-injection-via-Compartment-constructor-options-bag + §the-`Compartment.evaluate` IS-named-string-source-evaluation + §the-named-two-named-Compartment-shapes + §the-named-Compartment-as-named-module-system-boundary + §the-Markdown-link-to-tc39-terminology-glossary + §the-named-external-glossary-link-IS-the-named-pedagogy-discipline + §the-named-vocabulary-deference — all forty-one first-explicit-observations.
- **Tier 2 (clear analogue, named-shape)**: §the-named-two-axes-of-isolation (realms-have-distinct-intrinsics + compartments-share-intrinsics) + §the-named-progressive-disclosure-of-Compartment-features + §the-discipline-IS-data-driven-not-code-driven (permits.js IS a data table) + §the-spec-states-its-invariants-as-equations (extending cycle 291).
- **Tier 3 (multi-cycle pattern recognition)**: §two-cycles-with-the-three-named-Date-constructor-variants-all-block (291 + 293) + §three-cycles-with-named-naming-evolution-as-pedagogy (277 + 291 + 293) + §the-named-cross-domain-stage-mapping generalized (291 + 293).

## Synthesis target

Slot machine library `@game/replay/docs/guide.md`: TypeDoc-style frontmatter with `group: Documents` + `category: Guides`; named rebranding acknowledgment (e.g., "old name X, now Y"); three named primitives of GameEngine (e.g., InitializeGame + HardenRules + Compartment); GameEngine-OCap-three-requirements; historical narrative of why deterministic replay matters; `require('@game/lockdown'); lockdownGame();` shim pattern; UMD build for browser script-tag; two named queues (Promise + I/O); named source-of-truth file for permitted globals (e.g., `permits.js`); three named distribution shapes (CJS + ESM + UMD); named bootstrap compartment vs constructed compartments; out-of-band time source via `TimerService`-style capability; capability hardened at the boundary before passing into compartment; tc39-style external glossary link for shared terminology.

## Single most structurally interesting move

**§the-historical-narrative-of-JavaScript** combined with **§the-three-named-historical-moments** — the doc starts with a *story* (web pages → multiple strangers → finer-grain OCap), not with technical specs. The historical narrative IS the named motivation: the reader IS asked to *empathize with the problem* before being shown the solution.

This generalizes to any pedagogical guide for a security technology: leading with **why-this-matters-historically** before **what-this-IS-technically** lets the reader hold the technical content with intuition about *why each constraint exists*. The named-three-historical-moments shape (problem-arose → problem-broke → solution-restores) IS a portable pedagogy structure for security-tooling guides.

§the-narrative-IS-the-named-motivation-IS-the-named-pedagogy-bridge.
