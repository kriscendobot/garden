# Compartments test262 reconciliation

Status: the operation surface is now specified, and the fresh-suite targets
below are staged as executable families. When first written (2026-07-21) this was
an inventory only, because the specification named required outcomes without
defining the observable operations. That gap is closed: spec `d23d7de` ("specify
minimum Compartment operation surface") defines `compartment.exports(source)` and
`compartment.import(source)` over an opaque source-phase key, so the six targets
in "Fresh-suite targets" are now authored as ten staged families on
`kriscendobot/test262` branch `proposal-compartments` (`test/staging/Compartments/`,
tip `63b7e7c`). See "Staging update (2026-07-27)" below. The inventory and
disposition of the legacy fixtures (following sections) stand as the 2026-07-21
provenance record.

## Evidence and provenance

The inventory was taken on 2026-07-21 from these immutable source commits:

| Source | Repository and commit | Fixture root | Count |
| --- | --- | --- | ---: |
| XS reference | `Moddable-OpenSource/moddable` `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` | `tests/xs/built-ins/Compartment/` | 56 |
| hardened262 overlay | `endojs/endo` `014b6a86ce1b5cee64c63b5abdb51aac7610b9f0` | `packages/test262-runner/test262/test/built-ins/Compartment/` | 42 |
| endor validation | `endojs/endo-but-for-bots` `970253b9cd8a36e28321cf64af8b607c7f6af38b` | `packages/test262-runner/test262/test/built-ins/Compartment/` | 42 |
| endor engine corpus | `endojs/endo-but-for-bots` `970253b9cd8a36e28321cf64af8b607c7f6af38b` | `rust/engine/endor-262/cases/built-ins/stage4-compartment/` | 29 |

The hardened262 overlay is identified by its package metadata, which describes
`@endo/test262-runner` as the "Hardened JavaScript Test262 Runner". Its 42
fixture blobs are byte-identical to endor's 42 checked-in test262 fixtures at
the commits above. XS has the same 42 paths plus fourteen additional paths. Its
common-path files are adapted sources rather than byte-identical copies:
hardened262 adds `features: [Compartment]` frontmatter; its only material parser
shape difference is that `ModuleSource/bindings/test.js` omits the XS side-effect
import and matching `importFrom` binding record. The two `Symbol.toStringTag`
files use equivalent assertion helpers. These variations are all discarded with
the legacy reflection surface.

The 29 endor engine-corpus files use the `stage4-compartment` directory name but
are arithmetic, built-in, and string-expression differential tests. None creates
a `Compartment` or `ModuleSource`; they are not proposal fixtures and are not
copied.

Every path in the following common inventory has the two paths and commits in
the table above as provenance. The XS path is the listed path under its fixture
root. The hardened262 and endor paths are the same listed path under their
fixture roots.

```text
ModuleSource/bindings/name.js
ModuleSource/bindings/test.js
ModuleSource/needsImport/name.js
ModuleSource/needsImport/test.js
ModuleSource/needsImportMeta/name.js
ModuleSource/needsImportMeta/test.js
VirtualModuleSource/bindings/environment.js
VirtualModuleSource/bindings/test.js
VirtualModuleSource/needsImport/test.js
VirtualModuleSource/needsImportMeta/test.js
constructor/globalLexicals-properties.js
constructor/globalLexicals-types.js
constructor/globals-properties.js
constructor/globals-types.js
constructor/hooks-types.js
constructor/modules-properties.js
constructor/modules-types.js
constructor/options-type.js
constructor/resolveHook.js
descriptors/namespace/object.js
descriptors/source/parent.js
descriptors/source/specifier.js
prototype/Symbol.toStringTag-lockdown.js
prototype/Symbol.toStringTag.js
prototype/evaluate/environments.js
prototype/globalThis/defaults.js
prototype/import/loadHook-separate-errors.js
prototype/import/loadHook-separate-namespaces.js
prototype/import/loadHook-shared-errors.js
prototype/import/loadHook-shared-namespaces.js
prototype/import/modules-separate-errors.js
prototype/import/modules-separate-namespaces.js
prototype/import/modules-shared-errors.js
prototype/import/modules-shared-namespaces.js
prototype/importNow/loadNowHook-separate-errors.js
prototype/importNow/loadNowHook-separate-namespaces.js
prototype/importNow/loadNowHook-shared-errors.js
prototype/importNow/loadNowHook-shared-namespaces.js
prototype/importNow/modules-separate-errors.js
prototype/importNow/modules-separate-namespaces.js
prototype/importNow/modules-shared-errors.js
prototype/importNow/modules-shared-namespaces.js
```

The following fourteen paths exist only in XS, at the XS commit and root above.
They are the complete XS-minus-hardened262/endor difference, so the list also
records per-fixture provenance for every non-overlap.

```text
prototype/import/importHook-separate-errors.js
prototype/import/importHook-separate-namespaces.js
prototype/import/importHook-shared-errors.js
prototype/import/importHook-shared-namespaces.js
prototype/import/importHook-source-parent.js
prototype/import/importHook-synchronous.js
prototype/import/loadHook-source-parent.js
prototype/import/loadHook-synchronous.js
prototype/importNow/importNowHook-separate-errors.js
prototype/importNow/importNowHook-separate-namespaces.js
prototype/importNow/importNowHook-shared-errors.js
prototype/importNow/importNowHook-shared-namespaces.js
prototype/importNow/importNowHook-source-parent.js
prototype/importNow/loadNowHook-source-parent.js
```

The following 29 files exist only in the endor engine-corpus root in the table
above. They are listed individually for provenance, despite not being
Compartments fixtures.

```text
001.js  002.js  003.js  004.js  005.js  006.js  007.js  008.js  009.js  010.js
011.js  012.js  013.js  014.js  015.js  016.js  017.js  018.js  019.js  020.js
021.js  022.js  023.js  024.js  025.js  026.js  027.js  028.js  029.js
```

The hardened overlay also has `packages/ses/test262/compartment-shim.js` at its
recorded commit. It is runner support, not a Compartment proposal fixture. It
imports SES before evaluating a test in `new Compartment()`, so it is not copied
into the proposal suite.

## Reconciliation

The charter is controlling: `ModuleSource` is an opaque per-Compartment instance
key, module descriptors are abandoned, root-realm reuse is required, lockdown is
not a prerequisite, and top-level await plus cross-Compartment cycles are in
scope. XS is the behavioral guide only where it does not conflict with those
requirements.

| Source divergence or family | Disposition | Reason |
| --- | --- | --- |
| `ModuleSource/bindings/*`, `needsImport*`, and all `VirtualModuleSource/*` | Drop | These assert a public `new ModuleSource(sourceText)` parser and reflective `bindings`, `needsImport`, or import-meta properties. The fresh spec instead obtains an opaque source key through module harmony. It does not yet specify any of those reflective properties. |
| `constructor/globalLexicals-*`, `globals-*`, `hooks-types`, `modules-*`, `options-type`, and `resolveHook` | Drop | They test the SES option bag, module table, and resolver-hook protocol. That is the descriptor/loading design the charter abandons. |
| `descriptors/*` | Drop | These are direct module-descriptor tests. |
| `prototype/evaluate/environments` | Drop | It tests SES source-text evaluation rather than module-harmony source keys and module linking. |
| `prototype/globalThis/defaults` | Drop | It expects a new global object. The charter requires a first-class path that reuses the surrounding realm's global object. |
| `prototype/import/*` and `prototype/importNow/*` | Drop | All versions use string specifiers plus `modules`, `loadHook`, `importHook`, or `importNowHook` descriptors. The XS-only fourteen files extend this same abandoned protocol. |
| `prototype/Symbol.toStringTag*` | Do not stage yet | This is not a legacy descriptor assertion, but the fresh spec has not fixed the exposed object shape or its properties. It can be reconsidered after the constructor surface is written. |
| endor `stage4-compartment/001.js` through `029.js` | Drop | These do not exercise Compartments or ModuleSource. Their directory name is corpus bookkeeping, not evidence of proposal behavior. |

The source disagreement is consequently real but not a behavior to preserve:
XS has fourteen extra synchronous and `importHook` variants, while the hardened
overlay and endor vendored suite retain the 42-file subset. The new specification
should not choose either hook family. It should replace both with the
module-harmony operation that turns a source-phase key into a
compartment-local instance. The XS/hardened `bindings` grammar difference is
also dropped with source reflection. No unresolved behavioral disagreement
remains among the legacy fixtures because every disputed behavior belongs to a
discarded surface.

## Fresh-suite targets after the operation surface is specified

These are the first test families to stage. They are derived from the charter,
not copied from the legacy fixtures:

1. The same opaque source key produces one instance within one Compartment.
2. The same opaque source key produces distinct instances in two Compartments.
3. A surrounding-realm global is observably reused for a root-realm graph.
4. Cross-Compartment links preserve namespace identity and support a cycle.
5. Top-level-await completion and rejection propagate through a cross-Compartment link.
6. A no-lockdown run has the same required module-linking semantics.

## Open questions for the daily press or maintainer

Questions 1 through 3 are answered by spec `d23d7de`. Questions 4 and 5 remain
open.

1. Answered. A Compartment acquires a source-phase `ModuleSource` and operates
   on it through two methods keyed on the opaque source object:
   `compartment.import(source)` (asynchronous, links and evaluates) and
   `compartment.exports(source)` (the deferred exports namespace, usable before
   linking). The source object is what `import source` and `import.source()`
   produce. No `import`-method-versus-host-operation ambiguity remains.
2. Answered. `new Compartment()` records the current Realm and its global object,
   and the shared surrounding-realm global is the default (not an opt-in option).
   A fresh-global mode is not part of the minimum surface.
3. Answered. The pre-link namespace operation is `compartment.exports(source)`,
   which yields a deferred exports namespace keyed by Compartment and source key
   before source construction. The charter's trade-off with SES
   `compartment.module(specifier)` is stated in the spec and exercised by
   `cross-compartment/deferred-exports-identity.js`.
4. Open. Synchronous module evaluation is not in the minimum surface:
   `Compartment.prototype.import` is deliberately asynchronous and no synchronous
   entry point exists. The Node.js checklist asks for both TLA and non-TLA paths,
   so this is an outstanding maintainer decision (README shortfall, "Both TLA and
   non-TLA evaluation paths").
5. Open. Staging frontmatter uses the provisional `Compartment` feature name.
   The source-phase and import-defer feature names depend on the test262 feature
   registry, which has not settled them.

## Staging result (legacy fixtures)

No legacy fixture was copied to `kriscendobot/test262`. All 127 source records
either encode the abandoned descriptor/hook design, contradict root-global reuse,
are unrelated endor corpus cases, or depend on an operation the fresh
specification had not yet defined at inventory time. This is intentional
de-legacification, not a claim that the 56 XS, 42 overlay, 42 endor-vendored, or
29 endor-corpus records pass the new design.

## Staging update (2026-07-27)

The legacy fixtures were not staged. The fresh-suite targets were, authored from
the charter after spec `d23d7de` defined the operation surface. The staging tree
`test/staging/Compartments/` on branch `proposal-compartments` (tip `63b7e7c`)
holds ten executable families. Each of the six fresh-suite targets maps to a
staged family:

| Target | Staged family |
| --- | --- |
| 1. Same source key, one instance per Compartment | `instance-memoization/same-compartment.js` |
| 2. Same source key, distinct instances across Compartments | `instance-memoization/separate-compartments.js` |
| 3. Surrounding-realm global reused for a root-realm graph | `constructor/shared-realm-global.js` |
| 4. Cross-Compartment link namespace identity and cycle | `cross-compartment/deferred-exports-identity.js`, `cross-compartment/cyclic-linking.js` |
| 5. TLA completion and rejection across a link | `tla/dependency-and-error-propagation.js` |
| 6. No-lockdown module-linking semantics | folded into `constructor/shared-realm-global.js` (the shared-global run performs no lockdown) |

Four families beyond the six exercise the source-key brand and identity
(`source-key/brand-and-identity.js`), asynchronous import namespaces and error
separation (`import/async-namespace-and-errors.js`), and the module-phase
intersection (`intersection/source-phase-static-and-expression.js` and
`intersection/import-defer-and-tla.js`).

No native engine (v8, JSC, XS, endor) runs the suite yet. All four fail at parse
on the opening source-phase import, which is unimplemented in each reachable
engine build. This is intersection-by-design: the proposal layers on source-phase
imports rather than restating them. The strongest available oracle is the v8
semantic harness (draft PR `kriscendobot/proposal-compartments#2`), which
implements the spec's normative operations over Node's `vm.SourceTextModule`.
Re-run 2026-07-27 against staging `63b7e7c`
(`node run.mjs <staging> <harness>`): **9 passed, 0 failed, 1 blocked** of the ten
families, exit 0. The one blocked family (`intersection/import-defer-and-tla.js`)
needs native `import defer` with synchronous deferred evaluation, which no
reachable engine or the vm-based harness provides.

Growing the suite further is bounded by the same source-phase prerequisite: new
families that open with `import source` cannot be validated on any native engine
until source-phase imports ship there. The semantic harness remains the practical
gate for new families until then.
