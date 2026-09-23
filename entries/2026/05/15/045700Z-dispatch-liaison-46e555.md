---
ts: 2026-05-15T04:57:00Z
kind: dispatch
role: liaison
project: garden
to: "*"
refs:
  - entries/2026/05/15/045000Z-dispatch-liaison-fa2b1e.md
---

# Dispatch: gardener carves four reviewer-modeled juror seats (Miller, Gibson, Warner, Hofman) by extracting PR-feedback patterns

Dispatch root: `dispatches/gardener--46e555/`. Garden-only (no project worktree). Concurrent with `gardener--fa2b1e` (Hickey + interface critic) — independent work.

Maintainer directive (2026-05-15): *"Please also dispatch the gardener to create a reviewer modeled on Mark S. Miller (erights), based on patterns of Pull Request feedback from endojs/endo and agoric/agoric-sdk. While you're there, do the same for a Richard Gibson, Brian Warner, and Mathieu Hofman. Change names to protect the innocent."*

## The four reviewers

| GitHub | Real name | Affiliation |
|---|---|---|
| `@erights` | Mark S. Miller | Endo / Agoric — TC39 / ocap foundational |
| `@gibson042` | Richard Gibson | Endo / Agoric — ECMAScript spec / Temporal |
| `@warner` | Brian Warner | Endo — capability / OCapN / Tahoe-LAFS lineage |
| `@mhofman` | Mathieu Hofman | Agoric — XS / liveslots / swingset performance |

**"Change names to protect the innocent."** The seat slug names *the lens*, not the reviewer. The reviewer's name and GitHub handle are cited in the role file's frontmatter or introductory paragraph (as the empirical source for the lens), but the seat itself reads as a property — e.g., not `miller`, but a slug that names what the seat *does*.

## Pattern-extraction methodology

For each of the four reviewers:

1. **Sample their recent PR feedback.** Use `gh` to fetch comments and reviews authored by the reviewer in `endojs/endo` and `Agoric/agoric-sdk`. Suggested:
   ```sh
   gh search prs --reviewer <login> --repo endojs/endo --limit 50 --state all
   gh api 'search/issues?q=commenter:<login>+repo:endojs/endo+is:pr&per_page=50'
   gh search prs --reviewer <login> --repo Agoric/agoric-sdk --limit 50 --state all
   gh api 'search/issues?q=commenter:<login>+repo:Agoric/agoric-sdk+is:pr&per_page=50'
   ```
   Or equivalently `gh api repos/<owner>/<repo>/pulls/comments?per_page=100` filtered to the user.
2. **Read 10–30 of their review-thread comments per repo.** Look for recurring patterns: phrase-templates they reach for, categories of concern they consistently raise, blind spots they consistently flag in others' code.
3. **Distill the lens into a few load-bearing dimensions** the seat will walk on every dispatch. The lens should be NARROW enough to be distinguishable from existing juror seats (`assessor`, `typist`, `stylist`, `packager`, `archivist`, `prover`, `curator`, `migrator`, `locksmith`, `warden`, `saboteur`, `breaker` for code; `critic`, `skeptic`, `copyeditor`, `pedant`, `novice` for design; plus whatever the companion `gardener--fa2b1e` dispatch lands today).

4. **Pick a descriptive slug.** Some priors per reviewer (use as starting points; the empirical pattern wins):

   - **@erights / Mark Miller** — ocap purity, hardening discipline, frozen prototypes, "is this passable?", "could this be a covert channel?", capability minimization, vat-boundary thinking, classical-mode-vs-attenuator framings. Slug candidates: `ocapist`, `purist`, `hardener`, `attenuator`, `vat-thinker`, `passable-watcher`.
   - **@gibson042 / Richard Gibson** — ECMAScript spec rigor, brittle-test resistance, less-coupling, edge-case enumeration, Temporal proposal expertise, "this presumes a particular pattern of consumption that is not required" (verbatim from his r3245918820 today). Slug candidates: `spec-keeper`, `rigorist`, `coupling-watcher`, `tightener`, `proof-broadener`.
   - **@warner / Brian Warner** — cryptography correctness, OCapN / CapTP protocol details, capability discipline at the wire boundary, security-property thinking, Tahoe-LAFS lineage of capability-coordination patterns. Slug candidates: `cryptographer`, `wire-watcher`, `protocol-prover`, `capability-wire-watcher`.
   - **@mhofman / Mathieu Hofman** — V8/XS performance, vat membrane semantics, swingset internals, liveslots, virtual-objects vs ephemeral, allocation budget thinking, "what does the GC see?". Slug candidates: `perf-eyes`, `membrane-watcher`, `engine-realist`, `liveslots-watcher`.

   Pick whichever fits the empirical pattern. Document the rationale in the role file's introductory paragraph and the result entry.

## Task

Read `garden/roles/COMMON.md`, then walk the existing juror role files to learn the standard shape (see the companion dispatch `045000Z-dispatch-liaison-fa2b1e.md` for the suggested model files).

For each of the four reviewers:

1. **Sample the empirical PR-feedback corpus** per the methodology above. Budget ~10–15 minutes per reviewer; the goal is pattern recognition, not exhaustive read.

2. **Distill the lens** into 4–8 distinguishing categories. Each category gets a one-sentence definition that a different agent could walk.

3. **Author `garden/roles/<slug>/AGENT.md`** with the standard juror shape:
   - Frontmatter (created today, author=gardener).
   - One-paragraph purpose: primary surface (the lens) + secondary overlap with the adjacent existing seat(s).
   - **Empirical-source note**: a one-line attribution naming the GitHub handle whose feedback corpus the lens was extracted from. This is the "change names to protect the innocent" pivot: the SEAT'S identity is the lens; the reviewer is the *empirical source*.
   - "When to enter this role" (default panel + maintainer direct dispatch).
   - Skills section (COMMON, worktree-per-pr, panel-review, pr-creation-flow, em-dash-style, relative-paths, self-improvement).
   - Operating norms: primary surface walked, secondary surface (overlap slice), verdict criteria, ≤400 words discipline, "submit per-juror block as a `result` journal entry."
   - External-repo etiquette: does not post directly.
   - Definition of done.

4. **Decide panel assignment.** Most of these lenses (Miller, Warner) primarily apply to CODE (the code panel grows from 12 to 13+). Some (Gibson's spec-rigor lens, Hofman's perf lens) also fit code. None are primarily design-panel-only. Surface your assignments.

5. **Cross-check no slug collision** with the existing 17+ jury seats and whatever the companion gardener `fa2b1e` adds. Coordinate by reading `fa2b1e`'s result entry if it lands before yours; otherwise pick slugs that obviously don't collide.

6. **Update `garden/skills/pr-creation-flow/SKILL.md`** § Jury composition: add the new seats with one-line each. Update panel sizes.

7. **Update `garden/CLAUDE.md`** § Current inventory: add the four new role slugs. Update the jury-seat tally. Add a one-line history bullet preserving the 2026-05-15 expansion (the maintainer-modeled-juror milestone is notable for the inventory's narrative).

8. **Update `garden/roles/judge/AGENT.md`** § Panel-kind discrimination if relevant.

9. **Write the result entry** at `journal/entries/2026/05/15/<ts>-result-gardener-46e555.md`:
   - Four slug choices + panel assignments.
   - For each: the 4–8 distinguishing categories that comprise the lens, with the GitHub handle that sourced them.
   - File list edited.
   - One-line `Self-improvement: ...`.

10. **Commit + push both branches** (main + journal). No self-PR per garden conventions.

## Per-action authorization

Standing on garden's main + journal. READ-ONLY on `endojs/endo` and `Agoric/agoric-sdk` (the data sources). No comment on any PR.

## Out of scope

- No code on any project repo.
- No comment on any PR.
- No interaction with the four reviewers themselves; this is observation of their public PR feedback only.
- No probe of any active dispatch.

## Report

≤ 500 words: four slug choices + panel assignments + one-sentence rationale each, citing the empirical source. File list edited. Note any collision with `fa2b1e`'s output. One-line `Self-improvement: ...`. The liaison surfaces the four seats on the bulletin once both gardener dispatches land.
