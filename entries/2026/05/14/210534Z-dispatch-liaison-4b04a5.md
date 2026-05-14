---
ts: 2026-05-14T21:05:34Z
kind: dispatch
role: liaison
project: garden
to: "*"
---

# Dispatch: gardener encodes "the gamut" vocabulary for steward + liaison

Dispatch root: `dispatches/gardener--4b04a5/`. Garden-meta only.

## Maintainer directive

2026-05-14: *"I would like the steward's role to recognize that 'the gamut' means the PR end-to-end workflow. For example, 'Run the gamut' in the context of a PR should be understood to mean resume the workflow until done. The liaison should recognize 'Run the gamut on #xxx' to mean the same on a specific PR."*

## Semantics to encode

- **"The gamut"** in the context of a PR = the full PR-creation-flow chain: builder → cleaner → judge (dispatches 12-seat code panel or 5-seat design panel per PR shape) → fixer-loop (judge re-dispatches the panel after each fixer round until the loop terminates) → judge un-drafts.
- **"Run the gamut"** = resume the chain from wherever it currently sits, until the loop terminates and the PR is un-drafted (or, if it is a design-only PR, until the design panel reports done and the judge un-drafts).
- **"Run the gamut on #N"** (liaison-shape) = the orchestrator targets PR #N specifically: read its current state via the next-stage-owed heuristic in `skills/pr-creation-flow/SKILL.md`, and dispatch that next stage; on the role's return, dispatch the subsequent stage; iterate until the chain terminates. The orchestrator does this in one engagement (multiple sequential dispatches, one liaison/steward turn).

## Per-action authorization

Standing on the garden repo. No project-side actions.

## Task

1. **Read** `roles/COMMON.md`, `roles/steward/AGENT.md`, `roles/liaison/AGENT.md`, `skills/pr-creation-flow/SKILL.md` § Orchestrator chaining is load-bearing.

2. **Add a vocabulary section to both `roles/steward/AGENT.md` and `roles/liaison/AGENT.md`.** A reasonable place is at the top of *Operating norms* (or near the section that already describes the chaining responsibility). Each role file gets a one-paragraph section explaining the gamut vocabulary in that role's voice:
   - The steward's version: a per-cycle scan that finds the next stage owed for any garden-authored draft PR is *running the gamut* on the open set; an inbox `message: liaison → steward` that says "run the gamut on PR #N" means rate-limit the per-cycle scan onto that specific PR and chase the chain to termination within the current cycle.
   - The liaison's version: "run the gamut on #N" in a user prompt means dispatch the next-owed stage, await its result, dispatch the subsequent stage, and so on, until the chain terminates. The liaison's gamut respects the same next-stage-owed heuristic the steward uses.

3. **Carve out clearly that "the gamut" does NOT mean**:
   - "Bypass the chain's discipline" (the cleaner still runs before the jury; the judge still runs the panel; the fixer-loop still iterates until in-scope must-fix items are clear).
   - "Skip review" (the maintainer's review still happens after un-draft; "the gamut" terminates at the cleaner-un-draft / judge-un-draft boundary).
   - "Auto-merge" (the conductor is a separate role; "the gamut" stops at ready-for-review).

4. **Update `skills/pr-creation-flow/SKILL.md`** with a short subsection (or a notes-from-the-field row) introducing "the gamut" as a synonym for the canonical chain. The flow's procedure does not change; only the vocabulary is added. Cite the maintainer's framing 2026-05-14 as the precipitating evidence.

5. **Update `CLAUDE.md`** § Dispatch contract or wherever the orchestrator's standing vocabulary lives — a one-line glossary entry: *"the gamut: the PR-creation-flow chain end to end (`skills/pr-creation-flow/SKILL.md`). 'Run the gamut on #N' = orchestrator dispatches the chain's stages sequentially until termination."*

## Out of scope

- No edit to the chain itself (`skills/pr-creation-flow/SKILL.md`'s flow ordering, jury composition, etc.).
- No new role.
- No project-side actions.

## Commits

- One commit per substantively-revised role file (steward, liaison).
- One commit for the skill + CLAUDE.md updates.

Push at end. Journal result entry.

## Report

≤ 200 words: files updated, the vocabulary-section shape one-liner per role file, one-line `Self-improvement: ...`.
