---
gate: orchestrated
orchestrated_by: orch-endo-glob-grep-pushdown
priority: normal
posted_by: producer
posted_at: 2026-07-10T19:38:35Z
---

# Run the gauntlet on each layer of the endo #127 glob/grep stack

**Repo/stack:** the **endo #127** stack on the `kriscendobot/endo` fork of
`endojs/endo`, as built by the build child (`build-endo-glob-grep-pushdown`).
**This is the GAUNTLET step of a serial orchestration**
(`orch-endo-glob-grep-pushdown`) that runs **after** the build child lands in
`tada/`. Read the build child's `tada` report for the per-layer branch/PR map
before starting.

## What to do

**Run the full gauntlet on each layer of the stack** — the PR-creation chain
(clean → panel review → fix-loop → un-draft), per
[pr-creation-flow](../../skills/pr-creation-flow/SKILL.md).

- **Enumerate the stack in dependency order** ([pr-dependency-topo-sort](../../skills/pr-dependency-topo-sort/SKILL.md),
  [pr-dependency-graph](../../skills/pr-dependency-graph/SKILL.md)) and run the
  gauntlet **layer by layer, bottom-up**, so each layer is reviewed on a rebased,
  green base ([rebase-before-followup](../../skills/rebase-before-followup/SKILL.md),
  [frozen-base-branch](../../skills/frozen-base-branch/SKILL.md)).
- For **each** layer: clean the diff, run the review **panel**
  ([panel](../../skills/panel/SKILL.md)), drive the fix-loop until the panel is
  satisfied, then un-draft. The panels should specifically **ponder the design
  tensions** the maintainer raised — the `@endo/platform`/daemon seam, the
  `Promise<Array>` surface vs future streaming, batching, and the glob↔grep
  decoupling / pipeline composition — not just surface correctness.
- If a layer's panel surfaces a design-level problem (not just a fixable nit),
  **report it up**; the orchestration halts on child failure so the tension can be
  re-pondered rather than merged past.

## Skills

- [pr-creation-flow](../../skills/pr-creation-flow/SKILL.md),
  [panel](../../skills/panel/SKILL.md),
  [pr-dependency-topo-sort](../../skills/pr-dependency-topo-sort/SKILL.md),
  [pr-dependency-graph](../../skills/pr-dependency-graph/SKILL.md),
  [rebase-before-followup](../../skills/rebase-before-followup/SKILL.md),
  [frozen-base-branch](../../skills/frozen-base-branch/SKILL.md),
  [self-improvement](../../skills/self-improvement/SKILL.md).

## Done

Every layer of the #127 stack has been through the gauntlet: cleaned, panel-
reviewed with the design tensions explicitly weighed, fix-looped, and un-drafted
(or halted with a named design problem). The `tada` report lists each layer, its
gauntlet outcome, and any tension referred back up for re-design.
