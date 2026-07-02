Inbox empty. Job complete.

## Completion report

**Directive** (kriskowal, `endojs/endo-but-for-bots#58` review 4612637233): "Typedefs in .d.ts, please. Adjust the garden to avoid this in the future with builder directives and a reviewer." Encoded as a two-pronged, self-reinforcing pair mirroring the makeExo-over-`Far` / `@import`-over-inline-`import()` patterns.

**What changed** (garden `main2`, commit `3d918054a`):

1. **Builder directive** — added an always-read operating norm to `roles/builder/AGENT.md`: shared or exported type definitions live in the package's dedicated type module (`src/types.ts`, which `tsc` emits as the `.d.ts`; or a hand-written `.d.ts` re-export index) and are pulled into `.js` via a top-of-file `/** @import { Foo } from './types.js' */` — never a multi-field `@typedef {{ ... }}` block inline in a `src/**/*.js` file. **Escape hatch documented:** a genuinely module-private, single-use `@typedef` referenced only within one `.js` file (never exported, never reused) may stay inline.

2. **Reviewer** — added the matching review check to the `typist` juror seat (`roles/jurors/typist/AGENT.md`), which is an always-on code-panel seat, so every source-touching PR is now checked. It flags any multi-field, exported, or reused inline `@typedef` in a `.js` file, with the same escape hatch and the fix (move to the types module and `@import`).

Both files' `updated:` frontmatter bumped to 2026-07-02; both norms carry the `#58` provenance.

**Design choices:** Chose the juror-seat route over a `@endo/eslint-plugin` lint rule (endo-but-for-bots change) because "should live in .d.ts" needs judgment — exported/shared vs. module-private — which `skills/pre-push-gates/SKILL.md` explicitly routes to the panel, not to a deterministic gate that would over-fire on legitimate local typedefs. No garden CLAUDE.md change was needed (the rule lives on the role/juror, its natural home).

**Follow-ups:** None required. If the maintainer later wants a deterministic backstop, the reference AGENTS.md convention (`src/types.ts` canonical, `.d.ts` re-export index) could seed a `@endo/eslint-plugin` rule on endo-but-for-bots (base `llm`, changeset, tests) — out of scope for this terse encoding.
