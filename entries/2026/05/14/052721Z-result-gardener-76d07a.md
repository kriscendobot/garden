---
ts: 2026-05-14T05:27:21Z
kind: result
role: gardener
project: garden
refs:
  - entries/2026/05/14/050355Z-dispatch-liaison-76d07a.md
---

# Result: jury-judge redesign and merged-PR feedback watch landed

Fifteen commits on `main` (8f3c690..0b271fc). The maintainer's four directives are encoded in the role/skill library; the next orchestrator dispatch reads the new flow.

## Juror-seat list and panel-size rationale

Six seats total (five named jurors plus the existing saboteur):

- **assessor**: correctness, types, control flow, performance / complexity. Primary technical-substance reviewer.
- **stylist**: naming, diff hygiene, changeset content. Catches conflated autofix and gratuitous renames.
- **archivist**: docs, regression evidence, comment / JSDoc accuracy. Verifies new tests are load-bearing.
- **curator**: API stability, public surface, backwards compatibility. Catches bump-level mismatches and peer-dep cascade.
- **locksmith**: security, capabilities, attenuation, SES boundary. Catches capability grants in seemingly-innocent diffs.
- **saboteur** (retained): adversarial inputs, invariant attacks. Walks the brainstorming list.

Each seat has a primary inquiry area plus a secondary overlap so every named inquiry area (correctness/types, API stability, naming/diff/changeset, docs/regression evidence, security/capabilities, adversarial/invariants, performance/complexity) is touched by at least two seats. Performance/complexity is folded into the assessor (and overlapped by the curator on public-API hot paths) rather than a seventh seat.

**Size rationale**: four or five seats would force one seat to carry two unrelated areas; seven or more dilutes focus per seat. Six is the smallest panel that touches every area twice with one primary per area. The maintainer named 3-6 as the negotiable range; six is the upper bound and lands on the "more than once, wide variety" framing.

## Files added or substantially revised

- `roles/judge/AGENT.md` (new): the panel's foreperson; dispatches the six jurors, aggregates, submits, un-drafts.
- `roles/assessor/AGENT.md` (new): jury seat.
- `roles/stylist/AGENT.md` (new): jury seat.
- `roles/archivist/AGENT.md` (new): jury seat.
- `roles/curator/AGENT.md` (new): jury seat.
- `roles/locksmith/AGENT.md` (new): jury seat.
- `skills/merged-pr-feedback-watch/SKILL.md` (new): the gardener's standing duty.
- `roles/saboteur/AGENT.md` (revised): re-aligned with judge-aggregated panel composition.
- `roles/cleaner/AGENT.md` (revised): stands between builder and jury; no longer un-drafts.
- `roles/liaison/AGENT.md` (revised): PR-creation-flow chaining norm rewritten for new flow; active-set list updated.
- `roles/steward/AGENT.md` (revised): subordinate-roles list and the per-cycle PR-creation-flow scan rewritten.
- `roles/gardener/AGENT.md` (revised): cites the merged-pr-feedback-watch skill; new Standing duties section.
- `roles/builder/AGENT.md`, `roles/assayer/AGENT.md`, `roles/evaluator/AGENT.md`, `roles/fixer/AGENT.md` (revised): un-draft-authority references updated from cleaner to judge; re-dispatch wording updated.
- `roles/designer/AGENT.md`, `roles/investigator/AGENT.md`, `roles/scout/AGENT.md` (touched): incidental "juror" references reworded to "jury seat".
- `skills/pr-creation-flow/SKILL.md` (revised): flow diagram, cleaner placement, jury composition, jury-fixer loop, next-stage-owed heuristic, pitfalls, notes-from-the-field. Substantially rewritten.
- `skills/panel-review/SKILL.md` (revised): default composition now six seats; the judge aggregates and submits (replacing the prior "juror is the panel-side editor" wording).
- `skills/adversarial-tests/SKILL.md`, `skills/coverage-driven-testing/SKILL.md`, `skills/garden-ab-evaluation/SKILL.md`, `skills/reactji-acknowledgment/SKILL.md`, `skills/worktree-per-pr/SKILL.md` (touched): incidental "juror" references reworded; `garden-ab-evaluation` Step 2 acknowledges historical-arm vs current-flow distinction.
- `CLAUDE.md` (revised): inventory bump.
- `roles/juror/AGENT.md` (removed): replaced by the five named seats.

## New flow ASCII diagram

```
builder (opens draft PR)
   |
   |  in concert (default), or before, or after
   v
assayer  --pushes tests to same branch
   |
   v
cleaner (coverage pass; dead-code; same branch)
   |
   |  cleaner pushes coverage commits, watches CI converge
   v
judge (foreperson; dispatches the jury panel)
   |
   |  judge runs six juror dispatches + gh pr edit --add-reviewer @copilot
   v
jury panel verdict (judge aggregates, submits formal gh pr review)
   |
   |  if must-fix items, the orchestrator dispatches a fixer
   v
fixer --pushes follow-up commits
   |
   v
judge re-dispatches the same panel against the fixer's head
   |
   |  loop until the panel surfaces no further in-scope must-fix
   v
gh pr ready <N>  (judge un-drafts; PR enters maintainer's review queue)
```

## Orchestrator behavior

The next orchestrator dispatch (in-session liaison or per-cycle steward) reads `skills/pr-creation-flow/SKILL.md` and dispatches **builder → cleaner → judge → fixer-loop**, with the judge dispatching the six-seat panel internally; un-draft authority sits with the judge.

## Merged-PR watch cadence

**Proposed cadence: weekly** (every 7 days). The threshold for landing a rule is "appeared in 2+ merged PRs in the window", which requires the window to be long enough that the typical merge volume yields duplicates; weekly is the shortest cadence that gives a typical week's volume of merged PRs on `endojs/endo-but-for-bots` plus `endojs/endo` enough density to surface recurring themes. Faster (e.g., daily) risks landing rules on single-sample observations; slower (e.g., monthly) lets feedback patterns age before they become structural. An out-of-cadence pass is warranted on a release-prep burst or unusual post-merge feedback density.

## Contradiction sweep

Read `pr-creation-flow` plus the named-juror files and the surrounding library; found four contradictions (builder, assayer, evaluator, fixer all claimed cleaner-un-drafts or orchestrator-re-dispatches-jury) and the `garden-ab-evaluation` skill referenced "the cleaner has un-drafted the PR" in two places. All resolved in commit `0b271fc`. No remaining contradictions in the active library between the new role/skill files and the surrounding ones.

Self-improvement: `roles/gardener/AGENT.md`, `skills/merged-pr-feedback-watch/SKILL.md`; encoded the merged-PR watch as a standing duty with a documented cadence and threshold, so the next gardener dispatch starts from the procedure rather than re-deriving it.
