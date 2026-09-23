---
ts: 2026-05-14T19:54:32Z
kind: dispatch
role: liaison
project: garden
to: "*"
---

# Dispatch: gardener encodes new designer policy — open PR as draft against llm

Dispatch root: `dispatches/gardener--3159ab/`. Garden-meta only.

## The directive

Maintainer (2026-05-14, after the TLA + import-attributes designers landed): *"The designer should in general open pull requests against the llm branch when producing a draft."*

This supersedes the prior `roles/designer/AGENT.md` operating norm:

> The designer does not commit, push, or open PRs by default. The output is the file. A later builder or fixer dispatch takes it from there. When a brief overrides this and asks the designer to also open the PR, the branch carrying the design must be rooted at the project's natural base, never on a garden-meta branch.

The new default for projects with a bot-fork llm-style branch (today: only `endojs/endo-but-for-bots` has the llm shape; future bots-forks of other projects may grow similar branches): the designer opens a draft PR against `llm` (or the project's equivalent branch). The file lands in the project's `designs/` directory on a `design/<slug>` branch. The boatman ferries upstream later if and when the maintainer authorizes.

For projects without an llm-style branch (e.g., upstream `endojs/endo`, `Agoric/agoric-sdk`): the prior "no commits, output is the file" default still applies. The new default does not require a project the bot has no draft-stage on.

## Per-action authorization

Standing on the garden repo. No project-side actions.

## Task

1. **Read** `roles/COMMON.md`, `roles/designer/AGENT.md`, `roles/gardener/AGENT.md`, `roles/boatman/AGENT.md` (to verify the boatman picks up from a draft PR on llm correctly), `roles/builder/AGENT.md` (for the builder's draft-flow norm — designers now share that draft-flow shape), `skills/pr-creation-flow/SKILL.md` § Flow ordering (the designer is not in the PR-creation chain, but the draft-discipline section applies).

2. **Update `roles/designer/AGENT.md`** § Operating norms with the new default:
   - Replace the "does not commit, push, or open PRs by default" bullet with a "produces a draft PR against the project's bot-fork roadmap branch (`llm` on `endojs/endo-but-for-bots`)" default.
   - Document the per-project default: when the project has a bot-fork-roadmap branch in `projects/<slug>/README.md` (or wherever the bot-fork branch is named), the designer opens the PR against that branch. When not, the prior "output is the file" default applies.
   - Note that the draft state is the load-bearing signal that this is *design* not *implementation* — the cleaner / judge / jury chain does not engage on `kind: design` PRs. (Verify with `skills/pr-creation-flow/SKILL.md`; if needed, add a one-line carve-out there.)
   - The branch carrying the design: `design/<slug>` (the existing role file already says this; no change there).
   - Cite the maintainer's framing 2026-05-14 in a notes-from-the-field row.

3. **Update the per-project README convention.** Either `roles/COMMON.md` § Project-fork conventions (if it has one) or a new section. The bot-fork-roadmap-branch name (`llm` for `endo-but-for-bots`; `roadmap`, `bots-main`, etc. for hypothetical future projects) should live in `journal/projects/<slug>/README.md` § Default branches. For `endojs/endo-but-for-bots`, the value is `llm`; record it there if not already.

4. **Audit the existing `roles/builder/AGENT.md`** for the analogous default (it should already say "opens a draft PR" per the new PR-creation-flow). The designer's new default mirrors the builder's; if they read in parallel, do they say the same thing in the same shape? If not, align.

5. **Update `skills/pr-creation-flow/SKILL.md` § Flow ordering or a sibling section** if the designer is now in the draft-PR shape: the cleaner / judge chain does NOT engage on design-only PRs (no source changes to test or panel-review). State this explicitly so the steward's per-cycle scan doesn't dispatch a cleaner against a design PR.

6. **Update the dispatch template in `CLAUDE.md`** if it has any example phrasing that conflicts (likely not; the template is generic).

## Out of scope

- No edits to existing in-flight design PRs (e.g., the ones the liaison is about to land manually).
- No re-author of the designer role's procedure beyond the default-shape change.
- No new role.

## Commits

- One commit per substantively-revised file (`roles/designer/AGENT.md`, possibly `skills/pr-creation-flow/SKILL.md`, possibly `roles/COMMON.md`, possibly `journal/projects/endo-but-for-bots/README.md`).

Push at end. Journal result entry.

## Report

≤ 300 words: files updated (one line each), one-line confirmation that the next designer dispatch (against a project with an llm branch) opens a draft PR by default, one-line `Self-improvement: ...`.
