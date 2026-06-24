---
ts: 2026-06-22T05:35:00Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - pr: endojs/endo-but-for-bots#379
---

Addressed kriskowal's Jun 15 CHANGES_REQUESTED comment 3411446112 on
`packages/compartment-mapper/test/cycle-esm-in-cjs-node-parity.test.js`.

The parity-test merging was already complete in prior commits (3b0928fe3 and
ca17e11e4): all five parity-test pairs were consolidated into their
corresponding main test files. This dispatch found the work done and focused
on gate hygiene and the inline-thread reply.

Gate fixes landed in two new commits:

- 4b210e118: `chore: fix pre-push-gate findings across all packages`
  - SECURITY.md hash uniformity: bytes, hex, immutable-arraybuffer, and
    panic carried divergent SECURITY.md files; normalized to the canonical
    and reformatted all 50 packages with sentence-per-line prose to clear
    the sentence-per-line-md probe.
  - no-inline-import-jsdoc: evasive-transform/src/index.js had two inline
    @property {import(...).T} forms; converted to @import declarations.
  - eslint auto-fix on ses/src/compartment.js (JSDoc structure).
- c0044e4cb: `test(compartment-mapper): drop issue citations from unused-assertions module`
  - _cycle-rename-unused-assertions.js still had `endojs/endo#59` and
    `issue #59` references that the no-pull-citations probe catches.
    Rewrote prose to stand on its own description.

Pushed to origin/fix/issue-59-star-export-cycle (3b0928fe3..c0044e4cb).
Replied on thread 3411446112 citing the consolidation SHAs and summarizing
per-file changes.

All 1014 compartment-mapper tests pass. Pre-push gate: pass.

Self-improvement: the security-md-hash-uniform and sentence-per-line-md
probes conflict when a repo's canonical SECURITY.md itself has multi-sentence
lines (copying it to fix hash uniformity immediately triggers the prose
probe). The right fix is to correct the canonical first, then propagate.
Worth noting in the pre-push-gates field notes if this pattern recurs.
