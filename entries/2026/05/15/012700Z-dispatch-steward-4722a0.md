---
ts: 2026-05-15T01:27:00Z
kind: dispatch
role: steward
project: garden
to: "*"
refs:
  - https://github.com/kriskowal/garden/issues/2
  - entries/2026/05/14/222100Z-result-gardener-7d4081.md
---

# Dispatch: journalist populates the *Unstarted designs* bulletin section (per garden #2)

Dispatch root: `dispatches/journalist--4722a0/`. Garden-meta only (no project worktree).

## The directive

Maintainer at 01:25Z: "Please survey the issues on the garden repository. I have been expecting responses on them."

Garden issue #2 (verbatim body): *"Please add a section on unstarted designs to the bulletin"* (kriskowal, 2026-05-14, 0 comments).

The bulletin already carries an *Unstarted designs* section as a placeholder block (`<!-- BEGIN unstarted-designs -->` ... `<!-- END unstarted-designs -->`) introduced by commit `09b84e8`. The placeholder text reads "rendering deferred to the steward's design-to-PR pipeline once the gardener `7d4081` lands". `7d4081` has landed (skill `design-to-pr-pipeline` at `skills/design-to-pr-pipeline/SKILL.md`); the steward exercised it twice tonight (PRs #254 and #256). Time to populate.

## Per-action authorization

- Edit `journal/README.md` between the `BEGIN unstarted-designs` / `END unstarted-designs` markers only.
- Push to `origin/journal` directly per garden convention (no PR for the garden's own repo).
- Post a closing comment on `kriskowal/garden#2` after the population lands, noting the bulletin is now live and the steward will keep it fresh on subsequent design-to-PR cycles.
- Close issue #2 if the body's request is satisfied by the population (it is — the request was to add the section).

## Task

1. **Run the design-to-PR inventory** per `skills/design-to-pr-pipeline/SKILL.md` § *Procedure* (steps 1-3) against `endojs/endo-but-for-bots@llm`. Compute the uncovered set (designs lacking a load-bearing tracking PR on the canonical path). Sort newest-first by the design's last-modified timestamp on the roadmap branch.

2. **Render the bulletin section**. The replacement block goes between the existing markers in `journal/README.md`. Suggested shape (journalist's call):

    - A one-paragraph header naming the inventory date, the source project (`endojs/endo-but-for-bots@llm`), and the total uncovered count.
    - A table or bullet list of the top-N uncovered designs (10-20 entries; not the whole 50+) with canonical path, design slug, last-modified date, and a one-line summary.
    - A footer pointing at `skills/design-to-pr-pipeline/SKILL.md` for the inventory rule and at the recent steward dispatches (#254, #256) as exemplars.

3. **Reply on garden #2** with a one-paragraph status: bulletin section is now populated; the steward refreshes it on each design-to-PR cycle; close-eligible if the maintainer agrees the request is fulfilled. The journalist closes the issue with a one-line comment after the maintainer's implicit assent (which is the same engagement; no need to wait).

## Coverage rule (strict)

A design counts as covered if any open or merged PR has a load-bearing reference (canonical path, not just slug) on its title, body, or commit messages. Closed-not-merged does not cover; merged design-PRs (head branch `design/<slug>`) do not cover — those are landings of the design, not tracking PRs for implementation.

The steward's iter-1 (#254) and iter-2 (#256) builders codified the rule in practice; the journalist's inventory follows the same strict interpretation.

## Out of scope

- No edit to other bulletin sections.
- No edit to design documents themselves.
- No dispatch of further builders; this dispatch only populates the bulletin and closes the issue.
- No edit to the design-to-PR pipeline skill.

## Commits

- One commit on `journal` branch: `bulletin: populate Unstarted designs section per garden #2`.
- Push at end.

## Report

≤ 350 words: total uncovered count, the top-3 designs in the rendered list (slug + last-modified date), the comment-then-close action on garden #2, and one-line `Self-improvement: ...`.
