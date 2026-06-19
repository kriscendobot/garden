---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/patterns/types-index.d.ts
source_line_range: 1-9
ingested: 2026-06-18
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 388 chat-lane ingest paired to cycle 387 designs-
  lane AGENTS.md. 9-line patterns/types-index.d.ts — the
  canonical example of AGENTS.md's types-index convention.
  Thirty-sixth AUTHORED conformant single-body section doc
  in post-refactor era. Seventy-eighth consecutive non-
  garden source after the pivot (310-388). §seventy-eight-
  cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  canonical-and-violating-instances-of-types-index-
  convention — the same monorepo contains BOTH a
  canonical instance and a violating instance of the
  AGENTS.md types-index convention. patterns/types-index.
  d.ts is 9 lines of pure re-exports with a self-
  documenting header pointing to AGENTS.md. exo/types-
  index.d.ts is 176 lines containing 6 `export declare
  function` declarations (overloaded signatures for
  makeExo + defineExoClass + defineExoClassKit) plus
  imports plus extensive JSDoc — which AGENTS.md line 48
  says should live in `.ts` files, not `.d.ts`. The
  convention is documented in cycle 387's AGENTS.md but
  not uniformly applied. §the-named-uniform-convention-
  unevenly-applied as tier-3 meta-pattern.

  §The-named-comment-naming-convention-and-pointing-to-
  source — lines 1-2: "Pure re-export index — type
  definitions belong in .ts files. See AGENTS.md for the
  types-index convention." The file's own header
  DOCUMENTS its purpose AND pulls the reader to AGENTS.md.
  §the-named-self-documenting-header-with-pointer-to-
  authority as tier-3 meta-pattern; the file knows what
  it is AND tells the reader where the rule lives.

  §The-named-export-type-star-from-as-type-only-star-re-
  export — lines 3-4 use `export type * from` (TypeScript
  5.0+ syntax for type-only star re-export). Two source
  files: `src/types.js` (canonical types) and `src/type-
  from-pattern.js` (computed types). §the-named-export-
  type-star-as-bulk-type-re-export as tier-3 meta-
  pattern.

  §The-named-three-file-dance-for-value-namespace-merge —
  lines 6-9 reveal the THREE files involved in re-
  exporting M + matches + mustMatch:
  - src/type-from-pattern.ts: defines the value+namespace
    merge (TypeScript requires both in one module).
  - types-index.d.ts: re-exports the TYPES (line 9
    `export { M, matches, mustMatch }` — but TypeScript-
    only because it's in .d.ts).
  - types-index.js: re-exports the RUNTIME (sibling
    runtime file imports from patternMatchers.js).
  §the-named-three-file-dance-for-typed-runtime-export as
  tier-3 meta-pattern; types and runtime are decoupled
  but coordinated via shared name surface.

  §The-named-AGENTS-md-convention-cited-in-source-comment
  — line 2 explicitly cites AGENTS.md as the authority
  for the convention. The source comment is a forward
  pointer to the conventions document. §the-named-source-
  to-doc-pointer-as-convention-reinforcement as tier-3
  meta-pattern; the rule lives in AGENTS.md, but the
  source code at the rule-application site has a comment
  saying "see AGENTS.md for the rule."

  §The-named-nine-line-as-AGENTS-conformant-shape —
  patterns/types-index.d.ts is 9 lines (header comment +
  two re-export lines + body comment + one named-export
  line). The convention's canonical realization is
  necessarily small. §the-named-canonical-convention-
  realization-is-small as tier-3 meta-pattern.

  §The-named-exo-types-index-d-ts-violates-AGENTS-md-
  convention — the violating instance has 176 lines with
  6 `export declare function` declarations. AGENTS.md
  line 48 specifies `declare function` overrides belong in
  `.ts` files for tsc checking; in `.d.ts` they silently
  pass. The exo package puts them in the .d.ts file.
  Reasons could include: (1) historical predates the
  AGENTS convention; (2) the package author chose
  silent-pass over checking trade-off deliberately; (3)
  oversight pending migration. The librarian cannot tell
  which from the source alone. §the-named-convention-
  violation-may-be-historical-or-deliberate-or-pending
  as tier-3 meta-pattern.

  §The-named-AGENTS-md-and-source-converge-via-pointer —
  the patterns/types-index.d.ts comment refers to
  AGENTS.md; AGENTS.md describes the types-index
  convention; the source applies it. The two artifacts
  reinforce each other via the explicit pointer. §the-
  named-bidirectional-doc-source-coupling as tier-3
  meta-pattern; documents reference source files (cycle
  387 AGENTS.md cites examples) and source files
  reference documents (cycle 388 comment cites AGENTS.md).

  Closes seven citation arcs: cycle 387 (1, adjacent
  forward; AGENTS.md → its canonical example AND its
  violation instance; uniform-convention-unevenly-applied
  new framing) + cycle 386 (1, documentation-trails-code
  framing extends: here the documentation describes a
  convention; code BOTH follows AND violates it; doc and
  code drift in TWO directions within ONE convention) +
  cycle 384 (1, design-doc-trails-code framing; here it's
  source-violates-doc which is yet another direction) +
  cycle 367 (9, exo violates AGENTS but cycle 387 named
  the 3×3 this-context matrix; the violation surrounds
  the most-named exo APIs) + cycle 327 (8, patterns is
  the canonical example; pattern's own convention-
  application is exemplary) + cycle 326 (62) + cycle 322
  (62). Pushes citation-arc-closures-in-pivot to THREE-
  HUNDRED-NINETY-FIVE (388 + 7 net new).
---

9-line patterns/types-index.d.ts — the canonical example of AGENTS.md's types-index convention. §the-named-canonical-and-violating-instances-of-types-index-convention (single most structurally interesting move; patterns is canonical at 9 lines, exo violates at 176 lines with 6 `declare function` overloads that AGENTS.md says belong in .ts files). §the-named-uniform-convention-unevenly-applied. §the-named-comment-naming-convention-and-pointing-to-source (line 2 "See AGENTS.md for the types-index convention"); §the-named-self-documenting-header-with-pointer-to-authority. §the-named-export-type-star-from-as-type-only-star-re-export (TypeScript 5.0+ syntax). §the-named-three-file-dance-for-value-namespace-merge (type-from-pattern.ts defines + types-index.d.ts re-exports types + types-index.js re-exports runtime); §the-named-three-file-dance-for-typed-runtime-export. §the-named-AGENTS-md-convention-cited-in-source-comment; §the-named-source-to-doc-pointer-as-convention-reinforcement. §the-named-nine-line-as-AGENTS-conformant-shape. §the-named-exo-types-index-d-ts-violates-AGENTS-md-convention; §the-named-convention-violation-may-be-historical-or-deliberate-or-pending. §the-named-AGENTS-md-and-source-converge-via-pointer; §the-named-bidirectional-doc-source-coupling. Seven citation arcs closed.
