---
source_kind: repo-doc
source_repo: endojs/endo
source_path: packages/compartment-mapper/README.md
source_line_range: 1-773
ingested: 2026-06-18
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 371 designs-lane ingest. 773-line README for @endo/
  compartment-mapper, the central architectural workhorse that
  builds compartment maps for Node.js applications and emits
  four deployment-target output forms (live import + archive +
  script + functor). Compartment-mapper was previously in the
  cluster via cycle 235's src/generic-graph.md ingest;
  cycle 371 ingests the README at the design level.
  Nineteenth AUTHORED conformant single-body section doc in
  post-refactor era. Sixty-one consecutive non-garden sources
  after the pivot (310-371). §sixty-one-cycles-with-named-
  pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  caller-supplies-IO-powers-not-package-imports-fs — line 47:
  "The compartment mapper is also not coupled specifically to
  Node.js IO and does not import any powerful modules like
  `fs`. The caller must provide read powers in the first
  argument as either a ReadPowers object or as a standalone
  `read` function." The package whose JOB is enforcing OCAP
  discipline on third-party packages applies the same
  discipline to ITSELF by refusing to import I/O modules.
  §the-named-ocap-discipline-applied-to-the-tool-itself as
  tier-3 meta-pattern. The mapper is given the I/O
  capabilities it needs, not allowed to take them.

  §The-named-ReadPowers-as-typed-capability-bundle — lines
  56-67 define ReadPowers as an object with required `read` +
  `canonical` functions and optional `computeSha512`,
  `fileURLToPath`, `pathToFileURL`, `requireResolve`. The
  optional fields unlock specific compatibility features
  (Sha512 enables archive integrity; fileURLToPath enables
  `__dirname` + `__filename` for CJS modules; requireResolve
  enables `require.resolve()` semantics). §the-named-optional-
  capabilities-unlock-features as tier-3 meta-pattern.

  §The-named-four-output-forms-from-one-mapper — the same
  dependency graph + module sources can be emitted as: (1)
  LIVE import via `importLocation` (load and execute
  immediately); (2) ARCHIVE via `writeArchive` (Zip with
  `compartment-map.json` manifest, hashable, safely
  introspectable without execution); (3) SCRIPT bundle via
  `makeScript` (single string for eval / web script); (4)
  FUNCTOR bundle via `makeFunctor` (string that evaluates to a
  function accepting runtime options for Compartment-confined
  execution). §the-named-deployment-target-as-output-format-
  axis as tier-3 meta-pattern.

  §The-named-archive-is-zip-plus-manifest — line 84: "Archives
  are `zip` files with a `compartment-map.json` manifest file."
  Direct composition with cycle 357's @endo/zip package; the
  archive's wire format IS Zip. The compartment-map.json
  manifest is the design contract; the Zip file is the
  packaging.

  §The-named-realm-freezing-is-caller-responsibility — lines
  42-45: "The compartment mapper does nothing to arrange for
  the realm to be frozen. The application using the
  compartment mapper is responsible for applying the [SES] shim
  (if necessary) and calling `lockdown` to freeze the realm
  (if necessary)." Explicit NON-COUPLING from SES. The mapper
  doesn't impose lockdown; it builds maps that lockdown-using
  callers can use. §the-named-explicit-non-coupling-to-
  initialization as tier-3 meta-pattern.

  §The-named-importLocation-loadLocation-pair — eager vs
  deferred execution from a filesystem location. loadLocation
  returns an Application object with `.import()` method;
  importLocation is the convenience that calls them together.
  §the-named-lazy-loader-eager-runner-pair as tier-3 meta-
  pattern, repeated for importArchive/loadArchive/parseArchive.

  §The-named-useEvaluate-toggle-for-CSP-compatibility — lines
  204-208: bundle modules as INLINED function bodies (default;
  works under `no-unsafe-eval` CSP) vs as STRINGS evaluated
  with sourceURL (better stack traces; requires eval
  permission). The same bundle format with two emission modes
  depending on deployment-target constraint. §the-named-
  emission-mode-toggle-for-environment-constraint as tier-3
  meta-pattern.

  §The-named-format-cjs-toggle-for-host-require — line 197-203:
  by default, bundles can be evaluated in any context; with
  `format: "cjs"`, the bundle assumes a host CommonJS
  `require` function for modules that exit the bundle. §the-
  named-bundle-format-as-host-environment-assumption as
  tier-3 meta-pattern.

  §The-named-lite-modules-do-not-entrain-mapper — lines
  260-266: `@endo/compartment-mapper/script-lite.js` and other
  `-lite.js` modules take a compartment map directly instead
  of an entry-module location. This separates the
  compartment-map BUILDING step from the bundle EMITTING step,
  letting consumers replace the building step. §the-named-
  separation-of-build-and-emit-via-lite-suffix as tier-3
  meta-pattern.

  §The-named-script-bootstraps-into-importArchive — lines
  146-148: "Endo uses this 'bundle' format to bootstrap an
  environment up to the point it can call `importArchive`, so
  bundles are at least suitable for creating a script that
  subsumes `ses`, `@endo/compartment-mapper/import-archive.js`,
  and other parts of Endo." The script format is the SEED;
  importArchive is the FULL ENGINE. §the-named-bootstrap-by-
  script-then-archive-import as tier-3 meta-pattern.

  §The-named-functor-bundle-returns-function-not-namespace —
  the script format's completion value is the module exports
  namespace; the functor format's completion value is a
  function accepting runtime options. Functor adds A LEVEL OF
  INDIRECTION so the caller controls the runtime context (the
  evaluator, the require function, the sourceUrlPrefix). §the-
  named-indirection-via-functor-completion-value as tier-3
  meta-pattern.

  §The-named-namespace-as-import-completion-value — every
  import* function returns `{ namespace: moduleExports }` (or
  the namespace as the completion value). The export namespace
  is the canonical module-import result shape.

  §The-named-globals-and-modules-as-parameters — both
  importLocation and importArchive take `{ globals, modules }`
  as options: globals are properties added to globalThis;
  modules are built-in modules granted to the entry-package
  compartment. §the-named-globals-and-modules-as-parameter-
  pair as tier-3 meta-pattern; the caller supplies both
  parameter classes through the same shape.

  §The-named-no-modification-needed-for-most-packages — line
  11-12: "Since most Node.js packages do not modify objects in
  global scope, many libraries and applications work in
  Compartments without modification." The compartment
  enforcement is largely transparent because the existing
  ecosystem mostly follows the contract that compartments
  enforce. §the-named-existing-discipline-makes-enforcement-
  transparent as tier-3 meta-pattern.

  §The-named-TODO-note-about-lavamoat-style-distribution —
  lines 70-73: "TODO: A future version will allow application
  authors to distribute their choices of globals and built-in
  modules to third-party packages within the application, as
  with [LavaMoat]." Honest acknowledgment of incomplete
  feature; LavaMoat is the prior-art reference. §the-named-
  honest-future-feature-with-prior-art-reference as tier-3
  meta-pattern, sibling to cycle 357's honest-acknowledgment
  shapes.

  §The-named-bundle-format-warning-about-precision — lines
  213-215: "Example is illustrative and neither a compatibility
  guarantee nor even precise." Hedges on bundle format
  details. §the-named-illustrative-not-guarantee-hedge as
  tier-3 meta-pattern.

  Closes nine citation arcs: cycle 370 (1, adjacent forward
  pair daemon utility → compartment-mapper README; the
  staged-composition discipline at cycle 370's small scale
  is at the design level here) + cycle 357 (1, @endo/zip
  archive is the wire format for compartment-mapper archives;
  cycle 357 README's security-conscious modernization now
  serves compartment-mapper's archive distribution) + cycle
  359 (1, eslint-plugin's discipline composes with mapper's
  least-authority-per-package; same discipline at lint-time
  vs runtime) + cycle 339 (52, lockdown coupling explicitly
  not assumed by the mapper; mapper builds maps lockdown-
  using callers can use) + cycle 337 (51, harden defended
  interfaces compose with compartment isolation) + cycle 235
  (137, prior generic-graph.md ingest is the dependency-
  resolution substrate this README's mapper is built atop;
  long-deferred arc closure) + cycle 322 (45, @endo/errors
  not directly used in the README's examples but available
  for the mapper's internal error handling) + cycle 321 (8,
  @endo/eventual-send; promise-based async I/O is the shape
  ReadPowers exposes) + cycle 326 (44, pure-naming-as-
  discipline sibling). Pushes citation-arc-closures-in-pivot
  to TWO-HUNDRED-SIXTY-NINE (260 + 9 net new).
---

773-line README for @endo/compartment-mapper (central architectural workhorse for module loading + bundling). §the-named-caller-supplies-IO-powers-not-package-imports-fs (single most structurally interesting move — OCAP discipline applied to the tool itself). §the-named-ocap-discipline-applied-to-the-tool-itself. §the-named-ReadPowers-as-typed-capability-bundle (required read + canonical; optional computeSha512 + fileURLToPath + pathToFileURL + requireResolve). §the-named-four-output-forms-from-one-mapper (live + archive + script + functor). §the-named-archive-is-zip-plus-manifest (composes with cycle 357 @endo/zip). §the-named-realm-freezing-is-caller-responsibility. §the-named-importLocation-loadLocation-pair (lazy-loader-eager-runner). §the-named-useEvaluate-toggle-for-CSP-compatibility. §the-named-format-cjs-toggle-for-host-require. §the-named-lite-modules-do-not-entrain-mapper (separation of build and emit). §the-named-script-bootstraps-into-importArchive. §the-named-functor-bundle-returns-function-not-namespace. §the-named-no-modification-needed-for-most-packages. §the-named-honest-future-feature-with-prior-art-reference (LavaMoat). Nine citation arcs closed.
