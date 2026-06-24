---
source_kind: design-doc
source_repo: endojs/endo
source_path: packages/module-source/DESIGN.md
source_line_range: 1-207
ingested: 2026-06-18
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 375 designs-lane ingest. 207-line DESIGN document
  for @endo/module-source, the package that transforms ESM
  source into executable functors plus static-analysis
  records. The compartment-mapper's four-output-form
  architecture (cycle 371) is built atop this transformation.
  Twenty-third AUTHORED conformant single-body section doc in
  post-refactor era. Sixty-five consecutive non-garden sources
  after the pivot (310-375). §sixty-five-cycles-with-named-
  pivot-domain-stay.

  Single most structurally interesting move: §the-named-dual-
  output-from-single-transform — the transformation
  SIMULTANEOUSLY produces a metadata RECORD (the static
  analysis: imports + exports + liveExportMap + fixedExportMap
  + exportAlls) AND an executable PROGRAM (the functor
  source). The same analyze() call yields both halves; the
  compartment-mapper consumes both — the record to link,
  the functor to execute. §the-named-static-analysis-and-
  functor-paired-output as tier-3 meta-pattern. The
  separation of concerns from cycle 371 ("lazy-loader-eager-
  runner-pair") composes upward from this transformation
  primitive.

  §The-named-three-phase-module-execution — line 9-11
  describes the workflow: "analyze the module source, link
  with other modules based on the static record's metadata,
  evaluate the functor, call the functor with linkage."
  Three phases (analyze → link → evaluate-and-call) named
  explicitly. §the-named-analyze-link-evaluate-pipeline as
  tier-3 meta-pattern.

  §The-named-live-bindings-via-Proxy-on-scope-chain — lines
  129-131: "we depend on the evaluator to put a Proxy on the
  scope chain to intercept the assignment and effect an
  update to all modules that import the value." JavaScript
  ESM live bindings (where `import x` reflects later changes
  to `x` in the exporting module) are implemented via Proxy-
  based scope-chain interception. §the-named-Proxy-as-live-
  binding-intercept as tier-3 meta-pattern. This is the
  non-trivial mechanism behind a feature ESM users take for
  granted.

  §The-named-invisible-joiner-characters-for-name-collision-
  avoidance — lines 80-81: "The names are additionally
  obscured with invisible joiner characters to avoid
  collisions with sensibly constructed modules." Generated
  internal names (`$h_imports`, `$h_live`, `$h_once`,
  `$h_import_meta` shown in the doc, but production uses
  invisible Unicode joiners) cannot collide with names
  modules might define. §the-named-name-mangling-via-
  unicode-invisible-characters as tier-3 meta-pattern.

  §The-named-line-numbers-preserved-in-transformation —
  line 82: "the transformation preserves line numbers." Stack
  traces stay aligned to original source; source maps come
  for free. §the-named-source-line-preservation-as-debug-
  affordance as tier-3 meta-pattern.

  §The-named-liveExportMap-vs-fixedExportMap — lines 169-177:
  liveExportMap names variables that need to emit updates
  when they change; fixedExportMap names constants emitted
  on initialization. TWO maps capture the JS semantics
  distinction (mutable vs immutable bindings). §the-named-
  two-maps-for-mutable-and-immutable-bindings as tier-3
  meta-pattern.

  §The-named-export-update-as-callback-list — lines 200-201:
  every imported name has an `Array<UpdateFunction>`; when
  the export changes, ALL update functions fire. Reactive
  propagation of export changes — every consumer module's
  binding is updated. §the-named-reactive-propagation-via-
  callback-list as tier-3 meta-pattern.

  §The-named-import-and-export-via-shared-Map-shape — both
  directions use `Map<RelativeModuleSpecifier,
  ModuleUpdaters>` and `Map<ImportName, Array<UpdateFunction>>`;
  the same shape carries information in both directions.
  §the-named-symmetric-Map-shape-for-bidirectional-linkage
  as tier-3 meta-pattern.

  §The-named-SetProxyTrap-for-temporal-dead-zone — lines
  182-185: boolean indicating whether the variable has a
  temporal dead zone (TDZ); the transformation tracks this
  so the module namespace throws ReferenceError appropriately
  before first update. JS spec TDZ semantics preserved
  through the transformation. §the-named-TDZ-preservation-
  in-transform as tier-3 meta-pattern.

  §The-named-TODO-as-explicit-future-removal-candidate —
  lines 152-153: "TODO Consider removing the import
  argument. It does not appear to be used by module
  instances." Honest acknowledgment of dead code in the
  design document; sibling shape to cycle 359's §the-named-
  honest-placeholder-not-hidden-gap and cycle 372's §the-
  named-exported-for-tests-as-honest-acknowledgment. §the-
  named-honest-future-removal-candidate-named-in-design-doc
  as tier-3 meta-pattern.

  §The-named-DESIGN-md-as-design-document-naming-convention
  — the file is literally named `DESIGN.md` (all caps).
  This is the second design-doc filename convention in the
  cluster (after cycle 368's `docs/exo-taxonomy.md` lowercase
  in a docs/ directory). §the-named-DESIGN-md-as-package-
  root-design-document as tier-3 meta-pattern; in this
  package the design lives at the package root rather than
  under docs/. The naming convention is not consistent across
  the cluster.

  Closes seven citation arcs: cycle 374 (1, adjacent forward
  pair cli demo → module-source DESIGN; both are design-
  through-demonstration: cycle 374's demo runs through the
  CLI; cycle 375's DESIGN runs through the module-source
  transform pipeline) + cycle 371 (1, compartment-mapper's
  four-output-form architecture composes atop this
  transformation; the long-deferred design citation of
  cycle 371's caller-supplies-IO-powers reaches its
  transformation primitive here) + cycle 367 (1, exo's
  validated-OCAP composes with module-source's functor
  execution; both are substrate disciplines that compose) +
  cycle 326 (48, pure-naming-as-discipline) + cycle 322 (49,
  @endo/errors; transformation errors decorate location)
  + cycle 339 (54, lockdown freezes the realm before
  module-source functors execute) + cycle 327 (5, @endo/
  patterns; ModuleAnalysis type shape is documented similar
  to patterns' M.interface shape). Pushes citation-arc-
  closures-in-pivot to TWO-HUNDRED-NINETY-SEVEN (290 + 7
  net new).
---

207-line DESIGN.md for @endo/module-source, the package that transforms ESM source into executable functors plus static-analysis records. §the-named-dual-output-from-single-transform (single most structurally interesting move — record + functor from one analyze() call; compartment-mapper consumes both). §the-named-three-phase-module-execution (analyze → link → evaluate-and-call). §the-named-live-bindings-via-Proxy-on-scope-chain (ESM live bindings via Proxy-based scope-chain interception). §the-named-invisible-joiner-characters-for-name-collision-avoidance (Unicode invisible joiners in generated internal names). §the-named-line-numbers-preserved-in-transformation (stack traces aligned). §the-named-liveExportMap-vs-fixedExportMap (two maps for mutable/immutable bindings). §the-named-export-update-as-callback-list (reactive propagation). §the-named-symmetric-Map-shape-for-bidirectional-linkage. §the-named-SetProxyTrap-for-temporal-dead-zone (TDZ preservation). §the-named-TODO-as-explicit-future-removal-candidate (honest acknowledgment shape; sibling to cycle 359 honest-placeholder + cycle 372 exported-for-tests). §the-named-DESIGN-md-as-package-root-design-document. Seven citation arcs closed.
