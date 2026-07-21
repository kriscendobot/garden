# Compartments test262 reconciliation

Status: blocked on the normative operation surface. This is an inventory and
disposition report, not an implementation claim. The fresh specification only
names the required outcomes. It does not yet define the observable constructor,
source-key acquisition, import, linking, or root-global-selection operations
needed to author executable test262 tests.

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

1. What operation exposes a source-phase `ModuleSource` to a Compartment: an
   `import` method, a host operation, or another module-harmony form? Its
   arguments and result determine the test262 layout.
2. What observable operation selects the surrounding realm's global object, and
   is it the default or an explicit constructor option?
3. What is the specified pre-link namespace operation for cross-Compartment
   cycles? The charter permits an equivalent of SES `compartment.module(specifier)`
   but has not selected one.
4. Is synchronous module evaluation part of the ECMAScript surface, host-defined,
   or out of scope? The Node.js checklist asks for both TLA and non-TLA paths,
   while the current scaffold defines only `Compartment.prototype.import`.
5. Which source-phase and import-defer feature names should staging frontmatter
   use until the test262 feature registry settles them?

## Staging result

No legacy fixture was copied to `kriscendobot/test262` because all 127 source
records either encode the abandoned descriptor/hook design, contradict
root-global reuse, are unrelated endor corpus cases, or depend on an operation
the fresh specification has not defined. The test262 staging branch has a
documentation-only checkpoint recording this result. This is intentional
de-legacification, not a claim that the 56 XS, 42 overlay, 42 endor-vendored, or
29 endor-corpus records pass the new design. Executable fixtures remain blocked
on the five questions above.
