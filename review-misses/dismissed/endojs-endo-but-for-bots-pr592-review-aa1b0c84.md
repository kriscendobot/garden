---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr592-review-aa1b0c84
verdict: not-a-miss
category: new-direction
pr: 592
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/592#pullrequestreview-4673410829
identity: endojs/endo-but-for-bots#592:review:4673410829:retro
producing_role: builder
producing_job: factor-watchdirectory-to-endo-platform
severity: minor
grounds: >
  kriskowal's SIXTH review on PR #592 (CHANGES_REQUESTED, garden-authored: the
  builder job factor-watchdirectory-to-endo-platform factored the watchDirectory
  primitive out of @endo/daemon into @endo/platform and reworked
  packages/daemon/src/mount.js). The review body is a single directive
  (paraphrased): DISPATCH A CLEANER to look for opportunities to increase test
  coverage on the new features. Two inline comments on mount.js (paraphrased):
  (1) a question — is @endo/cancel committed on the `llm` branch yet; (2) a
  design suggestion — `cancelled` can live in the options bag and default to a
  forever-pending promise. This retro judges whether the garden REVIEW PROCESS
  should have anticipated these and concludes it could not have, on four grounds
  drawn from the PR's actual history. (a) NO panel/gauntlet ran on #592 — the PR
  is STILL DRAFT (draft=true at review time, 2026-07-10T17:02:42Z), the builder
  correctly left it draft to flag the gamut, and the maintainer is reviewing and
  steering the draft first; the panel, the juror seats, and the pre-push gates
  ARE the review process, and a check of journal/jobs/tada/ for #592 confirms no
  panel/gauntlet/clean job has run, so there is nothing for the review process to
  have "missed." This is the same established basis on which all FIVE prior #592
  reviews were dismissed (da7fef5e/4629031768, 9e382ba1/4631951294,
  1050d7e9/4631937541, 2e32890c/4631936168, 79bd1b73/4668730401). (b) The body
  directive "dispatch a cleaner to increase coverage" is pure maintainer
  ORCHESTRATION steering of a draft — a request to run a coverage-improvement
  pass on newly-introduced features (the daemon mount / watchDirectory factoring)
  before the gamut, continuing the same first-stated cross-platform/coverage
  direction already dismissed as new-direction in da7fef5e and 9e382ba1. It is
  not an indictment of a defect any seat, skill, or gate demonstrably knew and
  failed to bind; no encoded review-cycle check enforces a coverage floor on new
  daemon features (the prior retros' greps for test:xs/test:go/cross-platform/
  platform-parity and coverage conventions returned nothing binding here, and the
  panel that would carry the fast-checker/prover coverage lens never ran). (c)
  Inline comment (1) "@endo/cancel committed on llm now?" is an EXPLORATORY
  question about branch/dependency state whose own framing signals a live open
  question, not a defect — unanticipatable by any diff-reviewing check. (d) Inline
  comment (2) "`cancelled` in the options bag defaulting to a forever-pending
  promise" is an interface-DESIGN refinement of the cancellation-context ask first
  raised in review 4668730401 (dismissal 79bd1b73, inline ask #3: thread a
  cancellation context that propagates to cancelling watchDirectory), rooted in
  the maintainer's knowledge of the daemon's mount/cancellation model and first
  stated in review — scope/direction on a draft, not a violated standing bar or a
  lost invariant. All three signals are pre-panel maintainer steering of a still-
  draft refactor. New direction, not a garden review-process miss. Recorded as a
  durable dismissal so the same review is never re-litigated. No cluster minted;
  no threshold evaluation; no improvement dispatched. Calibration note: this is
  the SIXTH consecutive kriskowal review on #592 to resolve to a dismissal — the
  PR is a still-draft, heavily-steered refactor and every review has been pre-
  panel direction; the floor is >= 2 distinct PRs, so no cluster forms from this
  single PR (the one-PR-masquerading-as-systemic pitfall). The moment to record a
  coverage/naming/cancellation miss would be a SECOND garden-authored PR drawing
  the same ask AFTER its panel had demonstrably run and missed it.
---

# Dismissal: endo-but-for-bots #592 review 4673410829 (retro)

kriskowal's sixth CHANGES_REQUESTED review on the watchDirectory-into-@endo/platform
refactor asks, in the body, to dispatch a cleaner to increase test coverage on the
new features, and adds two inline comments on packages/daemon/src/mount.js: whether
@endo/cancel is committed on the `llm` branch yet, and that a `cancelled` option
could live in the options bag defaulting to a forever-pending promise.

Not a garden review-process miss. The PR is STILL DRAFT and no panel/gauntlet has
run (confirmed: no panel/gauntlet/clean job for #592 in journal/jobs/tada/) — the
builder correctly left it draft for the gamut and the maintainer is steering the
draft first, the same basis on which all five prior #592 reviews were dismissed.
The body directive is orchestration steering to run a coverage pass before the
gamut, continuing the first-stated cross-platform/coverage direction already
dismissed in da7fef5e and 9e382ba1; no encoded seat/skill/gate enforces a coverage
floor on new daemon features and the panel that would carry that lens never ran.
The first inline comment is an exploratory dependency-state question; the second is
an interface-design refinement of the cancellation-context ask first raised in
review 4668730401 (dismissal 79bd1b73), rooted in the maintainer's mount/cancellation
domain knowledge and first stated in review. Pre-panel steering of a draft — new
direction, not a miss. Sixth #592 review to dismiss; one PR, so no cluster forms.
See comment_url for the verbatim review.
