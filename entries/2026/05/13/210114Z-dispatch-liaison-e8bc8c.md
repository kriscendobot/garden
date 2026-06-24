---
ts: 2026-05-13T21:01:14Z
kind: dispatch
role: liaison
project: garden
to: "*"
---

# Dispatch: gardener reworks the PR creation flow (draft discipline + assayer + jury loop)

Dispatch root: `dispatches/gardener--pr-creation-flow-rework--20260513-210114--e8bc8c/`. Substantial design pass; the gardener has done multi-role engagements of this size before.

The maintainer's framing:

> Establish a rule that the builder opens new PRs in draft state and only takes them out of draft when the cleaner (the last of the roles to automatically touch a fresh PR) gets the PR to pass in CI. At that point it should have gone through the builder, jury including the saboteur, and the cleaner. It may make sense to carve out a separate tester role (the assayer) that either works before, after, or in concert with the builder. Perhaps also, the jury and fixer should loop until the jury finds no further complaints that are in scope for the work.

## Tasks

### A. Port four roles from `references/endo-but-for-bots/`

Standard port shape: `references/endo-but-for-bots/roles/<name>.md` → `roles/<name>/AGENT.md` with frontmatter, em-dash sweep, path translations, "adopted from references/" note. Pull in cited skills similarly; reuse aggressively.

- `builder` — implements a change from an issue or spec; gets it through CI.
- `cleaner` — maximize coverage on a target package; write tests or delete unreachable code.
- `juror` — conduct a review of a PR, alone or as part of a panel.
- `saboteur` — propose gotcha test cases that attack a module's claimed invariants.

### B. Create a new `assayer` role

The maintainer suggested it as a "tester" role that works before, after, or in concert with the builder. Define the role:

- Purpose (one line): author tests for a change before, after, or alongside the builder, increasing coverage and catching regressions earlier than the cleaner.
- When dispatched: by the steward as part of the PR-creation flow (see task C); by an in-session liaison when the maintainer asks for tests on a specific change.
- Authority bounds: edits tests and test fixtures only; does not edit production code. Does not move PRs out of draft (that is the cleaner's privilege).
- Skills: cite the existing testing skills the active library carries (e.g. `regression-evidence`, `coverage-driven-testing` if ported; otherwise port the reference's `coverage-driven-testing` skill alongside).

Distinguish the assayer from the cleaner: the assayer authors tests for *this PR's change*; the cleaner increases coverage on the *target package as a whole* and is the final pass before un-drafting.

### C. New skill `skills/pr-creation-flow/SKILL.md`

The canonical procedure that ties the per-PR roles together. Substantive content:

- **Draft discipline.** Builder opens PRs in draft state. The PR leaves draft only when the cleaner has passed CI.
- **Flow ordering.** builder (or assayer + builder concurrently) → jury (which dispatches at least one juror + the saboteur as panel members) → fixer if the jury finds in-scope complaints → re-jury (loop) → cleaner → un-draft when CI passes.
- **Jury-fixer loop.** The jury reviews the PR. If the jury surfaces in-scope complaints, the fixer addresses them. The jury re-reviews. Loop until the jury surfaces no further in-scope complaints. Out-of-scope complaints are surfaced as separate issues or follow-up PRs, not as blocking-this-loop comments.
- **Assayer placement.** The assayer may run before the builder (TDD-style: tests first), after the builder (regression coverage), or in concert (alongside). Default: in concert. The skill documents the trade-offs but does not mandate one ordering.
- **Cleaner placement.** Last role to automatically touch the PR. Confirms CI green; un-drafts; signals the maintainer.
- **State on the PR.** Use draft state + PR labels to encode flow position: `state:building`, `state:in-review`, `state:fixing`, `state:cleaning`, `state:ready`. The labels are advisory; draft vs ready-for-review is the load-bearing flag.
- **Maintainer entry point.** The maintainer reviews only PRs that are out of draft. Before un-drafting, the flow's internal review (jury + saboteur + builder + cleaner) is the quality bar.

### D. Update existing role files

- `roles/builder/AGENT.md` (after port in task A): add the **draft-on-open** norm prominently. Cite `skills/pr-creation-flow/SKILL.md`.
- `roles/fixer/AGENT.md`: add a norm naming the jury-fixer loop and that the fixer should be re-dispatched by the steward until the jury declares no further in-scope complaints.
- `roles/cleaner/AGENT.md` (after port in task A): add the **un-draft authority** norm prominently — the cleaner is the only role that moves a PR out of draft, and only after CI is green.

### E. Inventory and steward subordinate-roles

- `CLAUDE.md` § Current inventory: add `builder`, `cleaner`, `juror`, `saboteur`, `assayer` to Roles.
- `roles/steward/AGENT.md` § Subordinate roles dispatched: add each with its dispatch trigger. The jury (juror + saboteur panel) and the loop discipline get a short standalone bullet rather than scattering across each role's individual entry.

### F. Bulletin awareness

Add a one-line bulletin note (in `journal/README.md` under *Awaits maintainer decision* or a comparable existing section): "PR-creation flow reworked; first builder/assayer/jury/cleaner dispatches will land when the maintainer next asks for work on a specific PR." Self-clearing on the first such dispatch.

## Out of scope

- Do NOT run the new roles for any first engagement; this is meta-evolution only.
- Do NOT touch the groom + Gateway dispatch (concurrent).
- Do NOT touch the journalist bulletin-order rule (concurrent gardener dispatch).
- Do NOT alter `roles/{liaison,steward,monitor,review-queue,boatman,fixer,weaver,shepherd,conductor,designer,scout,botanist,major-general,journalist,librarian,scholar,timekeeper,gardener,groom}/AGENT.md` beyond what task D specifies.

## Style and discipline

Em-dash sweep; frontmatter; relative paths; context-library rules for any new directory you create. Do not invoke `Agent`. Use journal-sync retry-on-rejection on push.

## Commits

Suggested split on `main` (your call on the exact slicing):

- A1: builder + cleaner ports.
- A2: juror + saboteur ports.
- B: assayer role + cited skills.
- C: pr-creation-flow skill.
- D: builder/fixer/cleaner norms updated for the new flow.
- E: inventory + steward subordinates.

Suggested commit on `journal`:
- F: bulletin note.
- Result entry.

## Return

≤ 600 words: files written grouped by task A–F, commit SHAs (main + journal), the assayer/builder ordering you defaulted to, the jury-panel composition (juror + saboteur as a fixed pair vs configurable), the labels you chose (or that you used draft-state only), self-improvement.
