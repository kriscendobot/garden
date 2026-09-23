---
ts: 2026-06-16T00:40:00Z
kind: dispatch
role: steward
host: endolinbot
to: gardener
dispatch_root: /home/kris/dispatches/gardener--633f85
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/5
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/15/213500Z-result-fixer-ba72cd.md
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/15/230109Z-result-fixer-cb7a05.md
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/16/001258Z-result-fixer-cc9bb5.md
---

# dispatch: gardener — codify CI-OODA-loop so drive-to-green doesn't stall between cycles

User directive (kriskowal on garden, 2026-06-16T00:39Z):

> For https://github.com/kriscendobot/agoric-sdk/pull/5, there is a
> pattern that I have had to manually request continued progress after
> CI settled, rather than being able to rely on the subagent
> responsible for that work to notice that CI has settled and continue
> the next stage of work. Please dispatch a gardener to fix the loop
> and keep it going until CI is passing all tests. There is a pattern
> of needing to reclassify all failed jobs, watch for progress and
> regression, observe, orient, decide, and act.

## The gap (observed pattern)

On PR #5 (kriscendobot/agoric-sdk mirror of upstream #12527), the
maintainer has had to issue repeated directives to drive CI to green:

1. `20:55Z` "Please address the remaining issues … guarded type mismatches"
2. `22:45Z` "Please classify the remaining CI failures and dispatch a subagent to address each of these classes, serially"
3. `23:55Z` "CI has settled. Please reclassify remaining failures and serially dispatch subagents …"

Each step required the maintainer to:

- Notice CI had settled.
- Re-prompt the steward to reclassify.
- Re-prompt the steward to dispatch a fixer.

The garden's existing roles (steward, shepherd, fixer) handle ONE class per dispatch. The steward's autonomous loop pings on a fixed cadence but does NOT do the OODA cycle (Observe CI state → Orient via classification → Decide on next class → Act via fixer dispatch) without a maintainer poke.

## What the user wants

A garden-level fix that closes the loop: after a fixer addresses one class and CI re-runs, the steward (or a new role) AUTONOMOUSLY:

1. **Observes**: polls / waits-for-completion on CI for the target PR's latest head.
2. **Orients**: classifies remaining failures (per the pattern fixer cb7a05 + retry cc9bb5 established):
   - Expected failures (skip).
   - Structural impasses requiring maintainer decision (surface, don't dispatch).
   - Real failures with tractable fix paths (queue for fixer).
   - Regressions (failures that were green and went red — flag urgently).
3. **Decides**: picks the next-most-tractable real failure or surfaces the impasse when only impasses remain.
4. **Acts**: dispatches the next fixer with the right brief.

The loop continues until all non-expected/non-impasse classes are green OR until only maintainer-decision-required classes remain.

## Task

In your `garden/` worktree:

1. Read prior steward, shepherd, fixer roles for the existing CI-watching pattern and the dispatch contract.
2. Read prior result entries for the PR #5 work (linked above) to ground the codification in the actual pattern that worked.
3. Choose the shape of the fix:
   - **Option A**: a new skill (e.g., `skills/ci-ooda-loop/SKILL.md`) the steward + shepherd + fixer all reference, naming the OODA cycle, the classification rubric (expected / impasse / tractable / regression), and the auto-continue norm.
   - **Option B**: extend `roles/shepherd/AGENT.md` § Drive-to-green to include the loop pattern (since shepherd already handles CI-watching).
   - **Option C**: a new role (e.g., `roles/ci-loop/AGENT.md`) that owns the drive-to-green loop and dispatches fixers per class.
   - **Option D**: extend the steward's autonomous loop to do the CI-watch + classify + dispatch-fixer chain when a "drive-to-green" tag is present on a PR.
   - Choose based on the codification minimum that closes the loop; favor a skill over a new role if a skill suffices.
4. Write the skill / role / norm update.
5. Update the appropriate index files (`CLAUDE.md` skill list, role list, etc.).
6. Land the change on `main` (push directly per garden convention).

## Authorizations

- Push to garden's `main` (per CLAUDE.md: "No PR workflows for the garden's own repo").
- Write new skill or extend existing role.
- Update CLAUDE.md indices.

## Out of scope

- Do NOT modify PR #5 or any project work directly (this is the meta-garden fix).
- Do NOT dispatch a fixer on PR #5 (that's the steward's job under the new loop).

## Deliverable

A `result` entry under `journal/entries/2026/06/16/` naming:

- The shape chosen (option A/B/C/D + rationale).
- The new/modified file paths.
- The change summary.
- How a future steward/shepherd uses the codification.
- A `Self-improvement: ...` line.
- Optional: a recommended next step for THIS PR #5 to demonstrate the new loop in action.

End your turn with a concise summary back to the orchestrator.
