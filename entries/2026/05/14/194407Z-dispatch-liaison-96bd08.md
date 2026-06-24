---
ts: 2026-05-14T19:44:07Z
kind: dispatch
role: liaison
project: endo
to: "*"
---

# Dispatch: designer proposes import-attributes ("import-with-type") for SES + ModuleSource

Dispatch root: `dispatches/designer--96bd08/`. Project worktree on `endojs/endo@master` (detached). Output: one design markdown file under `<project>/designs/`; no commits.

Priority: **medium**.

## The directive

Design a solution for the JavaScript **import attributes** feature (`import-with-type` / `with` clause on import statements) in SES and `@endo/module-source`. The design should be implementable on `actual/master` (upstream endo's master branch). The maintainer's framing:

- **Import attributes are a per-import options bag.** A statement like `import data from './data.json' with { type: 'json' };` carries a `with { ... }` clause whose value is a normalized options bag. The design must propagate that bag all the way through the module-resolution machinery into the SES `importHook`.
- **Normalized.** Per the spec, the attributes must be normalized (sorted by key, with consistent value coercion) before any consumer sees them. The design must name where normalization happens (parser? linker? hook adapter?) and ensure the normalized form is canonical.
- **Through to the SES importHook.** Today `importHook(specifier)` resolves a module by specifier alone. The augmented signature is `importHook(specifier, attributes)` (or an equivalent shape); the design must specify the new signature, backward compatibility for hooks that take a single argument, and the migration path for existing hooks.
- **Import attributes participate in the module memo key.** SES's module memoization currently keys on `(referrer, specifier)`. The design must extend the key to include the normalized attributes; `import x from 'y' with { type: 'json' }` and `import x from 'y' with { type: 'css' }` must resolve to two distinct module instances. The memo key extension must be documented precisely.
- **The importHook can multiplex on the source type.** With the attributes flowing through, the hook can return a `ModuleSource` of a different kind based on `attributes.type`: `'json'` returns a JSON-shaped source whose evaluation produces a parsed JSON value; `'css'` returns a CSS-shaped source (CSSStyleSheet, or a deferred-import equivalent under SES); `'wasm'` returns a Wasm-shaped source. The design proposes the source-type variants the importHook can return and the corresponding ModuleSource sub-shapes.

## Per-action authorization

The designer reads `endojs/endo` (read-only), reads from the bare clones (`worktrees/endojs-endo.git`) for upstream files, may read external references (TC39 import-attributes proposal, test262 fixtures) via `WebFetch`. Writes **one** markdown file in `<project>/designs/`. **No commits, no branches, no PRs.**

## Task

1. **Orient.** Read `roles/COMMON.md`, `roles/designer/AGENT.md`. Read `<project>/designs/CLAUDE.md` for project conventions. Skim 2-3 existing `<project>/designs/*.md` files.

2. **Read the relevant code.** Locate the current `importHook` contract (likely in `<project>/packages/ses/src/module-load.js` or `module-link.js`), the module memo key construction, and the ModuleSource shape. Note the synchronous-vs-async boundary if it interacts with the design (it might, for JSON/CSS-modules whose parsing is sync but resource-fetching is async).

3. **Read the TC39 proposal.** WebFetch [tc39/proposal-import-attributes](https://github.com/tc39/proposal-import-attributes) — the spec text and the rationale. Note which attributes are reserved by the spec (`type` is the canonical one; others are host-defined).

4. **Read test262 fixtures.** WebFetch [test262 import-attributes coverage](https://github.com/tc39/test262/tree/main/test/language/module-code/import-attributes) or the comparable directory. These exercise the parser-level and runtime-level edge cases (attributes on dynamic-import, duplicate keys, type mismatches).

5. **Draft `designs/ses-import-attributes.md`.** Sections (adapt to local convention):
   - Status table (Draft, priority: medium).
   - Problem statement.
   - Scope and non-goals (initially: `type` only; other host-defined attributes deferred; JSON modules in scope, CSS / Wasm deferred or explicitly opt-in).
   - **Normalized attribute representation.** Where normalization happens (parser? a small util in `@endo/module-source`?), the canonical sort order, the value-coercion rules. Document the wire shape.
   - **Memo key extension.** The new shape (likely `(referrer, specifier, normalized-attributes-string)`); a worked example showing two imports of the same specifier with different attributes producing two ModuleSource instances; the implications for parent-module caches.
   - **importHook signature.** The new shape (`importHook(specifier, attributes)` or similar). Backward compatibility for hooks that accept one argument (detect arity? wrap with an adapter? require the new signature?). The migration path for existing hooks in the wild.
   - **Source-type multiplex.** The set of source types the design accommodates in v1 (`'json'`; defer `'css'`, `'wasm'` to follow-ups with a stub mention). Per source-type: the ModuleSource variant's shape, its evaluator's contract, and any SES-side intrinsics it grants.
   - **JSON modules in detail.** The dominant first source type. Show the round trip: import statement → parser → importHook(specifier, {type:'json'}) → ModuleSource-json → evaluator → bound exported `default` value.
   - **Backward compatibility for serialized bundles.** A bundle captured today does not carry attributes; the deserializer must default attributes to `{}` (or whatever the spec says is the empty case) and the memo key must collapse to the legacy key shape when the attributes are empty.
   - **Alternatives considered.** One-liner per: making attributes a side-channel parameter on the call site (rejected, breaks the spec); making the importHook return a discriminated union always (rejected, breaks single-arg hooks); a separate JSON-import hook (rejected, doesn't compose with future source types).
   - **Open questions.** Surface them rather than picking.

6. **Diagrams.** One mermaid sequence diagram showing the import-statement → parser → linker → importHook → ModuleSource-{json,other} → evaluator flow with the attributes bag annotated at each step.

7. **Length.** Aim 2-4 screens.

## Out of scope

- No code; design only.
- No commits, branches, or PRs.
- No design for source types beyond `'json'` (the others get a sentence each as "in-scope for a follow-up").
- No host-defined-attribute design (only the spec's `type` is in scope; other attributes are host-defined and out of scope for v1).

## Report

≤ 500 words: path to the design file (`<dispatch-root>/project/designs/ses-import-attributes.md`), the design's one-paragraph problem-statement opening quoted verbatim, the source-type multiplex table (a few rows), the open-questions list, one-line `Self-improvement: ...`.
