---
role: builder
---

# Build: Chat inventory `+` create menu and new-agent wizard

**Repo:** `endojs/endo-but-for-bots` (work on the bot fork), base branch **`llm`**.
**Design:** `designs/chat-inventory-create-menu.md` (in-repo; journal mirror:
`journal/plan/designs/endo-but-for-bots/chat-inventory-create-menu.md`), size **L**,
milestone **M9**. The **design PR #404** is already **MERGED** onto `llm` — this is
the **implementation** of that approved design. Read the design in full first and
build against it; do not re-derive it.

## What to build (per the design, honoring its phasing)

Implement the `+` create affordance on the Chat inventory:

1. **The `+` button at the TOP of the inventory** (the maintainer moved it from the
   bottom to the top on PR #404 — follow the revised placement) and its pop-over
   menu listing the whole-cloth item types Chat can mint: filesystem mount, scratch
   space, passable value, structured value, new agent.
2. **Per-item create flows.** Respect the design's shippability phasing:
   - **Filesystem mount** — the **shippable-today** flow; implement it fully via the
     existing mount-create composition (`E(powers).provideMount` /
     `provideScratchMount`).
   - The **other item types** ship as the design's **documented placeholders** that
     surface the architectural direction without offering a half-implemented
     control — build them exactly as the design specifies (placeholder, not
     half-working).
3. **New-agent wizard** — the substantive flow: endowment selection (`@main` worker,
   later `@fs`/`@node`), inference-source selection (Anthropic / OpenAI / Ollama /
   OpenRouter **without the user needing to know URLs**), and harness selection
   (Fae / Lal / Genie until they converge). Implement the layers the design scopes
   into this phase; leave the later-phase seams (subscription OAuth, etc.) as the
   design marks them — do not build ahead of the design.

**Out of scope** (per the design): new daemon-side message types or capability
shapes — it composes existing/designed primitives (form-request, value-message,
mount, provider-registry) only; and the Familiar weblet hosting / packaging layer.

## Norms

- Build in the gardener's per-job `project/` worktree off `llm`
  ([worktree-per-pr](../../skills/worktree-per-pr/SKILL.md)); open a **DRAFT** PR
  against `llm` ([pr-formation](../../skills/pr-formation/SKILL.md)).
- Verify locally before handoff — the Chat UI actually renders the button, the
  menu opens at the top, and the filesystem-mount create flow works end to end
  ([local-verify](../../skills/local-verify/SKILL.md),
  [pre-push-gates](../../skills/pre-push-gates/SKILL.md)); keep `yarn.lock` in a
  separate commit if touched
  ([yarn-lock-separate-commit](../../skills/yarn-lock-separate-commit/SKILL.md)).
- If the design has a gap or a cited primitive isn't actually landed on `llm`,
  stop and report it up rather than inventing daemon machinery the design excludes.

## Skills

- [design-to-pr-pipeline](../../skills/design-to-pr-pipeline/SKILL.md),
  [worktree-per-pr](../../skills/worktree-per-pr/SKILL.md),
  [pr-formation](../../skills/pr-formation/SKILL.md),
  [local-verify](../../skills/local-verify/SKILL.md),
  [pre-push-gates](../../skills/pre-push-gates/SKILL.md),
  [self-improvement](../../skills/self-improvement/SKILL.md).

## Done

A DRAFT `feat(chat)` PR against `llm` implementing the inventory `+` create menu:
the top-placed button + menu, the working filesystem-mount create flow, the
new-agent wizard's in-phase layers, and the documented placeholders for the rest —
locally verified (button renders, menu opens, filesystem create works). The `tada`
report links the PR, states what is live vs placeholder for UAT, and names any
design gap hit. This build is the thing the maintainer will user-acceptance-test,
so the report should tell them exactly which flows are ready to exercise.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  claimed_at: 2026-07-10T20:58:33Z
