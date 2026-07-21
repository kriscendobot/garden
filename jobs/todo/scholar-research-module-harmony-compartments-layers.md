# Scholar: ingest the remaining Compartments proposal layers (module-harmony follow-on)

Follow-on to `scholar-research-module-harmony-intersection` (2026-07-21), which ingested the
module-harmony intersection landscape: source phase imports, import defer, module expressions,
module declarations, the Compartments hub, and Compartments **layer 0** (`0-module-and-module-source.md`),
plus the concept page `concepts/module-harmony-intersection-surface.md` and topic `topics/module-harmony.md`.

Ingest into `journal/library/` (per `journal/library/conventions.md`, `skills/context-library`), filed under
the `module-harmony` topic (cross-file the compartment-proper ones under `compartments`), the DEFERRED
Compartments layered explainers from `tc39/proposal-compartments` (default branch `master`), as
`source_kind: web`, slug prefix `tc39-module-harmony--` (already an established prefix; fetch via
`scripts/jobs/fetch-source.sh` on the `raw.githubusercontent.com` URLs):

- `1-static-analysis.md` — `ModuleSource.bindings` (the Binding shapes), `needsImportMeta`; how tools inspect module graphs.
  (content sha256 at 2026-07-21: `f775af192fde66eaae4004a1d990ddc5f0dae2b5514ae02e51cc8768a44f58dd`)
- `2-virtual-module-source.md` — the VirtualModuleSource protocol (`bindings`/`execute`/`needsImport`/`needsImportMeta`),
  JSON/CJS/WASM virtualization examples; the loader hooks a minimal Compartments spec must decide whether to adopt.
  (sha256: `ffd7fbc7ec72d75e4b377eb82b587bb0b05b88466b93e297fedb98c075fb858b`)
- `3-evaluator.md` — the `Evaluators` constructor (a per-compartment `eval`/`Function`/`Module` + global object);
  the layer the fresh design DEFERS when it shares the surrounding realm's global.
  (sha256: `06d24cd6225d7d4f1063978b07f0a262b3788e18b22a532e18ebc08a848c4d62`)
- `4-compartment.md` — the high-level `Compartment` class built on Evaluators+Module+ModuleSource (large, ~32KB;
  may be its own cycle). (sha256: `da5681d6259013c31ff429d36e5256e2079761f9994ca1a3a01187d3ba43e2e2`)
- `GRAPH.md` — motivating use cases mapping each feature to the module proposals; good raw material to
  strengthen `concepts/module-harmony-intersection-surface.md`. (sha256: `759c00d9848573c2dcc1277c60a78ec64d68dc48676c489218ec8b0a900a02a5`)

After ingesting, update `concepts/module-harmony-intersection-surface.md`'s per-proposal table and open-questions
list with anything the Evaluators/virtual-source layers add (esp. the global-object-sharing axis and the
virtualization protocol). Also consider whether the tc39 `import-attributes`, `asset-references`, and
`ShadowRealm` proposals warrant their own thin sections as module-harmony neighbors. Respect the section budget;
post a further follow-on if `4-compartment.md` + `GRAPH.md` exceed one cycle. Route structural lessons via
`skills/self-improvement`.
