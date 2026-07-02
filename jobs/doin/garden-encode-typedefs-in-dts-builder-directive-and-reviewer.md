# Encode: typedefs belong in .d.ts (builder directive + a reviewer) — maintainer meta-directive
kriskowal (#58 review 4612637233, on `packages/daemon/src/trace-aggregator.js:41`): "**Typedefs in .d.ts,
please. Adjust the garden to avoid this in the future with builder directives and a reviewer.**"
Encode this so it doesn't recur (mirror the makeExo-over-Far pattern):
1. **Builder directive:** add to the builder role/skill (its always-read guidance) that **type definitions
   go in `.d.ts` files**, not inline typedefs in `.js`, per Endo house style.
2. **A reviewer/juror check:** add/extend a juror seat (or a lint rule in `@endo/eslint-plugin` on
   endo-but-for-bots) that **flags inline typedefs in `.js` that should live in `.d.ts`**, so review catches
   it. Document the escape hatch if any.
Land the role/skill (+ CLAUDE.md if needed) on `main2` via an isolated worktree; if you add a lint rule,
that's an endo-but-for-bots change (base `llm`, `@endo/eslint-plugin`, changeset, tests). Keep it terse.

---
claim:
  host: endolinbot2
  gardener: 43
  claimed_at: 2026-07-02T04:05:04Z
