Verified: PR #1 is draft and open; inbox is empty. The garden main2 worktree needs no commits — this was a project-front validation whose deliverable lives on the proposal fork.

## Completion report

**Job:** Validate/prototype the fresh Compartments operation surface on JavaScriptCore (one of four parallel validation fronts).

**Harness established (runnable, no source build needed).** Installed a real WebKit JavaScriptCore CLI via `apt-get install libjavascriptcoregtk-bin` → `/usr/bin/jsc` (WebKitGTK **2.52.3**, April 2026). It runs test262 module/async tests via `--module-file` + `--test262-async` and takes VM option flags. Cloned the spec fork (`kriscendobot/proposal-compartments`@`d23d7de`) and a sparse checkout of the staging suite (`kriscendobot/test262`@`proposal-compartments`, `test/staging/Compartments/`).

**Measured baseline (real commands, not inference).**
- Runnable in stock JSC: ES modules, top-level await, dynamic `import()`, import attributes, and **import defer** (behind `--useImportDefer=1`).
- Absent: `Compartment` and `ModuleSource` globals (both `undefined`), and **source phase imports** — `import source x from`/`import.source(...)` are `SyntaxError` with no runtime flag.
- **Ran all 10 staging tests against JSC with the test262 harness. Every one fails identically at parse time on its first `import source` line (exit 3), before any `Compartment` reference.** I did not call this green.

**Substrate assessment.** JSC's internal module loader (exposed via `--exposeInternalModuleLoader=1`) is exactly the ordinary Module Record machinery the proposal reuses: a `registry` Map, `getModuleNamespaceObject`, `moduleDeclarationInstantiation` (Link), `asyncModuleEvaluation` (Evaluate/TLA), cyclic linking. The proposal's memo layer (`[[ModuleInstances]]`, `[[ExportsNamespaces]]`, `RequireCompartmentSourceKey`, deferred namespaces) maps directly onto it, and the shared-realm-global path is JSC's default. But the loader is a debug surface (native `parseModule` aborts on JS-shaped args), so no faithful JS-level prototype can run the suite; the memo layer must be built in C++.

**Blocking prerequisite (exact).** Source phase imports are unimplemented in JSC and the sole gate: they are the only way to produce a `ModuleSource` key, and they are the entry point of all 10 tests. JSC needs (1) parser/bytecode support for `import source`/`import.source`, and (2) a `%ModuleSource%` intrinsic carrying `[[ModuleSourceRecord]]` with per-referrer cache identity.

**Next bounded increment.** Land source phase imports in JSC behind a `--useSourcePhaseImports` flag (mirroring the shipped `--useImportDefer` staging), verified against the upstream `source-phase-imports` staging tests. This is a prerequisite shared with the v8 front and the honest gate before any `Compartment` work.

**Reconciliation.** No semantic disagreement with the charter surfaced; the gap is the missing source-phase entry point, not a behavioral disagreement.

**Deliverable.** Draft PR **kriscendobot/proposal-compartments#1** ("docs: JavaScriptCore validation report") adds `validation/jsc.md` with the full measured findings, evidence, substrate mapping, and reproduction commands. Kept draft per instruction.

**Follow-ups:** (1) the source-phase-imports engine work is shared with the v8 front — worth coordinating so one implementation informs both; (2) once source phase lands under a flag, a follow-on job can add the C++ `Compartment` memo layer and re-run this suite for a real pass/fail.
