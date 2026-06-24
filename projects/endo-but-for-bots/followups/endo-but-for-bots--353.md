---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 353
created_at: 2026-05-22T03:16:11Z
last_appended_at: 2026-05-22T03:16:11Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#353

Created from the barrister code-panel verdict (twenty-six seats, in-band fallback) on the `fix(module-source): propagate live-export writes for export let bindings` PR. Two follow-up items warrant revisit at merge time. The remaining must-fix-loop items go to the fixer this round and are not ledger entries.

## Items

- [ ] **REWRITE.md design-document update for the Program-enter rename pass.**
  **Source juror(s)**: archivist, integrator.
  **Round**: 1.
  **Recommended action**: open a follow-up doc PR (or bundle into the next module-source touch) that appends a section to `packages/module-source/REWRITE.md` describing the new Program-enter scope-rename pass added in #353. The new pass is structurally distinct from what the document currently describes (a single up-front sweep that softens every top-level exported live binding before any other transform-pass visitor descends). Future readers consulting REWRITE.md will not find the pass without this addition. Actioning trigger: PR #353 merges or its upstream mirror merges.

- [ ] **Property-based generalization of reassignment-publish tests.**
  **Source juror(s)**: fast-checker.
  **Round**: 1.
  **Recommended action**: open a follow-up test PR that replaces (or augments) the three example-based reassignment-publish tests (`var reassignment publishes through liveVar`, `function reassignment publishes through liveVar`, `let postfix and compound reassignment publish through liveVar`) with a `fc.assert(fc.property(...))` formulation over arbitrary identifier names and arbitrary value sequences, asserting the invariant "every reassignment of a top-level exported live binding publishes the new value to the bundled live cell". The arbitraries are tractable (`fc.string({ minLength: 1 }).filter(isValidIdentifier)` for names, `fc.array(fc.anything())` for value sequences). The dependency is in-house. Actioning trigger: PR #353 merges or its upstream mirror merges.
