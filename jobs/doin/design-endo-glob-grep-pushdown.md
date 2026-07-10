---
role: designer
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-10T19:40:04Z -->

---
role: designer
---

# Design: push glob/grep down into @endo/platform, design forward for streaming

**Repo/stack:** the **endo #127** stack — glob and grep for the bots' agent
tooling, on the `kriscendobot/endo` fork of `endojs/endo`. Read PR #127 and every
layer of its stack before proposing anything.

**This is the DESIGN step of a serial orchestration** (`orch-endo-glob-grep-pushdown`):
designer → builder → gauntlet-per-layer. Your deliverable is a concrete design
the builder can implement against, and that the per-layer gauntlet can then be
run over. Design forward; do not write production code.

## The maintainer's framing (kriskowal, verbatim intent)

There is a tension between (a) having a **working, normative JavaScript
implementation** of grep and glob and (b) presenting them behind an **interface
that leaves room for performance improvements going forward**. Resolve it by
designing the interface for the future while letting today's implementation be
the plain normative JS.

Specific design constraints and intentions to honor:

1. **`Promise<Array>` is the right present-day surface** for the Array case —
   it reveals little machinery. Keep it. But treat it as one case of a broader
   design, not the whole design.
2. **Plan for future streaming variants** built on **exo-stream**. These will
   **perform very poorly unless results are batched** — the stream must carry
   *groups* of results, not one result per message. Design the streaming variant
   (even if not implemented now) so batching is intrinsic, and so today's
   `Promise<Array>` surface and tomorrow's stream surface are coherent siblings,
   not a rewrite.
3. **Push the implementation as far down as each platform allows, case by case.**
   The primary near-term concern is to **design forward** and **push glob and
   grep down into the `@endo/platform` package**, to be **revealed in the daemon
   layer**. Enumerate, per platform, how far down the real work can go (native
   FS/glob facilities where available, JS fallback where not) and where the seam
   sits.
4. **Decouple glob from grep so they compose** — especially at the streaming
   layer. The goal is to **pipeline a file stream from glob into grep** rather
   than **coupling glob to grep** (i.e. grep should not take glob as an embedded
   option). Design the composition seam so a glob file-stream feeds grep.
5. **The Array case likely should NOT pass glob as an option to grep.** Instead
   grep takes an **array (or `Promise<Array>`) of paths** to search. That keeps
   the Array and streaming cases parallel: array-of-paths now, stream-of-paths
   later, glob as an independent producer of either. Evaluate this and commit to
   a shape.
6. **Agent tool surface + primer.** These new tools change the **agent tool
   surface** and require **primer instructions** teaching an agent how and when
   to use glob and grep (and how they compose). Design that surface and the
   primer copy as part of this work, so the builder has a target.

## What to produce

- A design document / proposal (in the endo repo's design location and/or as the
  stack's design narrative, per the [designer](../../roles/designer/AGENT.md)
  role and [design-to-pr-pipeline](../../skills/design-to-pr-pipeline/SKILL.md)
  conventions) that resolves the tensions above and lays out:
  - the `@endo/platform` pushdown seam and the daemon-layer reveal;
  - the per-platform "how far down can it go" table (native vs JS fallback);
  - the Array surface (`grep(paths: Array|Promise<Array>, …)`, glob as a separate
    path producer — confirm or revise);
  - the forward-designed exo-stream streaming variant with **intrinsic batching**
    and the **glob→grep pipeline** composition seam;
  - the agent-tool-surface changes and the primer instructions for the new tools.
- Surface the open questions explicitly (that is the designer's job) rather than
  papering over them; the builder and the gauntlet panels will need them named.
- Map the design onto **the layers of the #127 stack** so the builder and the
  subsequent per-layer gauntlet know which change lands where.

## Skills

- [design-to-pr-pipeline](../../skills/design-to-pr-pipeline/SKILL.md),
  [design-dependency-walk](../../skills/design-dependency-walk/SKILL.md)
- [pr-dependency-graph](../../skills/pr-dependency-graph/SKILL.md),
  [pr-dependency-topo-sort](../../skills/pr-dependency-topo-sort/SKILL.md) — to
  read the stack's layer order.
- [self-improvement](../../skills/self-improvement/SKILL.md) — standing last step.

## Done

A design the builder can implement layer-by-layer, with the six constraints above
resolved or their open questions named, the `@endo/platform`/daemon seam defined,
the streaming+batching+pipeline future designed, and the agent-tool-surface/primer
work specified. The `tada` report links the design artifact and lists the per-layer
implementation map.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 16
  claimed_at: 2026-07-10T19:40:09Z
