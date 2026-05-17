---
ts: 2026-05-17T20:22:00Z
kind: dispatch
role: liaison
project: garden
to: "*"
refs:
  - entries/2026/05/17/200629Z-message-fixer-c0a0db.md
  - "https://github.com/endojs/endo-but-for-bots/pull/238 inline comment id=3237804603"
---

# Dispatch: gardener encodes "prefer mermaid over ASCII/line-art" rule

Dispatch root: `dispatches/gardener--87efc2/`. Garden-only (no project worktree).

Maintainer directive on `endojs/endo-but-for-bots#238` (inline comment id `3237804603`, forwarded by fixer at `200629Z-message-fixer-c0a0db.md`):

> *"Please remind the gardener that the designer, builder, and reviewers should all strive to ensure that we use mermaid diagrams and eschew ASCII and line-art diagrams, since the former is more human-maintainable."*

The fixer cites the rps-demo README's ASCII capability sketch as the recent recurring example, and proposes one-liner landings on `roles/designer/AGENT.md`, `roles/builder/AGENT.md`, plus widening the design-panel critic/pedant/copyeditor seats' style remit.

## Task

Read `garden/roles/COMMON.md`, then read the forwarded message and a few existing style-norm rows to pick the right shape.

1. **Decide the landing shape.** Options to weigh:
   - **A:** One-liner on `roles/designer/AGENT.md` § Operating norms and on `roles/builder/AGENT.md` § Operating norms, plus a comment-only flag norm on the design-panel seats that read prose style (`pedant`, `copyeditor`; possibly `critic`).
   - **B:** A new tiny skill `garden/skills/mermaid-over-ascii/SKILL.md` (or similar slug) that captures the rule + rationale + acceptable exceptions, referenced from the three roles' skill lists. Heavier-weight; useful if the rule has nuance.
   - **C:** A line in `garden/CLAUDE.md` § Conventions if the rule applies garden-wide (not just project work).
   
   Gardener picks. The fixer suggested A; B is fine if the rule has subtlety (e.g., when ASCII is acceptable — small inline arrows in code comments, structural pre-existing diagrams that aren't worth converting, etc.).

2. **Record the rationale**: human-maintainability. Mermaid is text but renders as a maintained diagram; ASCII line-art rots under editing.

3. **Cite the maintainer's PR #238 comment** as the source-of-rule so future readers can trace the provenance.

4. **Consider acceptable exceptions**:
   - Inline arrows in code comments (`// foo -> bar`)
   - Pre-existing ASCII diagrams in untouched files (don't churn the diff for this rule alone)
   - Terminal output examples / log snippets / tabular ASCII (not diagrams)

5. **Update affected roles** per the chosen landing shape.

6. **Write the result entry** at `journal/entries/2026/05/17/<ts>-result-gardener-87efc2.md`: landing-shape decision + rationale, file list edited, one-line `Self-improvement: ...`.

7. **Commit + push both branches.** No self-PR per garden conventions.

## Per-action authorization

Standing on garden's main + journal per CLAUDE.md § Conventions.

## Out of scope

- No code or comment on any project repo.
- No conversion of existing ASCII diagrams (that's a separate cleanup engagement if the maintainer wants it).

## Report

≤ 250 words: landing-shape decision (A / B / C / hybrid), file list edited, acceptable-exceptions list, one-line `Self-improvement: ...`. The liaison surfaces the rule on the bulletin if the maintainer finds it ready for use.
