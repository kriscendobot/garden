---
role: designer
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-10T21:40:04Z -->

---
role: designer
---

# Design: introduce Spark gardeners

**This is the DESIGN step of a serial orchestration** (`orch-spark-gardeners`)
that runs **after** the scholar child (`scholar-muse-spark-harness`) lands in
`tada/`. **Read that scholar's `tada` report and its `journal/library/` ingest
first** — build the design on its findings about Muse Spark's agent-relevant
capabilities and the Willison harness path; do not re-research from scratch.

**Garden's own repo** (`kriskowal/garden`, `main2`): this is a garden-meta design.
Land the design document under `designs/` (e.g. `designs/spark-gardeners.md`),
built in an isolated worktree off `origin/main2` and pushed directly (no PR;
garden-infra convention). Develop in your cwd worktree, never the root checkout.

## What to design

A **Spark gardener**: a gardener fleet-worker variant whose model harness is
**Meta's Muse Spark, driven via Simon Willison's tool**, rather than `claude -p`.
Design how it fits the existing fleet, honestly surfacing the open questions (the
designer's job is to name tensions, not paper them):

- **Harness seam.** Today a claimed job runs through `scripts/jobs/handlers/gardener-claude.sh`
  (a `claude -p` invocation with model resolved from the job's `model:`/`role:`).
  Define the analogous **Spark harness** invocation path (based on the scholar's
  findings), and where the seam sits — a sibling handler, a pluggable harness
  selector, or a `harness:`/`model:` field the gardener keys on.
- **Capability fit → which work routes to Spark.** From the scholar's tool-calling
  / agentic-loop assessment, decide **which roles or job kinds a Spark gardener
  can actually perform** (e.g. can it run the supervised gauntlet state machine,
  or only text-shaped tasks like drafting/summarizing?). If Muse Spark lacks
  tool-use, say plainly what it therefore cannot be assigned.
- **Fleet integration.** How Spark gardeners claim from the same board (the
  git-push CAS is model-agnostic), the systemd unit shape (a `garden-spark-gardener@`
  template vs a flag on the existing gardener), pool sizing, and leader/follower
  behavior (they run on every host like normal gardeners).
- **Model-selection & token-spend.** How Spark slots into the
  [model-selection](../../skills/model-selection/SKILL.md) map and
  `role_default_model` (a new harness tier, or a per-job `harness:` orthogonal to
  `model:`), and how its token/cost is metered (ties to the token-spend concerns
  the garden is already tracking).
- **Routing control.** How a producer or the maintainer *chooses* a Spark
  gardener for a job (a `harness: spark` job field? a dedicated `spark-*` job
  class? a pool the foreman routes suitable work to?).

## Output

A design document under `designs/` resolving the above or naming the open
questions, with an Options-Considered treatment of the harness-seam choices, and a
clear statement of what Spark gardeners can and cannot be assigned. If the design
warrants follow-on build work, note the phasing (it does not itself build).
Committed and pushed to `main2`.

## Skills

- [design-to-pr-pipeline](../../skills/design-to-pr-pipeline/SKILL.md),
  [design-dependency-walk](../../skills/design-dependency-walk/SKILL.md),
  [model-selection](../../skills/model-selection/SKILL.md),
  [context-library](../../skills/context-library/SKILL.md),
  [em-dash-style](../../skills/em-dash-style/SKILL.md),
  [no-latin-shorthand](../../skills/no-latin-shorthand/SKILL.md),
  [relative-paths](../../skills/relative-paths/SKILL.md),
  [self-improvement](../../skills/self-improvement/SKILL.md).

## Done

`designs/spark-gardeners.md` (or the chosen path) lands on `main2` defining the
Spark-gardener harness seam, the capability-based routing (what Spark can/can't
do), fleet + model-selection + token-spend integration, and the routing-control
mechanism — open questions named, not hidden. The `tada` report links the design,
the SHA, and the recommended build phasing.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 4
  claimed_at: 2026-07-10T21:40:08Z
