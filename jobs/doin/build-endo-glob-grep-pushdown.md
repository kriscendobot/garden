---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-10T19:58:06Z -->

---
role: builder
---

# Build: implement the glob/grep @endo/platform pushdown across the #127 stack

**Repo/stack:** the **endo #127** stack on the `kriscendobot/endo` fork of
`endojs/endo`. **This is the BUILD step of a serial orchestration**
(`orch-endo-glob-grep-pushdown`) that runs **after** the design child
(`design-endo-glob-grep-pushdown`) lands in `tada/`. **Read that design's `tada`
report and its linked design artifact first** — implement against it, do not
re-derive the design.

## What to implement (per the landed design)

Realize the design across the layers of the #127 stack:

1. **Push glob and grep down into `@endo/platform`**, revealed at the **daemon
   layer**, keeping today's **`Promise<Array>`** surface for the Array case.
2. **Push the implementation as far down as each platform allows, case by case** —
   native FS/glob facilities where the design says they exist, normative JS
   fallback elsewhere. The JS implementation must remain **working and normative**.
3. **Array surface:** implement grep to take an **array (or `Promise<Array>`) of
   paths** rather than glob-as-an-option, per the design's committed shape, so
   glob is an independent producer of paths.
4. **Design forward for streaming without over-building:** leave the seams the
   design specifies for the future exo-stream variant with **intrinsic batching**
   and the **glob→grep pipeline**. Implement only what the design scopes into
   #127; do not couple glob to grep.
5. **Agent tool surface + primer:** implement the agent-tool-surface changes and
   land the **primer instructions** for the new glob/grep tools per the design.

## Norms

- Follow the design's **per-layer implementation map**; keep each layer of the
  stack a coherent, independently reviewable change (the gauntlet runs per layer
  next). Use [stacked-pr-build](../../skills/stacked-pr-build/SKILL.md) /
  [worktree-per-pr](../../skills/worktree-per-pr/SKILL.md).
- Verify locally before handoff ([local-verify](../../skills/local-verify/SKILL.md),
  [pre-push-gates](../../skills/pre-push-gates/SKILL.md)); keep `yarn.lock` in a
  separate commit if touched ([yarn-lock-separate-commit](../../skills/yarn-lock-separate-commit/SKILL.md)).
- If the design has a gap or a constraint proves infeasible, **stop and report it
  up** rather than silently diverging — the orchestration halts on child failure,
  and a design gap is better surfaced than papered over.

## Skills

- [design-to-pr-pipeline](../../skills/design-to-pr-pipeline/SKILL.md),
  [stacked-pr-build](../../skills/stacked-pr-build/SKILL.md),
  [worktree-per-pr](../../skills/worktree-per-pr/SKILL.md),
  [local-verify](../../skills/local-verify/SKILL.md),
  [pre-push-gates](../../skills/pre-push-gates/SKILL.md),
  [self-improvement](../../skills/self-improvement/SKILL.md).

## Done

The design is implemented across the #127 stack layers: glob/grep pushed into
`@endo/platform` and revealed at the daemon layer, the Array `Promise<Array>`
surface preserved with grep taking paths (not glob-as-option), streaming seams
left per design, and the agent-tool-surface + primer updated. Each layer is
locally verified and ready for its gauntlet. The `tada` report lists the layers
built, the commits/branches per layer, and any design gaps hit.

<!-- garden-deadline-overrun: 1 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 16
  claimed_at: 2026-07-10T19:58:10Z
