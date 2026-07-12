---
gate: orchestrated
orchestrated_by: orch-endo-inspect
priority: normal
posted_by: producer
posted_at: 2026-07-12T16:46:24Z
---

---
role: conductor
---

# Conduct the @endo/inspect design PR to `llm`

**This is the CONDUCT step of a serial orchestration** (`orch-endo-inspect`) that runs
**after** the design child (`design-endo-inspect`) lands in `tada/`. **Read that
child's `tada` report for the design PR number.**

**Task:** conduct (merge) the `@endo/inspect` design PR to **`llm`** on
`endojs/endo-but-for-bots`, per the standing conductor discipline
([conductor](../../roles/conductor/AGENT.md)).

- **Merge-readiness gate:** the design tags `@erights` and `@mhofman` for assistance
  (maintainer directive). Do **not** merge over unresolved review: conduct only once
  the PR is green and its review is settled (un-drafted / approved / no outstanding
  CHANGES_REQUESTED). If it is still awaiting expert input or has requested changes,
  **hold and report** that the design is not yet merge-ready rather than forcing it —
  this is a design that explicitly wants expert eyes before it lands.
- This is a merge to the bot's roadmap branch `llm` (fleet-internal), **not** an
  upstream ferry — no identity switch.
- Fully-qualify issue/PR references in any comment; ASCII prose (house style).

## Skills
- [conductor](../../roles/conductor/AGENT.md) discipline,
  [pr-ci-watch](../../skills/pr-ci-watch/SKILL.md),
  [rebase-before-followup](../../skills/rebase-before-followup/SKILL.md),
  [self-improvement](../../skills/self-improvement/SKILL.md).

## Done
The `@endo/inspect` design PR is merged (conducted) to `llm` — or, if not merge-ready
(unresolved review / awaiting `@erights`/`@mhofman`), **held with a clear report** of
what blocks it. The `tada` report states the merge SHA (or the hold reason) and the
design's location on `llm` so the build step can read it.
