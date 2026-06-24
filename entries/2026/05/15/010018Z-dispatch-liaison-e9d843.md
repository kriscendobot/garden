---
ts: 2026-05-15T01:00:18Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
refs:
  - entries/2026/05/15/005358Z-result-groom-9cfd4e.md
---

# Dispatch: groom extracts M½ (Milestone-one-half) and absorbs the project-hygiene work

Dispatch root: `dispatches/groom--e9d843/`. Project worktree on `endojs/endo-but-for-bots@llm` (the roadmap lives at `designs/README.md`).

Maintainer directive (2026-05-15): *"Please extract M½ and absorb the project hygiene work."* This acts on the open question the prior groom (`9cfd4e`) surfaced in [`005358Z-result-groom-9cfd4e.md`](005358Z-result-groom-9cfd4e.md): *"M1 is absorbing increasingly out-of-scope hygiene work (build-system, diagnostics). Should an M0.5 hygiene bucket exist?"* The user's answer is **yes**; create M½ and move the hygiene-shaped items out of M1.

## Per-action authorization

Standing on endo-but-for-bots: push the roadmap edit to `llm`.

## What "M½" looks like

A new milestone bin between M0 (foundation) and M1 (remote access + coding capabilities). The "½" notation (Milestone one-half, fractional) signals it's a *prerequisite hygiene* bin — work that has to land for M1 to proceed cleanly, but that isn't user-facing capability development. The groom picks the exact heading text (e.g., `### Milestone ½: Project Hygiene` or `### Milestone ½: Build, Tests, and Tooling Hygiene` — pick what reads cleanest in the section's existing pattern).

## What to move

The groom identifies hygiene-shaped designs currently in M1 and moves them to M½. Candidates from the prior groom's report:

- `break-dev-dependency-cycles` — explicitly named.
- Build-system designs (e.g., `turbo-cache-mode`, `npm-lifecycle-disabled-ci` if classified to M1).
- Diagnostic / CI / workflow-resilience designs (e.g., `guix-ci-resilience`, the new `package-uniformity` if landed and classified to M1).
- Any other design whose substance is "make the build/test/CI fleet healthier" rather than "ship a new capability the user can run".

The groom decides the final list using two-question criteria:
1. Does the design ship user-facing capability? If no, candidate for M½.
2. Is the design a prerequisite for M1 capability work? If yes, M½ is the right home (it's prereq-shaped). If neither user-facing nor M1-prereq, the design may actually belong elsewhere (M2+ or stand-alone); flag it.

## Task

1. **Read** `roles/groom/AGENT.md`, the current `designs/README.md` (specifically the Milestones section + Per-Design Estimates table), and the prior groom's result entry (`005358Z`).

2. **Insert M½ section** in the Milestones structure between M0 and M1. The section's body: one-paragraph framing + a short list of the moved designs.

3. **Update the Per-Design Estimates table** to move the identified hygiene rows from M1 to M½ (the milestone column changes; the rest of each row stays).

4. **Update the summary-table counts** if any totals depend on milestone classification.

5. **Update the cumulative roadmap projection** if M½ has a non-trivial effort estimate that shifts cumulative weeks.

6. **Update the dependency graph** if any M½ → M1 edges need reflecting (the hygiene work is often a prerequisite; the graph should show that).

7. **Do not retroactively reclassify the journalist's bulletin output** — the journalist reads the Per-Design Estimates table on its next cycle and re-bins automatically. No action needed here.

8. **Note in the result entry** if any "neither user-facing nor M1-prereq" design surfaces; that's an out-of-scope flag for the maintainer.

## Out of scope

- No new design authoring.
- No PR for the roadmap edit (groom commits directly to llm per project convention).
- No retroactive close of PR #236 (which was the per-design endo-gateway raise; the groom's prior pass noted that needs separate per-action authorization, which this dispatch does not extend).

## Commits

- One commit on llm for the roadmap edit. Commit message: `groom(designs): extract Milestone ½ for project-hygiene work`.

Push at end. Journal result entry.

## Report

≤ 400 words: the M½ section's heading text (one line), the moved-row list (one line per design), the new M½/M1/cumulative effort numbers, any out-of-scope flags, one-line `Self-improvement: ...`.
