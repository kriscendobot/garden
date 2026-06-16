---
created: 2026-06-16
updated: 2026-06-16
author: gardener
---

# Skill: ci-failure-classification-loop

The orchestrator-side OODA loop that drives a red-CI PR to green (or to a clean impasse) without per-cycle re-prompting from the maintainer. The orchestrator observes the current CI rollup, orients by classifying each failing job into one of four classes, decides which class is next, and acts by dispatching the appropriate role. After each dispatch returns and a new CI cycle settles, the orchestrator re-observes and repeats.

The skill is the orchestrator's counterpart to the shepherd's *"pursue all tests passing in CI by whatever means necessary until reaching an impasse or success"* discipline (`roles/shepherd/AGENT.md` § Operating norms). The shepherd's discipline applies inside a single dispatch; this skill is what keeps the *chain of dispatches* going across CI cycles without the orchestrator stopping at every red rollup to ask the maintainer "what next?"

## When to use

- A PR is open with a non-empty set of failing CI jobs.
- A prior fixer or shepherd has pushed; CI has just settled or is about to settle.
- The maintainer has said "drive this to green" (or any of its synonyms in the vocabulary tables) and not since rescinded.
- The PR is one whose merging the orchestrator already owns (a steward-owned PR, a liaison-tracked gamut, a driver-lane PR after the lane terminated). The skill is not appropriate for PRs whose CI is the maintainer's responsibility to read.

Do **not** use the loop when the PR's branch is `CONFLICTING` / dirty (no CI runs will dispatch; route to the weaver per `roles/shepherd/AGENT.md` § Conflicting PRs block CI dispatch). Do **not** use it when every remaining failure is already classified as expected or as a structural impasse the maintainer must decide; the loop terminates there.

## Inputs

- `pr`: PR number and `repo` (`owner/name`).
- `prior_classification`: the last classification table produced for this PR, if any. Read from the most recent `result` entry for this PR's fixer or shepherd chain. Used to detect regressions.
- `authority`: the orchestrator-staged authorizations to push to the PR branch, re-request review, and post a top-level summary comment. Without these the fixer dispatched at step *Act* cannot complete; surface the missing authorization to the maintainer rather than dispatch the fixer with a noop.

## The OODA cycle

The loop has four phases. Each cycle of the loop runs all four; the loop iterates until a termination condition fires.

### 1. Observe: read the current CI rollup

Read the PR's current head SHA and statusCheckRollup using [`pr-ci-watch`](../pr-ci-watch/SKILL.md) (single tick, no monitor arming) or [`ci-status-summary`](../ci-status-summary/SKILL.md) (cross-PR sweep variant). Enumerate every failing job with its name and link.

Drill into each failing job's logs only enough to identify the failure signature (the error message, the failing test name, the assertion shape, the exit code). The orientation step does the classification; the observation step just gathers the evidence.

If the rollup is still in progress (`pending > 0`), do not classify yet. Either schedule the next tick per `autonomous-loop-pacing/SKILL.md` (active mode) or, for an in-session liaison, wait for the rollup to settle before the next phase.

### 2. Orient: classify every failing job into one of four classes

Each failing job is assigned exactly one class. The classes are mutually exclusive at orientation time, but a job may move across classes between cycles as evidence accumulates.

#### Class A: Expected failure (skip)

The failure has been authorized by the maintainer as expected for this PR or for this branch. Documentation jobs that fail because the documented dapp pins a different endo version. Tests that fail because the change deliberately invalidates a downstream assumption that another PR will fix. The orchestrator does not dispatch against expected failures; they remain visible in the rollup but do not block the loop's termination.

Evidence required: an explicit maintainer directive on this PR (a comment, an inline review, a `message` entry to the steward) naming the failing job as expected. Without that evidence, do not classify as expected; default to *Real failure* and let the fixer surface the gap.

Worked example: on `kriscendobot/agoric-sdk#5` the `test-dapp (node-new)` job was authorized as expected fail by kriskowal at 2026-06-15T20:55:07Z because the documentation dapp's endo pin lagged the PR's endo-sync. See `entries/2026/06/15/213500Z-result-fixer-ba72cd.md`.

#### Class B: Structural impasse needing maintainer decision (surface)

The failure has a real cause whose fix is beyond the fixer's scope: a public-API rewrite, a workspace-structure change, a decision that affects other PRs or shipped artifacts, a known issue that needs the maintainer's verdict on workaround strategy. The orchestrator surfaces these impasses (a top-level PR comment with the per-class summary, or a bulletin row under *Awaits maintainer decision*) and does not dispatch a fixer against them.

Evidence: the failure root cause is identified and the fix path is documented, but the fix path is *not* one the fixer or shepherd is authorized to take. The classification is most reliable when a prior fixer dispatch reached the same conclusion and the recommended-next-stage was a maintainer-decision name.

Worked example: on `kriscendobot/agoric-sdk#5` the `test-fast-usdc-deploy (node-old/new)` jobs failed because SES 2.x cannot deserialize fast-usdc-beta-1 bundles written under SES 1.x; the fix is a maintainer decision about the released-bundle migration strategy. See `entries/2026/06/15/230109Z-result-fixer-cb7a05.md` § Class E.

#### Class C: Real failure with a tractable fix path (queue for fixer)

The failure has a real cause and the fix is within a fixer's scope (a code change inside the PR's own diff, a dep-pin update, a missing test fixture, a workaround for a transitive interaction the fixer can apply). The orchestrator dispatches a fixer against this class. When multiple jobs in this class share a likely root cause, group them into one fixer dispatch; the dispatch brief names the class.

The dispatch carries the failure inventory the *Observe* step produced and the orientation hypothesis from this step. The fixer is not bound to the hypothesis; if its own diagnosis differs, it follows the diagnosis. The hypothesis is a starting point, not a contract.

Worked examples on `kriscendobot/agoric-sdk#5`:

- `multichain-testing imports.test.ts` `null == true`: dual-AVA-install in the lockfile (fixer cc9bb5 diagnosis after cb7a05's SES-pin work resolved a parallel root cause).
- `async-flow LogStore` type-check residue: `@ts-expect-error` directives at the call sites (fixer ba72cd).

#### Class D: Regression (flag urgently)

A previously-green check (or a previously-classified-as-expected check) has flipped to red in the current cycle. This is *not* a normal class C failure; it is a signal that the chain just regressed and the fixer's most recent push (or a base-branch update) likely introduced it. The orchestrator dispatches a fixer immediately, citing the regression explicitly so the fixer treats the most recent diff as the prime suspect.

A regression is detected by comparing the current classification to `prior_classification`. A job whose name was absent from the prior failing set or was classified as A (expected) or as silent-green and is now red is a regression. The detection happens at orientation; it is not a separate phase.

Worked example: none in the PR #5 chain so far, but the regression class is the OODA loop's circuit breaker. The maintainer's framing on 2026-06-16: *"Regressions (failures that were green and went red, flag urgently)."*

### 3. Decide: pick the next class to dispatch

Decision rules, in order:

1. **If Class D (regression) is non-empty**, dispatch a fixer against the regression first. Regressions are the loop's most diagnostic signal: they identify which recent change broke what was working, and resolving them often unblocks downstream classes.
2. **Else if Class C is non-empty**, dispatch a fixer against the largest coherent C subset. The maintainer's framing on PR #5: *"dispatch a subagent to address each of these classes, serially."* The fixer addresses one coherent root cause per dispatch; the next cycle picks up whatever C subset remains.
3. **Else if only A (expected) and B (structural impasse) remain**, the loop terminates. The orchestrator posts a *Loop termination* comment per *Termination conditions* below and stops dispatching.
4. **Else if every class is empty** (the rollup is green), the loop terminates on success.

Class B failures are never dispatched against from this loop; their resolution requires a maintainer decision out of the loop. Class A failures are never dispatched against by definition.

When the same C class persists across two consecutive cycles with no progress (the fixer's push did not change the failure signature), promote the class to B (structural impasse) on the third cycle and surface to the maintainer. A fixer that cannot make progress in two attempts has discovered a deeper problem; do not iterate further.

### 4. Act: dispatch the role chosen in Decide

For Class C or Class D, dispatch a fixer (per `roles/fixer/AGENT.md`). The dispatch brief:

- Names the PR and head SHA.
- Inlines the classification table from this cycle, with the targeted class flagged as the dispatch's scope.
- Cites the most recent prior fixer `result` entry (so the fixer can read the full diagnosis without re-grepping) and the orientation hypothesis from this cycle.
- Carries the per-action authorizations already staged on the bulletin (push to the PR branch, post a top-level summary comment, re-request review after CI is green). When the loop is the steward's autonomous form, these come from the original maintainer directive that opened the loop; when the loop is the liaison's in-session form, the liaison stages them explicitly.

Once the fixer returns, write the cycle's `result` entry with the classification table and the dispatched class; this becomes the next cycle's `prior_classification`.

Then loop back to *Observe* once the next CI cycle settles. For an autonomous steward, this means scheduling the next tick with active-mode pacing (`autonomous-loop-pacing/SKILL.md`). For an in-session liaison, this means watching the rollup and re-entering the cycle when it settles.

## Termination conditions

The loop terminates when one of these is true at the end of *Decide*:

- **Green.** Every check is `SUCCESS` (or `NEUTRAL` / `SKIPPED`). The orchestrator records the green-run URL, re-requests maintainer review (or dispatches the conductor for merge per the gamut), and stops.
- **Only A and B remain.** Every remaining red is either expected (A) or a structural impasse (B). The orchestrator posts a top-level PR summary enumerating each remaining failure by class with a one-paragraph reason and a recommended next step (maintainer decision needed, accept as expected, defer to follow-up PR). The orchestrator stops dispatching; the bulletin's *Awaits maintainer decision* section captures the B-class items until the maintainer's verdict.
- **No-progress detection.** A Class C cluster has persisted across two consecutive fixer dispatches with the failure signature unchanged. Promote to B and surface as above; do not iterate.
- **Authorization gap.** The orchestrator does not hold the per-action authorization the next fixer dispatch needs. Surface the gap; do not dispatch.

The loop does **not** terminate just because the orchestrator is uncertain about classification. Uncertainty defaults to Class C (real failure, tractable), which dispatches the fixer; the fixer's diagnosis is the authoritative classification refinement. The loop's termination is reserved for evidence-backed cases.

## Regression detection in detail

Regressions are the OODA loop's circuit breaker; getting their detection right is what makes the loop safe to run autonomously.

For each failing job in the current cycle, compare to `prior_classification`:

- **Was the job's check name present in the prior cycle's rollup as `SUCCESS`?** Then it has regressed. Flag as Class D.
- **Was the job classified as A (expected) in the prior cycle?** Then either the expectation was wrong (it was actually green and is now red) or the maintainer authorization no longer applies. Re-read the authorization. If still valid and the job is now red for a different signature, the new signature is a regression; flag as D. If the authorization still applies and the signature is unchanged, keep at A.
- **Was the job classified as B (structural impasse) in the prior cycle with the same signature?** Then it is still B; no regression.
- **Was the job classified as C in the prior cycle?** Then the fixer did not yet resolve it. Compare signatures: if identical, this is the no-progress case (count toward the two-cycle promotion to B). If the signature changed, the fixer made partial progress and uncovered a new layer; keep at C and dispatch again.
- **Was the job's check name absent from the prior cycle entirely?** It is new. Most commonly this is a new check that registered downstream of a now-passing prerequisite (per `pr-ci-watch/SKILL.md` § Notes from the field: rollups grow during a run). Classify per the usual rules; do not assume regression unless evidence points to one.

When a regression is flagged, the dispatch brief explicitly names it as a regression and cites the most recent commit(s) since the prior classification. The fixer reads this as a strong hint that the recent diff is the prime suspect.

## Composition

- **With the shepherd.** The shepherd's own dispatch carries the discipline *"pursue all tests passing in CI by whatever means necessary"* inside one dispatch. This skill's loop wraps multiple such dispatches (typically fixers, sometimes a shepherd when CI itself needs investigation) across CI cycles. A shepherd dispatched mid-loop is just one *Act* step; its return feeds the next *Observe*.
- **With the auto-pickup chain.** The steward's *Shepherd → fixer* chain (`roles/steward/AGENT.md` § Auto-pickup chains) is the chain's first hop: shepherd returns with `next: fixer`, steward dispatches the fixer without re-asking. This skill is the *standing form* of the same principle: every cycle's fixer return implicitly carries `next: fixer` (or `next: none` on green termination), and the steward continues without re-asking until a termination condition fires.
- **With the per-cycle procedure.** A steward in its per-cycle scan encounters a PR that is mid-loop: check the most recent `result` entry for the PR; if it carries a classification table and the loop is not terminated, this skill is the per-cycle action for that PR. The skill replaces the otherwise-default "stop and wait for maintainer direction" behavior for PRs the maintainer has explicitly delegated to the loop.
- **With the gamut.** A PR running the gamut (`roles/steward/AGENT.md` § Vocabulary: the gamut) that hits red CI between gamut stages enters this loop until CI is green again; the gamut resumes on the next cycle. The loop is the gamut's CI-side subroutine.

## Output shape

Each cycle's `result` entry records:

```markdown
## Classification (cycle <N>, head <sha>)

| Class | Job | Signature | Disposition |
| --- | --- | --- | --- |
| A | test-dapp (node-new) | docs dapp endo skew | skip (maintainer-authorized 2026-06-15) |
| B | test-fast-usdc-deploy | SES 1.x bundle deser | surface (maintainer decision) |
| C | multichain-testing imports | dual-AVA install | dispatch fixer this cycle |
| D | (none) | | |

## Dispatched

- fixer against Class C, brief at `entries/<...>/dispatch-fixer-<short-id>.md`

## Termination

- Loop continues; next observe after fixer returns and CI settles.
```

On termination, the entry adds a *Termination* block naming the condition (green / A+B only / no-progress / authorization gap) and the orchestrator's next step (re-request review / surface to maintainer / dispatch conductor / etc.).

## Notes from the field

- _2026-06-16_: this skill was authored by gardener dispatch `633f85` per kriskowal's directive on `kriscendobot/agoric-sdk#5`: *"on PR #5 he had to manually re-prompt the steward 3 times to reclassify CI failures + dispatch the next fixer."* The classification rubric (A expected, B structural impasse, C tractable, D regression) is distilled from the successful chain of fixer dispatches `ba72cd`, `cb7a05`, `cc9bb5` on that PR. The loop's purpose is to close the seam where the orchestrator stopped at each red rollup to re-ask the maintainer "what next?". The maintainer's authority to dispatch the next fixer is implicit in the original "drive this to green" directive and remains in force until the loop terminates.
