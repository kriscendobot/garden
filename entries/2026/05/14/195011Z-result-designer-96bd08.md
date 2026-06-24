---
ts: 2026-05-14T19:50:11Z
kind: result
role: designer
project: endo
refs:
  - entries/2026/05/14/194407Z-dispatch-liaison-96bd08.md
---

# Result: designer drafts ses-import-attributes design (96bd08)

Drafted `designs/ses-import-attributes.md` at the project root of the
`endojs/endo@master` worktree (no top-level `designs/` existed; the only
prior design lives under `packages/compartment-mapper/designs/`).
The file is the dispatch's sole deliverable.
No commits, no branches, no PRs (per dispatch).

## Design contents

- Problem statement: SES's `importHook` and `ModuleSource` do not carry
  the `with { ... }` clause through the loader; the memo keys on bare
  specifiers; this design closes that gap so JSON modules can land as
  the first source-type variant.
- Normalized attribute representation: frozen
  `{ [key:string]: string }` with `__proto__: null`, lexicographically
  sorted keys, a frozen `EMPTY_ATTRIBUTES` sentinel for the no-`with`
  case, and `JSON.stringify` over the sorted-key object as the memo-key
  serialization.
  Normalization function lands in `@endo/module-source` as
  `normalizeImportAttributes` and is re-exported from `ses`.
- Memo key extension:
  `<fullSpecifier> + '\0' + <normalized-attributes-json>`, with the
  legacy collapse rule that the empty case keys identically to today.
  Worked example shows `./doc.json` with `type: 'json'` vs
  `type: 'css'` vs no attributes producing three distinct memo entries.
- importHook / importNowHook signature: optional second `attributes`
  argument; arity-based dispatch (`hook.length`) for backward
  compatibility; a *TypeError* on legacy single-arg hooks receiving
  non-empty attributes (safer than silently dropping attributes and
  evaluating JSON as JavaScript).
- Source-type multiplex table:
  v1 ships `'json'` (`JsonModuleSource` with `imports:[],
  exports:['default'], json: <parsed>`); `'css'` and `'wasm'` deferred
  with single-row mentions.
- JSON-modules round trip walked through (parser -> loader -> hook ->
  linker -> evaluator).
- Backward compatibility for serialized bundles: bundle reader injects
  `EMPTY_ATTRIBUTES` when absent; bundle writer records attributes only
  on non-empty `with` clauses to keep byte-identical archives for
  attribute-free graphs.
- Alternatives considered (one liner each): side-channel parameter,
  always-discriminated-union return, parallel `jsonImportHook`, parse
  inside the linker.
- Open questions: input-freeze vs return-frozen-copy normalization
  policy, throw-vs-warn for legacy-hook arity rule, exact JSON-parse
  seat (proposed: hook), dynamic-import attributes propagation and
  whether `resolveHook` gains a second argument, interaction with
  `compartment.moduleMap` keying.
- One mermaid sequence diagram of the JSON-module round trip.

## Mapping to the dispatch's Report shape

Path: `dispatches/designer--96bd08/project/designs/ses-import-attributes.md`.
Problem-statement opening (verbatim, first paragraph):

> JavaScript's [import attributes](https://github.com/tc39/proposal-import-attributes)
> proposal (Stage 4, merged into ECMA-262) extends every static and dynamic
> import with an options bag carried through a `with` clause:

Source-type multiplex table (excerpted; full table in the design):

| `type`   | v1     | ModuleSource variant   | Default export contract     |
|----------|--------|------------------------|-----------------------------|
| (omitted)| yes    | existing JS variants   | as today                    |
| `'json'` | yes    | `JsonModuleSource`     | parsed JSON value           |
| `'css'`  | future | `CssModuleSource` TBD  | `CSSStyleSheet` (TBD)       |
| `'wasm'` | future | `WasmModuleSource` TBD | instance bindings (TBD)     |

Open questions (full list in the design):

- Normalization: freeze input or return frozen copy.
- Legacy-hook arity rule: throw vs warn-and-load-as-JS.
- JSON-parse seat: hook (proposed) vs linker.
- Dynamic-import: attributes flow through `compartment.import`, but does
  `resolveHook` gain a second argument?
- `moduleMap` / `moduleMapHook`: extend key with attributes, or let
  attributes select the variant after `moduleMap` resolves the specifier?

Self-improvement: nothing this time.
