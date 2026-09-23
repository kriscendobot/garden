---
source_kind: agent-conventions-document
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: AGENTS.md
source_line_range: 1-92
ingested: 2026-06-18
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 387 designs-lane ingest. 92-line AGENTS.md at the
  endo-but-for-bots/llm repo root. Repository's
  machine-readable conventions document for AI agents
  working in the codebase. Thirty-fifth AUTHORED conformant
  single-body section doc in post-refactor era. Seventy-
  seventh consecutive non-garden source after the pivot
  (310-387). §seventy-seven-cycles-with-named-pivot-domain-
  stay.

  Single most structurally interesting move: §the-named-
  AGENTS-md-as-agent-conventions-document — file at repo
  root named AGENTS.md (not CLAUDE.md) addressed to AI
  agents. The file's existence is itself the structural
  move: the repo has machine-readable conventions for
  agent contributors. Sibling shape to cycle 383's evoke/
  SOUL.md (agent discipline) and the project-root CLAUDE.md
  (Claude-specific). The TWO files differ in audience:
  CLAUDE.md addresses Claude specifically; AGENTS.md
  addresses agents generically. §the-named-claude-and-
  agents-md-pair-with-different-audiences as tier-3 meta-
  pattern; the bot-fork has TWO agent-conventions documents
  at different specificity levels.

  §The-named-types-index-convention — lines 25-38: each
  package that exports types uses a PAIR of files. `types-
  index.js` for runtime re-exports of values with enhanced
  type signatures. `types-index.d.ts` for pure type re-
  exports (only `export type * from` and `export { ... }
  from`; no type definitions). The convention has a sharp
  rule: no type definitions in `.d.ts`. §the-named-types-
  index-js-and-d-ts-pair as tier-3 meta-pattern.

  §The-named-d-ts-files-silently-pass-but-ts-files-checked
  — the SUBSTRATE reason for the convention, named on lines
  30-31: "`.d.ts` files are not checked by `tsc` (we use
  `skipLibCheck: true`). Type definitions in `.d.ts` files
  silently pass even if they contain errors. Definitions
  in `.ts` files are checked." §the-named-typescript-
  checking-asymmetry-drives-convention as tier-3 meta-
  pattern; the file-extension's checking semantics directly
  shape where definitions belong.

  §The-named-no-ts-in-runtime-bundles-rule — lines 17-19:
  "Never use `.ts` files in modules that are transitively
  imported into an Endo bundle. The Endo bundler does not
  understand `.ts` syntax. We avoid build steps for runtime
  imports." §the-named-bundler-constraint-forces-js-runtime
  as tier-3 meta-pattern; the bundling pipeline shapes the
  source-file extension discipline.

  §The-named-emit-declaration-only — line 53: the repo-wide
  `tsconfig-build-options.json` sets `emitDeclarationOnly:
  true`. tsc generates `.d.ts` only, never `.js`. The
  build configuration enforces the runtime/types separation.
  §the-named-build-config-enforces-source-discipline as
  tier-3 meta-pattern.

  §The-named-JSDoc-import-without-runtime-load — lines 56-
  60: `/** @import { Pattern, MatcherNamespace } from './
  types.js' */` for type-only imports without runtime
  module loading. This is the cycle 376 §the-named-JSDoc-
  import-syntax convention applied to the agent-facing
  documentation surface. §the-named-jsdoc-import-as-
  documented-convention as tier-3 meta-pattern.

  §The-named-exo-this-context-table — lines 64-78: a TABLE
  showing which fields of `this` are available across the
  three exo APIs. Cycle 367 named the §the-named-this-state-
  this-self-this-facets triple; AGENTS.md gives the matrix:

  | API | this.self | this.facets | this.state |
  |-----|-----------|-------------|------------|
  | makeExo | ✓ | ✗ | ✗ (always `{}`) |
  | defineExoClass | ✓ | ✗ | ✓ from init() |
  | defineExoClassKit | ✗ | ✓ | ✓ from init() |

  §the-named-exo-three-by-three-this-context-matrix as
  tier-3 meta-pattern; the three APIs and three this-fields
  form a 3×3 table where 6 of 9 cells are filled and 3 are
  empty.

  §The-named-why-no-self-on-kits-explanation — lines 72-73
  give the reasoning: "A kit has multiple facets (e.g.
  `public`, `admin`), each a separate remotable object.
  There is no single 'self'. Use `this.facets.facetName`
  to access any facet in the cohort." The MULTIPLE FACETS
  per kit means there's no singular self to bind. §the-
  named-multi-facet-precludes-singular-self as tier-3
  meta-pattern.

  §The-named-never-mix-self-and-facets-in-same-context —
  line 78: a discipline rule for type writers. The two
  fields are mutually exclusive per context-type
  declaration. §the-named-mutually-exclusive-binding-
  fields-must-not-be-mixed as tier-3 meta-pattern.

  §The-named-conventional-commits-with-package-scope —
  lines 90-91: `feat(pkg):` `fix(pkg):` `refactor(pkg):`
  `chore:` `test(pkg):`. Conventional Commits format with
  package scope. §the-named-package-scope-in-commit-prefix
  as tier-3 meta-pattern; the package name appears IN the
  commit prefix, not in the body, so the change scope is
  visible in `git log --oneline`.

  §The-named-file-conversion-as-own-refactor-commit —
  line 92: "File conversions (`.js` to `.ts`) get their own
  `refactor:` commit." File-extension changes are their own
  commit. §the-named-cosmetic-changes-isolated-in-own-
  commit as tier-3 meta-pattern; sibling shape to cycle
  380's §the-named-bundle-source-patched-because-it-depends
  — both are about keeping commits clean of unrelated churn.

  §The-named-ninety-two-line-agent-conventions-document —
  the document fits a substantial set of agent conventions
  in 92 lines. Sibling shape to cycle 369 daemon README,
  cycle 365 skel README, cycle 363 benchmark README, all
  of which carry substantial content in modest line counts.
  §the-named-minimal-readme-for-substantial-system extends
  to AGENTS.md.

  Closes seven citation arcs: cycle 386 (1, adjacent
  forward; chat parser source → agent conventions doc) +
  cycle 383 (1, evoke/SOUL.md was agent discipline at the
  workflow layer; AGENTS.md is at the code-style layer;
  the two complement) + cycle 367 (8, exo this-context
  triple from cycle 367 gets its 3×3 matrix here) + cycle
  376 (2, JSDoc @import convention named explicitly in
  AGENTS.md) + cycle 326 (61, pure-naming-as-discipline)
  + cycle 327 (7, patterns M used in types-index examples)
  + cycle 322 (61). Pushes citation-arc-closures-in-pivot
  to THREE-HUNDRED-EIGHTY-EIGHT (381 + 7 net new).
---

92-line AGENTS.md at endo-but-for-bots/llm repo root. §the-named-AGENTS-md-as-agent-conventions-document (single most structurally interesting move; file specifically addressed to AI agents; sibling to CLAUDE.md with different audience). §the-named-claude-and-agents-md-pair-with-different-audiences. §the-named-types-index-convention (types-index.js + types-index.d.ts pair). §the-named-d-ts-files-silently-pass-but-ts-files-checked (substrate reason; skipLibCheck:true makes the checking asymmetry); §the-named-typescript-checking-asymmetry-drives-convention. §the-named-no-ts-in-runtime-bundles-rule; §the-named-bundler-constraint-forces-js-runtime. §the-named-emit-declaration-only; §the-named-build-config-enforces-source-discipline. §the-named-JSDoc-import-without-runtime-load (cycle 376 syntax as documented convention). §the-named-exo-this-context-table (3×3 matrix: makeExo/defineExoClass/defineExoClassKit × this.self/this.facets/this.state); §the-named-exo-three-by-three-this-context-matrix. §the-named-why-no-self-on-kits-explanation; §the-named-multi-facet-precludes-singular-self. §the-named-never-mix-self-and-facets-in-same-context. §the-named-conventional-commits-with-package-scope. §the-named-file-conversion-as-own-refactor-commit; §the-named-cosmetic-changes-isolated-in-own-commit. §the-named-ninety-two-line-agent-conventions-document (sibling minimal-readme-for-substantial-system shape). Seven citation arcs closed.
