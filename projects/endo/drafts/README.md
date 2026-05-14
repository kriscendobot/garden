---
created: 2026-05-14
author: liaison
---

# Endo design drafts awaiting maintainer triage

Designs authored by garden designer dispatches but not yet committed to `endojs/endo`. Each file is a verbatim copy of the dispatch worktree's `project/designs/<slug>.md`, preserved here so the dispatch root can be torn down without losing the work. The maintainer reviews these in-place; when triaged, the next dispatch (designer revision or builder) reads from here and lands them on a fork branch as part of opening the PR.

## Current drafts

- [exo-import.md](./exo-import.md) — plug-and-play import mechanism using compartment-mapper primitives, Go-style version resolution, snapshot-strict. Authored by designer (dispatch `e3b1aa`, 2026-05-14). Sibling: exo-npm-registry. Open questions surfaced in [`entries/2026/05/14/051353Z-result-designer-e3b1aa.md`](../../../entries/2026/05/14/) and on the bulletin's *Awaits maintainer decision*.
- [exo-npm-registry.md](./exo-npm-registry.md) — daemon-side capability that captures, indexes, and vends readable-trees for `(npm name, version)` couples; the lookup interface that `exo-import` consumes. Authored by designer (dispatch `e3b1aa`, 2026-05-14). Sibling: exo-import.
- [ses-import-attributes.md](./ses-import-attributes.md) — propagate JavaScript's import-attributes (`with { type: 'json' }` clause) through normalization → memo-key extension → SES `importHook` signature → source-type multiplex in ModuleSource. JSON in v1; CSS/Wasm deferred. Authored by designer (dispatch `96bd08`, 2026-05-14, priority: medium).
- [ses-top-level-await.md](./ses-top-level-await.md) — top-level-await in SES and `@endo/module-source`. Leads with a 17-row test suite (12 spec-transliterated from test262 `language/module-code/top-level-await/`, 5 SES-shim-only including bundle-source round-trip and `importNow` rejection). Body covers static analysis (one Babel `AwaitExpression` visitor), module-instance contract additions (`asyncEvaluation`, `topLevelCapability`, `[[CycleRoot]]` via Tarjan low-link), evaluation procedure, `compartment.importNow` synchronous-TypeError guard, bundle-source coupling, and sync-module backward compatibility. Authored by designer (dispatch `759853`, 2026-05-14, priority: extreme low).

## Lifecycle

A draft clears from this directory by one of:

- A builder dispatch lands the design on a fork branch of `endojs/endo` and opens the PR; the file here stays for the historical record (the journal is append-only) but the bulletin row moves to *Pending kriskowal reviews*.
- The maintainer signals a redesign; a fresh designer dispatch authors a new draft (either replacing this one or with a `supersedes:` cross-reference in the frontmatter).
- The maintainer signals the design is abandoned; the file's frontmatter gets a `status: abandoned` field flipped (the file body stays per append-only).
