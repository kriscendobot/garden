---
ts: 2026-05-15T03:47:00Z
kind: dispatch
role: liaison
project: garden
to: "*"
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/138#pullrequestreview-3438488467
  - entries/2026/05/15/034700Z-dispatch-liaison-4a8df9.md
---

# Dispatch: gardener encodes "attempt design to reveal gaps" skill + orchestrator verb

Dispatch root: `dispatches/gardener--c9ded6/`. Garden-only (no project worktree).

Maintainer directive (2026-05-15, on #138): *"This kind of feedback has been a pretty common so please ask the gardener to create a skill and give a verb to the liaison for invoking it."*

The companion builder dispatch (`builder--4a8df9`) runs the pattern in parallel against #138 — its dispatch entry is the working example to draw from.

## Goal

Encode the recurring pattern: *dispatch a builder to attempt implementing a tentative or speculative design, with the primary deliverable being a structured inventory of gaps (ambiguities, contradictions, under-specified seams), rather than a polished mergeable PR*.

## Pattern (drawn from today's #138 dispatch + prior examples)

The maintainer has used this pattern multiple times recently. Recognizable shape:

- A design PR exists (or a design document lives somewhere) and has tentative / draft status.
- The maintainer wants to know whether the design holds up under contact with code, without committing to merging the implementation.
- The valuable output is an enumerated **gap report**, not a feature.
- The implementation PR (if opened) stays DRAFT and exists primarily as the artifact carrying the gap report.

This differs from a normal builder dispatch:
- Normal builder: produce a mergeable PR. Stop only on hard blockers.
- Gap-reveal builder: stop at *every* ambiguity, document it, propose resolutions, do not guess.

The judge / cleaner / un-draft loop does not apply (PR stays draft pending design revision).

## Task

1. **Author `skills/<slug>/SKILL.md`.** Suggested slugs (gardener picks the best): `gap-revealing-build`, `design-stress-test`, `tentative-design-probe`, `attempt-to-reveal-gaps`. Sections per the garden convention: purpose, inputs, procedure, output shape, notes. The procedure section enumerates the "stop at every ambiguity" discipline, the structured gap-entry shape (where in design / verbatim quote / what's needed / candidate resolutions), and the PR-body sections (`## Gaps surfaced`, `## Skeleton implemented`, `## Skeleton not implemented`, `## Recommendations to design author`).

2. **Add a verb to both orchestrator vocabulary tables** (`roles/liaison/AGENT.md` § Vocabulary and `roles/steward/AGENT.md` § Vocabulary if applicable). Suggested verbs (gardener picks): **"probe #N"**, **"prototype #N"**, **"stress-test design #N"**, **"vet #N"**. Note the verb's distinct semantics vs **"build #N"** (which produces a mergeable PR). Update the glossary in CLAUDE.md if you add a row to the orchestrator-shared table.

3. **Reference the skill from `roles/builder/AGENT.md`** under skills, with a one-line note that the builder consults this skill *only* when the orchestrator's dispatch invokes the new verb (not on normal `build #N` dispatches).

4. **The dispatch flow on the new verb**:
   - Liaison or steward reads the design PR's branch head as the dispatch base (stacked PR; design must merge first if the implementation lands).
   - Builder reads design fully, attempts skeleton, stops at every ambiguity, opens DRAFT PR with structured gap report in the body.
   - Builder reports back to orchestrator with PR URL + gap count.
   - Orchestrator posts to bulletin.
   - **No judge, no cleaner, no un-draft.** The PR is a discussion artifact, not a feature; the maintainer reads the gap report and revises the design.

5. **Surface in the bulletin's "Recent engagements" once landed.** The maintainer asked for the post to bulletin specifically.

6. **Self-improvement at the end** per `skills/self-improvement/SKILL.md`.

## Per-action authorization

Standing on garden's main + journal branches: push to `main` after the encoded changes pass `git diff --check` and the skill file conforms to garden convention. Push to `journal` for the result entry.

## Out of scope

- No code on `endojs/endo-but-for-bots`. (The companion builder dispatch handles that.)
- No PR on the garden repo (per CLAUDE.md § Conventions: garden pushes direct, no self-PRs).
- No comment on #138.

## Report

≤ 300 words: skill file path + slug, verb(s) chosen, orchestrator-vocabulary rows added (liaison + steward + glossary), builder role update line, one-line `Self-improvement: ...`. The liaison posts the new verb on the bulletin once the encoding lands.
