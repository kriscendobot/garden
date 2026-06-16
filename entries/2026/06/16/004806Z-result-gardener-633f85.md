---
ts: 2026-06-16T00:48:06Z
kind: result
role: gardener
refs:
  - entries/2026/06/16/004000Z-dispatch-gardener-633f85.md
  - entries/2026/06/15/213500Z-result-fixer-ba72cd.md
  - entries/2026/06/15/230109Z-result-fixer-cb7a05.md
  - entries/2026/06/16/001258Z-result-fixer-cc9bb5.md
---

# Gardener: close the drive-to-green seam across CI cycles

Per kriskowal directive 2026-06-16T00:39Z on `kriscendobot/agoric-sdk#5`:
he had to manually re-prompt the steward three times to reclassify
remaining CI failures and dispatch the next fixer. The seam to close:
make the orchestrator run the OODA loop (Observe CI, Orient via
classification, Decide on next class, Act via fixer dispatch)
autonomously until green or only maintainer-decision impasses remain.

## Shape chosen: Option A, new skill

The new skill is `skills/ci-failure-classification-loop/SKILL.md`. Rationale:

- The classification rubric (A expected, B structural impasse, C tractable,
  D regression) and the OODA loop wrapping it are reusable across orchestrator
  postures (steward autonomous, liaison in-session) and well-scoped procedural
  content. That maps to a skill, not a role.
- A new role would be redundant: the role surface is already shepherd (CI to
  green inside one dispatch) and steward (orchestrator-side across dispatches).
  The gap is procedural: there was no canonical playbook for "classify,
  dispatch fixer, observe next CI cycle, reclassify, repeat."
- Extending the shepherd would conflate "CI to green by pushing fixes itself
  inside one dispatch" (the 2026-06-14 *pursue all tests passing by whatever
  means necessary* discipline) with "CI to green by chaining successive fixers
  across CI cycles" (the loop). They are adjacent but distinct disciplines;
  collapsing them into one role file would muddy the shepherd's brief.
- Extending the steward's per-cycle procedure is appropriate as a citation
  pointing to the skill, but the meat is procedure. The skill is the right
  container.

## Files changed

Two commits on garden main, both pushed.

Commit `d106a613` (`ci-failure-classification-loop: close the drive-to-green
seam across CI cycles`):

- `skills/ci-failure-classification-loop/SKILL.md` (new, 164 lines): the OODA
  loop's *Observe / Orient / Decide / Act* phases; the four-class
  classification rubric with worked examples drawn from the PR #5 fixer chain;
  the regression-detection logic; the four termination conditions; the
  output-shape table the cycle's `result` entry uses.
- `roles/steward/AGENT.md` (+13 lines): new sub-section *Fixer to fixer (CI
  failure classification loop)* under § Auto-pickup chains, citing the skill
  as the standing form of the shepherd-to-fixer chain; notes-from-the-field
  row cites the PR #5 precipitating chain.
- `roles/shepherd/AGENT.md` (+3 lines): cross-reference under § Skills so the
  shepherd's escalation-class vocabulary aligns with the loop's rubric.
- `CLAUDE.md` (+1 token): inventory adds the new skill.

Commit `893b5e2e` (`ci-failure-classification-loop: remove em-dashes per
em-dash-style rule`): style fixup; replaces em-dashes in section headings with
colons and rewrites two prose em-dashes as periods or commas. Pure style; no
semantic change.

## How a future steward or shepherd uses the codification

The steward's per-cycle scan, on encountering a PR mid-loop (the most recent
`result` entry for the PR carries a classification table and no termination
block), reads the new skill and:

1. Observes the current CI rollup via `pr-ci-watch` or `ci-status-summary`.
2. Orients each failing job into A / B / C / D using the rubric. Compares
   against the prior classification to detect regressions.
3. Decides per the rule: D first, then C, terminate on A+B-only or green or
   no-progress or authorization gap.
4. Acts by dispatching the fixer with the targeted class scoped in the brief
   and the prior fixer `result` cited.

The steward's existing *Shepherd to fixer* auto-pickup chain handles the
first hop (shepherd returns with `next: fixer`); the new skill handles every
subsequent hop without re-prompt, under the original maintainer directive's
implicit authority. The shepherd itself is now cross-referenced to the skill
so a shepherd that ends mid-loop classifies its failures using the same
vocabulary the loop reads.

## Recommended next step for PR #5 demo

The most recent fixer (`cc9bb5`) returned with `next: fixer` and a
classification matching the skill's rubric:

- Class A: `test-dapp (node-new)` (expected per maintainer directive).
- Class B: `test-fast-usdc-deploy` (SES 1.x bundle deserialization, awaits
  maintainer decision).
- Class C: needs observation on the next CI cycle to verify whether
  `46b5491dec`'s dual-AVA fix resolves the multichain-testing imports test
  and whether the cosmic-swingset SIGHUP transitively cleared.

The liaison (or steward on its next cycle) can demo the loop by:

1. Observing the current rollup on the post-`46b5491dec` head.
2. Orienting: if Class C is empty, the loop terminates with A+B-only, surface
   to maintainer for Class B verdict. If Class C is non-empty, dispatch the
   next fixer against it.
3. The dispatch brief cites the new skill so the loop's traceability surfaces
   in the journal.

This would be a clean first run of the codified loop on a real PR with a
known good chain.

## Out-of-scope items respected

- No modification to PR #5 or any project code.
- No fixer dispatched on PR #5 from this engagement.

Self-improvement: the dispatch root's garden worktree has an automated commit
hook that lands edits without an explicit `git commit`, then auto-pushes to
`origin/main`. The em-dash style violation in the first auto-committed
version (HEAD `d106a613`) reached origin before I had a chance to sweep.
Going forward, gardeners writing new skill or role files should run the
em-dash sweep (`grep -P "\xe2\x80\x94"`) *before* the first save, not after,
to avoid the second cleanup commit. A pre-push style gate on garden's main
would catch this class of slip; that proposal is in scope for a future
gardener dispatch but out of scope here.
