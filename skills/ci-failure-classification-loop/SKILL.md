---
created: 2026-06-16
updated: 2026-06-24
author: gardener
---

# Skill: ci-failure-classification-loop

The supervisor-side OODA loop that drives a red-CI PR to green (or to a clean
impasse) without per-cycle re-prompting from the maintainer. The supervising
gardener observes the current CI rollup, orients by classifying each failing job
into one of four classes, decides which class is next, and acts by queuing the
appropriate fixer step. After each step settles a new CI cycle, the loop
re-observes and repeats. This is the v2 form of v1's orchestrator OODA loop:
where v1 had the steward re-prompt itself across CI cycles, v2 has the gardening
state machine emit a `loop` signal that the supervising gardener reacts to (see
[gardening-state-machine](../../designs/gardening-state-machine.md)).

The skill is the gardener's standing form of the shepherd discipline (*"pursue
all tests passing in CI by whatever means necessary until reaching an impasse or
success"*). The shepherd step applies inside a single CI-shepherding pass; this
skill keeps the *chain of passes* going across CI cycles without stopping at every
red rollup to ask the maintainer "what next?"

## When to use

- A PR is open with a non-empty set of failing CI jobs.
- A prior fixer or shepherd step has pushed; CI has just settled or is about to.
- The maintainer has said "drive this to green" (or any synonym) and not since
  rescinded.
- The PR is one whose merging the garden already owns (a gardener-claimed job, a
  PR running the gauntlet). The skill is not appropriate for PRs whose CI is the
  maintainer's responsibility to read.

Do **not** use the loop when the PR's branch is `CONFLICTING` / dirty (no CI runs
will dispatch; route to a rebase/weave job). Do **not** use it when every
remaining failure is already classified as expected or as a structural impasse the
maintainer must decide; the loop terminates there.

## Inputs

- `pr`: PR number and `repo` (`owner/name`).
- `prior_classification`: the last classification table produced for this PR, if
  any. Read from the PR's most recent fixer/shepherd `progress` journal entry or
  the gardening run dir. Used to detect regressions.
- `authority`: the staged authorizations to push to the PR branch, re-request
  review, and post a top-level summary comment. Without these the fixer step
  cannot complete; surface the missing authorization to the maintainer (message
  bus) rather than run a no-op.

## The OODA cycle

The loop has four phases. Each cycle runs all four; the loop iterates until a
termination condition fires.

### 1. Observe: read the current CI rollup

Read the PR's current head SHA and statusCheckRollup using
[pr-ci-watch](../pr-ci-watch/SKILL.md) (single
tick) or [ci-status-summary] (cross-PR sweep variant). Enumerate every failing job
with its name and link.

Drill into each failing job's logs only enough to identify the failure signature
(the error message, the failing test name, the assertion shape, the exit code).
The orientation step does the classification; the observation step just gathers
evidence.

If the rollup is still in progress (`pending > 0`), do not classify yet. Wait for
the rollup to settle (the gardening script's loop decision waits on CI) before the
next phase.

### 2. Orient: classify every failing job into one of four classes

Each failing job is assigned exactly one class. The classes are mutually
exclusive at orientation time, but a job may move across classes between cycles as
evidence accumulates.

#### Class A: Expected failure (skip)

The failure has been authorized by the maintainer as expected for this PR or
branch. Documentation jobs that fail because the documented dapp pins a different
endo version. Tests that fail because the change deliberately invalidates a
downstream assumption another PR will fix. The loop does not act against expected
failures; they stay visible in the rollup but do not block termination.

Evidence required: an explicit maintainer directive on this PR (a comment, an
inline review, a bus message) naming the failing job as expected. Without that
evidence, do not classify as expected; default to *Real failure* and let the fixer
step surface the gap.

Worked example: on `kriscendobot/agoric-sdk#5` the `test-dapp (node-new)` job was
authorized as expected fail by kriskowal because the documentation dapp's endo pin
lagged the PR's endo-sync.

#### Class B: Structural impasse needing maintainer decision (surface)

The failure has a real cause whose fix is beyond the fixer step's scope: a
public-API rewrite, a workspace-structure change, a decision affecting other PRs
or shipped artifacts, a known issue needing the maintainer's verdict on workaround
strategy. The loop surfaces these (a top-level PR comment with the per-class
summary, or a bus message to the maintainer) and does not queue a fixer against
them.

Evidence: the failure root cause is identified and the fix path is documented, but
the fix path is *not* one the fixer step is authorized to take. Most reliable when
a prior fixer pass reached the same conclusion and recommended a maintainer
decision.

Worked example: on `kriscendobot/agoric-sdk#5` the `test-fast-usdc-deploy` jobs
failed because SES 2.x cannot deserialize fast-usdc-beta-1 bundles written under
SES 1.x; the fix is a maintainer decision about the released-bundle migration
strategy.

#### Class C: Real failure with a tractable fix path (queue a fixer step)

The failure has a real cause and the fix is within the fixer step's scope (a code
change inside the PR's own diff, a dep-pin update, a missing test fixture, a
workaround for a transitive interaction). The loop queues a fixer step against
this class. When multiple jobs in this class share a likely root cause, group them
into one fixer pass; the pass brief names the class.

The fixer step carries the failure inventory the *Observe* step produced and the
orientation hypothesis. The fixer is not bound to the hypothesis; if its own
diagnosis differs, it follows the diagnosis. The hypothesis is a starting point,
not a contract.

Worked examples on `kriscendobot/agoric-sdk#5`: `multichain-testing imports.test.ts`
`null == true` (dual-AVA-install in the lockfile); `async-flow LogStore` type-check
residue (`@ts-expect-error` directives at the call sites).

#### Class D: Regression (flag urgently)

A previously-green check (or a previously-classified-as-expected check) has
flipped to red in the current cycle. This is *not* a normal Class C failure; it
signals that the chain just regressed and the most recent push (or a base-branch
update) likely introduced it. The loop queues a fixer step immediately, citing the
regression explicitly so the fixer treats the most recent diff as the prime
suspect.

A regression is detected by comparing the current classification to
`prior_classification`. A job whose name was absent from the prior failing set or
was classified as A (expected) or as silent-green and is now red is a regression.
Detection happens at orientation; it is not a separate phase.

The maintainer's framing on 2026-06-16: *"Regressions (failures that were green
and went red, flag urgently)."*

### 3. Decide: pick the next class

Decision rules, in order:

1. **If Class D (regression) is non-empty**, queue a fixer step against the
   regression first. Regressions are the loop's most diagnostic signal: they
   identify which recent change broke what was working, and resolving them often
   unblocks downstream classes.
2. **Else if Class C is non-empty**, queue a fixer step against the largest
   coherent C subset. The fixer addresses one coherent root cause per pass; the
   next cycle picks up whatever C subset remains.
3. **Else if only A (expected) and B (structural impasse) remain**, the loop
   terminates. Post a *Loop termination* comment per *Termination conditions* and
   stop queuing.
4. **Else if every class is empty** (the rollup is green), the loop terminates on
   success.

Class B failures are never queued against from this loop; their resolution
requires a maintainer decision out of the loop. Class A failures are never queued
against by definition.

When the same C class persists across two consecutive cycles with no progress (the
fixer push did not change the failure signature), promote the class to B
(structural impasse) on the third cycle and surface to the maintainer. A fixer that
cannot make progress in two attempts has discovered a deeper problem; do not
iterate further.

### 4. Act: run the fixer step chosen in Decide

For Class C or Class D, run the fixer step (per the gardening state machine's fixer
stage / [fixer]). The step brief:

- Names the PR and head SHA.
- Inlines the classification table from this cycle, with the targeted class
  flagged as the step's scope.
- Cites the most recent prior fixer `progress`/run record (so the fixer can read
  the full diagnosis without re-grepping) and this cycle's orientation hypothesis.
- Carries the per-action authorizations already staged (push to the PR branch,
  post a top-level summary comment, re-request review after CI is green). These
  come from the original maintainer directive that opened the loop.

Once the fixer step returns, record the cycle's classification table in the
gardening run dir / a `progress` entry; this becomes the next cycle's
`prior_classification`.

Then loop back to *Observe* once the next CI cycle settles. The gardening state
machine's loop decision (`decide "loop or stop?"`) is what emits the `loop` signal
to the supervising gardener; the supervisor re-enters the cycle when CI settles
rather than re-prompting itself or the maintainer.

## Termination conditions

The loop terminates when one of these is true at the end of *Decide*:

- **Green.** Every check is `SUCCESS` (or `NEUTRAL` / `SKIPPED`). Record the
  green-run URL, re-request maintainer review (or queue the merge step per the
  gauntlet), and stop.
- **Only A and B remain.** Every remaining red is either expected (A) or a
  structural impasse (B). Post a top-level PR summary enumerating each remaining
  failure by class with a one-paragraph reason and a recommended next step
  (maintainer decision needed, accept as expected, defer to follow-up PR). Stop
  queuing; surface the B-class items to the maintainer via the bus.
- **No-progress detection.** A Class C cluster has persisted across two
  consecutive fixer passes with the failure signature unchanged. Promote to B and
  surface as above; do not iterate.
- **Authorization gap.** The supervisor does not hold the per-action authorization
  the next fixer step needs. Surface the gap; do not run the step.

The loop does **not** terminate just because classification is uncertain.
Uncertainty defaults to Class C (real failure, tractable), which queues the fixer;
the fixer's diagnosis is the authoritative refinement. Termination is reserved for
evidence-backed cases.

## Regression detection in detail

Regressions are the loop's circuit breaker; getting their detection right is what
makes the loop safe to run autonomously.

For each failing job in the current cycle, compare to `prior_classification`:

- **Was the job's check name present in the prior cycle's rollup as `SUCCESS`?**
  Then it regressed. Flag as Class D.
- **Was the job classified as A (expected) in the prior cycle?** Then either the
  expectation was wrong or the authorization no longer applies. Re-read the
  authorization. If still valid and the job is now red for a different signature,
  the new signature is a regression; flag as D. If the authorization still applies
  and the signature is unchanged, keep at A.
- **Was the job classified as B (structural impasse) with the same signature?**
  Still B; no regression.
- **Was the job classified as C in the prior cycle?** The fixer did not yet
  resolve it. Compare signatures: if identical, this is the no-progress case (count
  toward the two-cycle promotion to B). If the signature changed, the fixer made
  partial progress and uncovered a new layer; keep at C and run again.
- **Was the job's check name absent from the prior cycle entirely?** It is new.
  Most commonly a new check that registered downstream of a now-passing
  prerequisite (rollups grow during a run). Classify per the usual rules; do not
  assume regression unless evidence points to one.

When a regression is flagged, the step brief explicitly names it as a regression
and cites the most recent commit(s) since the prior classification. The fixer reads
this as a strong hint that the recent diff is the prime suspect.

## Composition

- **With the shepherd step.** The shepherd step carries the *"pursue all tests
  passing by whatever means necessary"* discipline inside one pass. This loop wraps
  multiple such passes (typically fixers, sometimes a shepherd pass when CI itself
  needs investigation) across CI cycles. A shepherd pass mid-loop is just one *Act*
  step; its return feeds the next *Observe*.
- **With the auto-escalation chain.** A shepherd step that returns "out of scope,
  fixer-fixable" auto-escalates to a fixer step without re-asking the maintainer;
  this loop is the standing form of the same principle: every cycle's fixer return
  implicitly carries `next: fixer` (or `next: none` on green termination), and the
  supervisor continues until a termination condition fires.
- **With the gauntlet.** A PR running the gauntlet that hits red CI between stages
  enters this loop until CI is green again; the gauntlet resumes on the next cycle.
  The loop is the gauntlet's CI-side subroutine.

## Output shape

Each cycle records (in the gardening run dir or a `progress` entry):

```markdown
## Classification (cycle <N>, head <sha>)

| Class | Job | Signature | Disposition |
| --- | --- | --- | --- |
| A | test-dapp (node-new) | docs dapp endo skew | skip (maintainer-authorized) |
| B | test-fast-usdc-deploy | SES 1.x bundle deser | surface (maintainer decision) |
| C | multichain-testing imports | dual-AVA install | fixer step this cycle |
| D | (none) | | |

## Acted

- fixer step against Class C

## Termination

- Loop continues; next observe after the fixer step returns and CI settles.
```

On termination, add a *Termination* block naming the condition (green / A+B only /
no-progress / authorization gap) and the next step (re-request review / surface to
maintainer / queue merge step / etc.).

## Notes from the field

- _2026-06-16_: authored per kriskowal's directive on `kriscendobot/agoric-sdk#5`
  (the steward had to be manually re-prompted three times to reclassify CI failures
  and dispatch the next fixer). The classification rubric (A expected, B structural
  impasse, C tractable, D regression) is distilled from the successful chain of
  fixer dispatches on that PR. The loop closes the seam where the orchestrator
  stopped at each red rollup to re-ask "what next?".
- _2026-06-24_: migrated into v2. Re-homed onto the gardener-supervised gardening
  state machine: "orchestrator re-prompt across CI cycles" became the script's
  `loop` signal that the supervising gardener reacts to; "dispatch a fixer"
  became "queue a fixer step"; steward-owned/liaison-tracked/driver-lane framings
  collapsed into the single gardener-supervised form; gamut → gauntlet.
