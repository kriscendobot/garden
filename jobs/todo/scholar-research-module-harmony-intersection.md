# Scholar: research the module-harmony proposals for Compartments intersection semantics

Ingest into `journal/library/` (per `journal/library/conventions.md`, `skills/context-library`) a
research reference that maps the **module-harmony** proposal landscape the fresh Compartments proposal
must intersect. This feeds the design tenet "intersection semantics across all related proposals,
coherent under module harmony" (project `journal/projects/proposal-compartments/README.md`).

Cover, from primary sources (the tc39 proposal repos, their explainers and spec text, meeting notes):
- **ESM source phase imports** and **source phase imports** (`import source`) — the `ModuleSource`
  surface, `AbstractModuleSource`, `import.source`, the source-phase of the import evaluation pipeline.
- **import defer** (`import defer` / deferred module evaluation).
- **Module Harmony** umbrella: module expressions, module declarations, deferred re-exports, dynamic
  `import()` phases, `ModuleSource`/compile-to-source, virtualization hooks — and any others you find.
- How each proposal's surface relates to a **`ModuleSource` used as an opaque key** for indexing a
  module instance in a Compartment (the design has ABANDONED module descriptors), and to sharing the
  surrounding realm's **global object**.

Output: a source-index + section files per proposal, plus at least one **concept** page —
`module-harmony-intersection-surface` — that states, per proposal, what a minimal Compartments spec
must adopt / defer-to / stay compatible-with to be coherent under module harmony (the intersection).
Note contradictions and open questions explicitly. Ground on the specifications as written; where XS or
SES already implement a phase, note it as evidence, not as the spec. Keep provenance explicit. If the
material fans out beyond this job's budget, write what is supported, post a follow-on
`scholar-research-module-harmony-intersection`, and complete. Route structural lessons via
`skills/self-improvement`.
