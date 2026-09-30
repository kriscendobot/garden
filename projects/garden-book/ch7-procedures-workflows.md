---
created: 2026-09-30
author: gardener (job book-ch7, orchestration garden-book-orch)
grounded-on: main2 087f4e1c22b, journal2 as of 2026-09-30
---

# Chapter 7: Procedures and workflows

The earlier chapters describe the garden's parts: the board, the bus, the
fleet, the roles. This chapter describes how those parts combine into
**procedures**, the recurring shapes that work takes as it moves through the
garden. There are five of them:

1. **The gauntlet**: the chain every garden-authored pull request runs, from a
   `build` to a place in the maintainer's review queue.
2. **The panel**: the jury review at the center of the gauntlet, and the
   fixer loop around it.
3. **Orchestration**: the standing pattern for any multi-part job.
4. **Chained follow-ups**: the indirection that handles a follow-up whose
   trigger is an event the board cannot see.
5. **The ferry**: the one workflow deliberately kept off the board, because
   it acts under the maintainer's identity.

One idea runs through all five, and it is worth stating first. The garden
keeps **control flow in deterministic scripts** and spends a model only on
**judgment**. A v1 garden walked a PR through its lifecycle by having an agent
read a checklist and dispatch a subagent per step. The v2 garden moved that
state machine into shell (`designs/gardening-state-machine.md`). Scripts
rebase, push, wait on CI, promote jobs, and read board state. `claude -p` is
invoked for the questions that need a reader: what a seat of the jury thinks
of a diff, whether the aggregate verdict is `must-fix` or `pass`, whether a PR's
premise has been overtaken. Everything in this chapter is an instance of that
split.

Sources: `skills/pr-creation-flow/SKILL.md`, `skills/panel/SKILL.md`,
`skills/panel-review/SKILL.md`, `skills/orchestration/SKILL.md`,
`skills/chained-followup/SKILL.md`, `roles/boatman/AGENT.md`, `CLAUDE.md`
§ The ferry, `designs/gardening-state-machine.md`,
`designs/manual-gauntlet-trigger.md`, and the scripts named in each section,
read at `main2` `087f4e1c22b`. Where a skill's prose and its script disagree,
this chapter follows the script and says so.

## Contents

- 7.1 The supervised-script principle
- 7.2 The gauntlet, end to end
- 7.3 The panel
- 7.4 Orchestration
- 7.5 Chained follow-ups
- 7.6 The ferry
- 7.7 Choosing a procedure
- Quick reference

## 7.1 The supervised-script principle

`designs/gardening-state-machine.md` sets out the reasons for moving the state
machine out of the agent and into a script:

- **Determinism and cost.** A rebase, a push, or a CI wait does not need a
  model each time. A script does it reliably and for free, and the model is
  reserved for real decisions.
- **Context protection.** A supervising agent's context window is precious.
  The scripts are written to be **quiet on success**: their only stdout is a
  terminal line or a real failure. Per-seat panel verdicts, which run to
  thousands of words, go to a run directory on disk, never to the
  supervisor's window.
- **Diverted tracing.** Debug output is opt-in and goes to a file.
  `GARDEN_TRACE=1` makes a script `set -x` into `GARDEN_TRACE_LOG` through
  `BASH_XTRACEFD`, and the supervisor hands that log to a separate debugging
  agent rather than reading it itself.

The scaffold that embodies the design is
`scripts/jobs/gardening/garden-pr.sh`. Its stages are a deterministic
fresh-base check and safe rebase (`safe-rebase.sh`), sense-gated optional
automations (`sense.sh`), an always-on pre-push gate (`pre-push-gates.sh`), an
always-on evaluation gate (`local-verify.sh` by default), a push for CI
(`safe-push-pr-head.sh`), and a `decide` call on whether to loop.

Two asymmetries in that scaffold recur everywhere else in this chapter:

- **`sense.sh` answers "yes" on any ambiguity.** A missing base ref, a
  shallow clone, or a git error all mean "run the automation." A false
  positive wastes a little time; a false negative lets a regression reach CI.
  The evaluation suite is never sense-gated at all.
- **Conflicts fail closed.** `safe-rebase.sh` resolves exactly one conflict
  class on its own: a lockfile-only conflict, which it fixes by dropping the
  stale `chore: Update yarn.lock` commit and regenerating the lockfile. Any
  other conflict exits 3 for a weaver or fixer. The script does not guess.

The supervising **gardener** invokes a script, reads its small output, reacts
to a `loop` signal or a failure, and **evolves the script** when it fails in a
fixable way. The state machine is data that the supervisor owns.

## 7.2 The gauntlet, end to end

**The gauntlet** is the full chain a garden-authored PR runs. v1 called it
"the gamut"; that name is retired. In outline:

```
build or design       (opens THE draft PR via ensure-pr.sh)
   |
   |  completion edge: auto-gauntlet-handoff.sh -> post-gauntlet.sh
   |  (or, explicitly: "run the gauntlet #N" -> post-gauntlet.sh)
   v
jobs/gauntlet/<g>.md  (a record, walked by scripts/jobs/gauntlet.sh)
   |
   v
viability  ->  clean  ->  panel-1  --must-fix-->  fix-1  ->  panel-2  -> ...
                              |
                              +--pass-->  undraft  (appellate + gh pr ready)
```

The canonical stage list in `skills/pr-creation-flow/SKILL.md` is
**build → assayer → cleaner → panel → fixer loop → appellate → un-draft**. The
staged driver implements it as the stage jobs above. The mapping is:

| Skill stage | Where it actually runs |
|---|---|
| build | The builder's own job. It opens the draft PR and stops. |
| assayer | Part of the build by default ("in concert"): tests and production code land on the same branch, in disjoint files. The skill also allows TDD-style (tests first) or regression-after placement. The staged driver has no separate assayer stage. |
| cleaner | The `<g>-clean` stage job. |
| panel | The `<g>-panel-<k>` stage jobs, each running one round of `scripts/jobs/gardening/panel.sh`. |
| fixer loop | Alternating `<g>-fix-<k>` and `<g>-panel-<k+1>` stage jobs. |
| appellate | Step 2 of the `<g>-undraft` stage: advisory only. |
| un-draft | Step 3 of the `<g>-undraft` stage: `gh pr ready <N>`. |

The staged driver adds one stage the skill does not list: **viability**, a
cheap pre-spend gate that runs before anything costly.

### 7.2.1 Opening the PR: draft, always

The build stage does not run `gh pr create`. It runs
`scripts/jobs/gardening/ensure-pr.sh <job-base> <owner/repo> <head> <base>
--title T --body-file F`, which owns the pairing of a job to its PR. The
script finds an existing PR two independent ways, by head branch and by a
`<!-- garden-job: <base> -->` marker it embeds in every body it writes. It
then adopts the one it finds, creates one if none exists, or exits 3 if it
finds more than one (never adding another). A discovery query that fails or
may have been truncated exits 4 and creates nothing: "a retry is cheap, a
duplicate PR is not."

The reason is that **a job can be claimed more than once**: a stranded
worker, a reaper requeue, a resumed claim. On 2026-07-28 one build job was
claimed four times and left two divergent PRs for one change
(`endojs/endo-but-for-bots#865` and `#871`). The marker is what relates two
incarnations that share nothing else, not even a head branch.
`ensure-pr.sh` is one of three guards around a re-claimed job's writes. The
others are `safe-push-pr-head.sh`, which refuses to rewind a peer's newer
commits, and a claim fence that stops a stranded worker from pushing at all.

Every PR the garden opens is **draft**. `ensure-pr.sh` is draft by default,
and only the ferry's upstream PR may pass `--no-draft`. The skill calls this
"the single most load-bearing rule" it contains, and the reason is mechanical.
The draft flag is how every downstream sensor decides whether the bot-side
chain has finished:

- The next-stage-owed heuristic (7.2.5) reads "already un-drafted" as "nothing
  owed."
- The panel's pre-round state check short-circuits on `isDraft == false`.
- GitHub itself enforces draft: no auto-requested reviewers, and the merge
  button is disabled.

So a PR opened ready-for-review is not a cosmetic slip. It **skips the
review chain** and puts an unreviewed PR straight into the maintainer's
queue. When in doubt, open draft. An over-cautious draft costs nothing,
because the chain un-drafts it.

**Only the end of the gauntlet moves a PR out of draft.** Un-draft is earned,
never a starting state. The one intentional exception concerns the un-draft,
not the open: a **probe** (`skills/gap-revealing-build/SKILL.md`) is opened
draft and is meant to *stay* draft, delivering a gap report on a tentative
design rather than a mergeable change.

Every fork-side PR also targets a **frozen base branch**, `<base>-<short-sha>`
(for example `master-abc1234`), a snapshot pushed to the fork at open time.
Concurrent PRs therefore never see each other's rebases. Moving that base
later is the **weave** verb (`skills/frozen-base-branch/SKILL.md`).

### 7.2.2 What triggers the chain: the trigger regime, then and now

Whether the chain starts on its own has changed twice, and the history
explains the current guardrails.

**Before 2026-09-16: automatic.** A completed build staged its gauntlet
through `auto-gauntlet-handoff.sh`. An hourly coverage audit also staged
gauntlets for any uncovered design PR. On 2026-08-30 that audit mass-staged
69 gauntlets in one pass, about $482 on one host.

**2026-09-16 to 2026-09-29: the manual regime.**
`designs/manual-gauntlet-trigger.md` retired the automatic stager. A
completed build or design stopped at its open draft PR, and **`run the
gauntlet #N` became the sole ordinary trigger**, from the comment watcher or
the liaison, both calling `scripts/jobs/post-gauntlet.sh` directly. The
design separated two decisions the automatic edge had conflated: *a worker has
produced a reviewable artifact*, and *the maintainer wants to spend a full
gauntlet on it now*. It replaced "every PR gets a gauntlet" with a weaker but
still mechanical invariant:

> A garden-authored build or design PR may complete without a gauntlet only
> while it is draft. Moving it into the mergeable queue requires a separate,
> maintainer-visible act.

**Since 2026-09-29: automatic again, but narrower.** The design's status line
now reads "Superseded 2026-09-29 by the restored completion-local automatic
handoff" (commit `18df481c04b`, `feat(gauntlet): restore automatic producer
handoff`). The maintainer reversed the manual default once fleet health
improved. `scripts/jobs/gardener.sh` again calls
`scripts/jobs/auto-gauntlet-handoff.sh` on completion, but the restored edge is
deliberately narrower than the original:

- It considers **only the PR named in the completing job's report**. It is a
  completion edge, not a backlog sweep, so it cannot repeat the 2026-08-30
  mass-stage.
- A job-file citation is never treated as the job's artifact. A PR a build
  opened did not exist when the job was posted, so a PR URL in the job body is
  by construction a reference. (Scraping both documents is how, on 2026-07-29,
  a build that opened no PR force-drafted the unrelated, live
  `endojs/endo-but-for-bots#671`.)
- The PR's author must be the bot. A report that cites someone else's PR
  cannot be staged, which closes the sibling 2026-07-29 incident on the
  Dependabot PR `#867`.
- **Builder** roles owe a feature gauntlet, recorded under the base
  `<build-base>-gauntlet`. **Non-builder** jobs (a designer, a research job)
  owe one only when their PR is design-only, recorded under the PR-keyed base
  `<owner>-<repo>-pr<N>-gauntlet`, so repeated completions converge on one
  record.
- Probes and the garden's own open-question answer surfaces are skipped.
- It **never changes PR state.**

The manual regime's guardrails survived the reversal:

- **Draft-at-completion sensor.** `scripts/jobs/assert-producer-pr-draft.sh`
  passes a draft producer PR. If a completion names a bot-authored **non-draft**
  PR with no gauntlet coverage (the "opened ready by mistake" class), the
  gardener records one deduplicated maintainer action and terminalizes the
  already-complete producer. It never re-drafts the PR, because re-drafting a
  PR under live human review repeats the `#671`/`#867` hazard.
- **Readiness audit.** `scripts/jobs/design-pr-gauntlet-coverage-audit.sh`
  still runs hourly, but it only **alerts**. It finds bot-authored open
  non-draft PRs with no gauntlet and raises a maintainer alert, deduplicated on
  `<repo>#<number>:<headRefOid>`, so a changed head warns again and an
  unchanged one stays quiet.
- **Exact-head freshness.** `scripts/jobs/assert-panel-head-fresh.sh`
  compares the last completed panel's `reviewed_head` with the PR's current
  `headRefOid`. Any commit movement is a `review required` disposition and one
  maintainer action. Metadata-only edits (title, body, labels) leave the head
  unchanged and the coverage fresh. File types are deliberately not
  inspected, because design Markdown and workflow YAML are substantive
  changes.

**`run the gauntlet #N`** remains the explicit trigger. The comment watcher
recognizes it in imperative position on a watched PR and records the gauntlet
before it acknowledges the comment; the liaison calls the same primitive for a
chat directive. Use it for a draft PR that has no producing job, or to request
review directly. It is idempotent: an active or completed record under the same
base is a no-op.

One scoped exception is the **Ironhorse autopilot**, whose 2026-09-28
authorization lets its serial controller stage and advance its own crank-PR
gauntlets (`skills/orchestration/SKILL.md` § Authorized Ironhorse ratchet).
The exception applies to no other orchestration.

### 7.2.3 The staged driver

The gauntlet used to be **one** claimed job whose wall-clock time was the sum
of every stage, every fix-loop iteration, and every CI wait. That sum fits no
handler budget. On 2026-07-28, nine gauntlet jobs doomed on deadline overrun,
one of them already at a 14000-second budget. `designs/staged-gauntlet.md`
split it up.

`scripts/jobs/post-gauntlet.sh` writes a **record**, `jobs/gauntlet/<g>.md`,
outside the claim lifecycle:

```sh
scripts/jobs/post-gauntlet.sh [--build-job <base>] [--probe] \
  [--max-iterations N] [--max-resumes N] [--max-stage-retries N] \
  <g> <pr-url>
```

`scripts/jobs/gauntlet.sh` is the driver: a leader-only timer, **no
`claude -p`**, the per-PR analog of the orchestration watcher in 7.4. Each tick
it reads the current stage job's board state. If the stage is still in
`todo/` or `doin/`, it waits. If the stage failed, it retries or halts. If the
stage is in `tada/`, it reads the job's **stage-result marker**, a line of the
form

```
<!-- gauntlet-stage-result: <stage>=<result> -->
```

and applies the transition table from the script's header:

| Completed | Result | Next |
|---|---|---|
| viability | `proceed` | clean |
| viability | `closed` / `merged` | refuse and report; no loop |
| viability | `overtaken` | report the deciding question and a close-as-superseded option |
| clean | `done` | panel-1 |
| clean | `still-pending` | re-post the clean stage (bounded by `max_resumes`) |
| panel-k | `pass` | undraft (a probe is done instead; it never un-drafts) |
| panel-k | `must-fix` | fix-k |
| fix-k | `done` | panel-(k+1); past `max_iterations` (default 6), stop for review |
| fix-k | `still-pending` | re-post the fix stage (bounded) |
| undraft | `done` | write `jobs/tada/<g>`, remove the record |

Each stage is an ordinary `role: gardener` job with its own fresh handler
budget and its own per-job project worktree. That per-job isolation matters,
because peers working the same PR must never share a working tree. A stage's
brief is generated by the driver:

- **viability** asks whether the PR is still open and whether its premise
  still holds. A merged or closed PR, or one whose premise has been overtaken,
  never enters the paid loop. An `overtaken` result must name a
  `Deciding question:` and carry the exact `Option: close as superseded` line,
  or the driver halts fail-closed.
- **clean** runs the coverage pass (`skills/coverage-driven-testing`), removes
  dead code the change orphaned, pushes through `safe-push-pr-head.sh`, and
  waits for CI with `ci-wait-merge.sh <repo> <N> --no-merge` under a bounded
  deadline. The cleaner is explicitly **not** a juror: its work mutates the
  branch, which does not fit the panel's read-only posture. It **never
  un-drafts**. On a `CONFLICTING` head it surfaces a weave or rebase need
  instead of pushing.
- **panel** runs `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh
  <worktree> <N> <base-ref>`, posts the aggregate as a formal `gh pr review`,
  and emits `pass`, `must-fix`, or `panel-error`.
- **fix** addresses the must-fix items, pushes, and waits for CI.
- **undraft** checks idempotence, runs the advisory appellate pass, and calls
  `gh pr ready <N>`.

The driver fails closed. A `done` stage with no parseable marker is a failure,
never a guess. There are three separate bounded retry axes:

- `max_resumes`: CI still pending at the stage deadline. A repository whose
  PRs attach no checks at all would otherwise re-post the stage forever.
- `max_stage_retries`: a stage job that **died**. Only a reaper-certified
  `transient` doom is retried; a policy refusal, a deadline doom, or an
  unclassified exhaustion halts.
- `panel=panel-error`: a seat or decider crashed. That is a sensor failure, not
  a verdict, so it rides the stage-retry axis instead of declining the whole
  gauntlet.

At a terminal exception (`review-budget-reached` or `HALTED`) the driver posts
**one idempotent loop-status comment** on the PR, naming the rounds run, the
current head, the CI state, the unaddressed must-fix count where derivable, and
the maintainer's next decision. The same event lands in `jobs/tada/` and the
maintainer inbox. After a halt's cause has been fixed,
`gauntlet.sh --resume-from-stage <g> <stage> [--iteration N]` reopens the
record. No one hand-edits the journal.

### 7.2.4 Variants

- **Design-only PR.** When every changed path is under a design directory, the
  chain is **build → design panel → fixer loop → un-draft**. There is no test or
  source surface, so there is no assayer or cleaner. Design PRs and
  implementation PRs are always separate PRs against separate bases. The
  maintainer's framing (2026-05-14): "The designs should be based on llm. The
  implementations should be based on master, for those designs." Keeping them
  apart gives each panel the right audience and lets the ferry carry the
  implementation alone.
- **Cleaner-skipped tiny PR.** Pure documentation, a lockfile-only churn, a
  one-file format sweep, or a one-line fix with its fixture already in the
  diff: no coverage surface, so the panel runs directly.
- **Clean first round.** No must-fix, no fixer; appellate, then un-draft.
- **After maintainer review.** A maintainer's `CHANGES_REQUESTED` starts a
  fixer → CI-green → re-request loop, **not** a new cleaner or panel by default.
  The PR stays out of draft; the maintainer's review queue is now the venue.
  A new commit does, however, make the old panel coverage stale (7.2.2), and
  the maintainer decides whether to spend another gauntlet.
- **Garden designs with open questions.** On the garden's own repo, a design
  carrying a non-empty `## Open questions` section is opened as a PR for inline
  review, marked `<!-- garden-design-open-questions -->`. That PR is a place to
  answer questions, not a pending merge, so it gets no panel.

### 7.2.5 The next-stage-owed heuristic

When a gardener picks up a quiet draft PR, it reads the owed stage from
**GitHub state, not journal entries**, which can lag. The first match wins:

1. `CONFLICTING` against its base? A weave or rebase is owed first.
2. Already un-drafted? Nothing owed.
3. Panel passed, no later push, still draft? The un-draft lapsed: run
   `gh pr ready` and note it.
4. Must-fix verdict with no fixer push since? A fix is owed.
5. Fixer pushed since the last verdict, no panel since? A panel re-run is owed.
6. Cleaner pushed and CI green, no verdict yet? The panel is owed.
7. PR open, no cleaner push? The cleaner is owed, or the panel on the tiny or
   design-only variant.

A "panel verdict" is a formal `gh pr review` in the panel-review shape. A plain
`gh pr comment` does not count and does not advance the flow.

### 7.2.6 Chaining is the point

The failure this whole procedure exists to prevent is the **single-stage
stop**: a draft PR opened and left with nothing advancing it. The garden then
opens drafts it never finishes, and the maintainer's queue stays empty. A
gardener needs no per-PR authorization to advance a garden-authored draft
through its own chain, because that is normal operation. Authorization is
needed only for cross-repo etiquette actions (the ferry, inline review
replies, top-level comments on others' PRs). If a chain stops before un-draft
with no clear owed stage, the heuristic is missing a case, and the gardener
surfaces it on the bus instead of guessing.

## 7.3 The panel

The panel is `scripts/jobs/gardening/panel.sh <worktree> <pr> [base-ref]`. It
is the v2 translation of v1's judicial workflow, in which three judge roles
(solicitor, barrister, justice) and an appellate each fanned out a jury and
aggregated by hand. The judges differed only in their briefing (design panel,
first code round, delta re-review), and that difference is now carried by the
seat prompt and the diff base. The three roles collapsed into one loop.

### 7.3.1 Sensing code versus design

The script diffs `<base>...HEAD`. If **every** changed path is under
`designs/*.md` or `*/designs/*.md`, or matches `DESIGN*.md`, it runs the
**design panel**. Anything else runs the **code panel**. The match is exact:
one source file among many design docs makes a code-panel PR. Any ambiguity
(no base, a git error, no changed files) falls to the code panel, the broader
and safer choice, matching `sense.sh`'s bias toward over-reviewing.

Before dispatching anyone, the script asks whether the diff is **empty**. A
diagnostic baseline PR whose head is an empty commit
(`endojs/endo-but-for-bots#847`) once dispatched every code seat to review zero
lines. Now an empty diff passes after zero rounds and zero `claude -p` calls.
The gate is narrow and fail-closed: it fires only when git *confirms* there is
nothing to review.

### 7.3.2 The seats

The seat lists live in `panel.sh` and can be overridden with
`GARDEN_CODE_SEATS` / `GARDEN_DESIGN_SEATS`. The prose descriptions have
drifted: `skills/pr-creation-flow/SKILL.md` says "~29" code seats and 7 design
seats, `skills/panel-review/SKILL.md` says 31 and 7, and `skills/panel/SKILL.md`
says 31 and 9. The script's defaults at `087f4e1c22b` are:

**Code panel: 33 seats.** assessor, typist, stylist, packager, archivist,
prover, curator, migrator, locksmith, warden, saboteur, breaker, purist,
spec-keeper, wire-watcher, engine-realist, integrator, duality-auditor,
benchmarker, changeset-auditor, surfacer, scribe, pruner, gateway,
corner-prober, fast-checker, releaser, transplanter, coverage-auditor,
orthographer, thesaurus, procurer, reexport-auditor.

**Design panel: 9 seats.** critic, skeptic, decomplector, ergonomist,
copyeditor, pedant, novice, orthographer, thesaurus.

Five code seats are **cost-gated**. Each runs a deterministic pre-pass under
`scripts/jobs/gardening/seat-gate-*.sh` and spends a `claude -p` only when there
is something to judge:

- `coverage-auditor`: a c8 pre-pass over uncovered new lines.
- `orthographer`: a divergence grep for introduced British spellings.
- `thesaurus`: a cliché grep for introduced stock AI phrasing.
- `procurer`: the export-index/build-vs-buy detector.
- `reexport-auditor`: the Babel `no-plain-reexport` probe.

The orthographer and thesaurus sit on the design panel too, so a design with
no British spelling and no cliché costs nothing for them. Deterministic
pre-passes can also **add** a seat back to a trimmed panel. The related-design
pre-pass forces the `integrator`, the ownership-map pre-pass forces the
`decomplector` on a design, and `detect-banners.sh` forces the `archivist` when
an added code comment carries a decorative banner.

The seat count has grown steadily: 6 code seats in mid-May 2026, 26 by
2026-05-21, 28 with the `coverage-auditor` (2026-07-12), 29 with the
`duality-auditor` (2026-08-20), and then the cost-gated seats. The design panel
went from 5 seats to 7, then 9. Each seat's brief is
`roles/jurors/<seat>/AGENT.md`. Chapter 5 covers them individually.

Seats run **concurrently**, `GARDEN_PANEL_CONCURRENCY` (default 8) at a time.
Run sequentially, a 29-seat panel over a ~1500-line diff took 1.5 to 2.5 hours.
Concurrency is what makes a panel fit a handler budget; panel jobs resolve the
7200-second `GARDEN_PANEL_HANDLER_TIMEOUT`. A seat that returns an empty block is
retried with backoff (`GARDEN_PANEL_SEAT_ATTEMPTS`, default 3) and then fails
the panel loudly, because an empty verdict is never legitimate. Each attempt is
bounded by `GARDEN_PANEL_SEAT_TIMEOUT` (default 1200 s). After the join, blocks
are appended in seat-list order, so the aggregate is byte-identical however the
seats interleaved. Seat models come from
`scripts/jobs/gardening/seat-model-tiers.tsv`, which only ever **downshifts**
from the fleet ceiling. Every seat runs from inside the job's worktree, so its
tokens are metered to the panel job.

### 7.3.3 What a seat returns

Each seat returns one block:

```
**Verdict:** approve / request-changes / comment-only

**Findings:**
- (concrete, file:line) [rule: <path>] OR [proposed-rule: <one sentence>]

**Notes (out of scope but worth flagging):**
- ...
```

The key rule is **cite-or-propose**. Every finding either cites the standing
rule it enforces (`[rule: skills/rename-discipline/SKILL.md]`) or proposes a new
one in a sentence. A finding carrying neither is **dropped** at aggregation.
This came from the review of PR #75, where 71 inline and 14 top-level
maintainer comments turned out to map largely onto rules the garden had already
written down and the seats had not read. Proposed rules are forwarded to the
gardener over the bus to be encoded later, which is how the panel feeds the
library.

### 7.3.4 Dispositions

One `claude -p` (the `decide_disposition` hook) reads the aggregate. It
first sorts findings into three **buckets**:

- **Must fix before merge**: any request-changes with concrete impact.
- **Should fix in this PR**: taste or clarity items raised independently by at
  least two seats.
- **Out of scope / follow-up**.

It then gives each finding one of five **dispositions**:

| Disposition | Meaning | Where the work goes |
|---|---|---|
| `must-fix-loop` | Blocks un-draft. | The fixer stage; the panel re-runs. |
| `summary-fix` | Small, fixable without a re-review. | One bundled fixer pass; no re-run; un-draft not blocked. |
| `follow-up` | Useful, out of scope. | The follow-up ledger, revisited at merge. |
| `acknowledge` | Real observation, no work warranted. | The review body only. |
| `drop` | Wrong on second read, or lost a panel disagreement. | A one-line rationale in the run dir. |

(The job brief for this chapter calls the second bucket "should-fix". In the
rubric, "should fix" is the bucket and `summary-fix` is its default
disposition.)

The rubric applies in order. Start from the bucket default. Demote weak
single-seat signals to `acknowledge`. Demote the losing side of a panel
disagreement to `drop`. Drop a must-fix that fails a 30-second sanity check;
"shadowing" claims are the usual hallucination. Bundle all `summary-fix` items
into one pass. Append follow-ups to one ledger per PR at
`journal/projects/<slug>/followups/<repo>--<N>.md`, where a merge-watch producer
picks them up **when the PR merges**, not before, since before merge the
maintainer may still reshape or close it. The rubric fails conservatively: an
unjudged finding keeps its bucket default.

On **external-authored** PRs, findings that cite garden-only prose conventions
(em-dash style, no Latin shorthand, American spelling, the cliché list) are
downgraded to `drop`. Contributors follow their project's house rules, not the
garden's.

The review is posted as a **formal** review, because a plain comment does not
flip `reviewDecision`:

- any `must-fix-loop` → `gh pr review --request-changes`;
- otherwise, anything above `drop` → `--comment`;
- a clean or fully dropped panel → `--approve`.

GitHub refuses `--request-changes` on a self-authored PR, so a bot reviewing a
bot PR falls back to `--comment`, and downstream automation also keys on the
"Must-fix before merge" heading in the body. The top-level verdict stays
visible, and each seat's block is collapsed in a `<details>` element whose
summary carries the seat name and its verdict. Each block ends with its own
provenance footnote, since each seat may have run on a different model.

### 7.3.5 The loop and its exit condition

The panel-fixer loop's exit condition is **"no in-scope must-fix,"** not "all
complaints addressed." The pr-creation-flow skill names spinning on
out-of-scope findings as a pitfall: `summary-fix`, `follow-up`, `acknowledge`,
and `drop` do not block the loop. The decision hook reads back exactly one of
two tokens, `must-fix` or `pass`. On `must-fix` the fixer runs and the panel
reviews the new head. On `pass` the loop ends. In the staged gauntlet each round
is its own job, and the fix/panel alternation is bounded by `max_iterations`,
default 6. The standalone script's own safety bound, `GARDEN_PANEL_MAX_ROUNDS`
(default 8), is a guard, not a normal exit.

### 7.3.6 The appellate pass

On the terminating round a final `claude -p` reads the passing aggregate and
proposes **promoting** small, in-context deferrals (a `follow-up` that is
really a two-line fix) to `summary-fix` before un-draft. It is **advisory**: its
proposals land in `appellate.md` in the run dir and never block the un-draft.
It exists because the rubric's conservatism can leave cheap fixes stranded in
the ledger.

### 7.3.7 What the panel leaves behind

The run dir (`GARDEN_PANEL_RUNDIR`) is scratch and is torn down with the job.
One compact record survives: `panel-runs/<owner>-<repo>-<pr>/<run-id>.md` on
`journal2`, written best-effort by `scripts/jobs/panel-run-record.sh`. It holds
the panel kind, the rounds, a verdict class per seat (never the seat's prose),
must-fix counts and truncated titles, whether the appellate ran, and the full
`reviewed_head`. This is the data that lets the garden audit its own evaluator,
and `reviewed_head` is the anchor the freshness sensor in 7.2.2 compares
against.

## 7.4 Orchestration

The maintainer's standing directive (kriskowal, 2026-07-01): **for a multi-part
job, always make an orchestration job.** A loose pile of sub-jobs relies on
someone remembering the follow-ups, and the garden, like any system with
amnesiac workers, forgets. An orchestration writes the sequence down and has a
deterministic watcher carry it out. Skill: `skills/orchestration/SKILL.md`.
Design: `designs/orchestration-jobs.md`.

### 7.4.1 When to reach for it

The garden has two deterministic "promote when the board reaches a state"
primitives:

- **`blocked_on` + `unblock.sh`.** `post-plan.sh --blocked --blocked-on <A>
  <B>` parks B, and the unblock watcher promotes it when A reaches `tada/`.
- **An orchestration.** Built on the same substrate, but it **owns** the
  promotion of its children, which lets it express three things a bare
  `blocked_on` edge cannot:
  - **parallel** fan-out, not only a linear chain;
  - a **progress report** and a single completion record for the whole unit;
  - a **failure policy**. `unblock.sh` promotes B when A merely *reaches*
    `tada/`, with no notion of A having *failed*.

Rule of thumb: a plain two-step linear dependency with no parallelism,
progress, or failure policy uses `blocked_on`. Anything genuinely multi-part
uses an orchestration.

### 7.4.2 The pieces

- **Children** are parked in `jobs/plan/` with gate `orchestrated`. The foreman
  promotes only `deferred` jobs and the unblock watcher only `blocked` ones, so
  this gate is invisible to both, and **only** the orchestration watcher ever
  promotes an orchestrated child.
- **The record**, `jobs/orch/<orch-base>.md`, has YAML frontmatter: `order:
  serial | parallel`, `children:` in run order, `on-child-failure: halt |
  continue`, a watcher-managed `state:`, and optionally `budget_tokens:`
  (serial only) and `resume_from:`. Like `plan/`, `jobs/orch/` is outside the
  claim lifecycle: never claimed, never reaped.
- **The watcher**, `scripts/jobs/orchestrate.sh`, runs on the leader-only
  `garden-orchestrate` timer (about every 3 minutes) with **no `claude -p`**. It
  advances each active orchestration one step per tick.

### 7.4.3 Serial versus parallel

**Serial** (the default) promotes child 1 with `promote-plan.sh`, waits for it
to reach `tada/`, then promotes child 2, and so on. The ordering guarantee is
enforced twice: `promote-plan.sh --require-tada` re-checks every predecessor
against its own freshly synced board snapshot, on every CAS retry, so a stale
watcher read can never promote N+1 while N is still parked. A serial
orchestration may carry a **token budget**. Before each promotion the watcher
sums billable tokens from the children's ledgers, and at or over the cap it
finishes `budget-exhausted` and leaves the rest parked. Budgets gate
admission, never execution: a running child is never killed. Chapter 8 covers
budgeted campaigns in detail.

**Parallel** promotes every child at once and watches them all. It cannot carry
a budget, because it admits every child before any spend exists.

### 7.4.4 The failure policy

The watcher reads each child's state from one immutable committed board
snapshot:

- `done`: in `tada/`.
- `active`: in `todo/` or `doin/`.
- `parked`: in `plan/`.
- `failed`: promoted but now in none of those directories (the reaper doomed
  it); or its report carries `orchestration-failed: true`; or it shows an
  excessive requeue count or time in flight beyond its handler budget.

An unreadable tree, or a child present in two directories at once, is `retry`,
never evidence of failure.

A child that finishes but misses its gated outcome says so mechanically, by
ending its report with

```
<<<GARDEN-ORCHESTRATION-FAILED>>>
<<<GARDEN-JOB-COMPLETE>>>
```

and `complete-job.sh --orchestration-failed` stamps the frontmatter field. No
one hand-types it into prose, and a prose sentence that merely mentions the
marker does not count as a verdict.

On a failure the watcher sends a structured maintainer notice
(`orchestration-event`, `orchestration`, `orchestration-status`, `child`,
`failure-kind`; a budget overrun is `orchestration-child-timeout`) and applies
the policy:

- **halt** stops a serial run at the first failure, leaves the not-yet-run
  children parked under their held gate, and surfaces the failure.
- **continue** proceeds only when the failed child nevertheless reached
  `tada/`. A vanished child has no completion evidence and cannot satisfy the
  serial precondition, so the chain stays safely parked. The skill's rule is
  "Never infer completion from absence."

Halts **correct themselves**. A halt records `halt-failed-child:` and
`halt-parked-remainder:`. If the blamed child later turns up complete in
`tada/` (the halt came from a stale reading, or the child recovered on a
requeue), the watcher posts a `<base>-resume` orchestration over the parked
remainder and marks the halt `halted-resumed`. The completion record is always
the authority. Timing signals are only provisional.

### 7.4.5 A lifecycle, walked through

The book this chapter belongs to is itself an orchestration. Its record,
`jobs/orch/garden-book-orch.md`, reads in part:

```yaml
order: parallel
children: book-ch1 book-ch2 book-ch3 book-ch4 book-ch5 book-ch6 book-ch7 book-ch8
on-child-failure: halt
state: running
```

Its life, step by step:

1. **Decompose.** The request, "a comprehensive book about the garden," was
   split into eight independent chapters. They share no inputs, so the order is
   parallel.
2. **Park the children**, each with its own body:

   ```sh
   scripts/jobs/post-plan.sh --orchestrated --orchestrated-by garden-book-orch \
     book-ch7 ch7-body.md
   ```

   A child that is a recurring verb against a target (a weave, a shepherd, a
   restack of a specific PR) must carry a `-YYYYMMDD` suffix. Otherwise
   `post-plan.sh` may find an old completed job of the same name in `tada/` and
   silently skip the park. That happened to an
   `endojs-endo-but-for-bots-pr395-weave` child on 2026-08-17, and the script now
   warns loudly about it.
3. **Record the orchestration:**

   ```sh
   scripts/jobs/post-orchestration.sh --parallel --on-child-failure halt \
     garden-book-orch book-ch1 book-ch2 ... book-ch8
   ```

   It refuses any child that is not parked `orchestrated` under **this**
   orchestration (or already past `plan/`). An existence-only check would record
   a campaign whose watcher could never promote children owned by someone else.
   `--adopt-go-ahead` turns a held set of `go-ahead` children into a running
   orchestration in one journal commit.
4. **Promote.** On its next tick `orchestrate.sh` promotes all eight to `todo/`.
   The job header of this chapter carries the promotion stamp:
   `garden-promoted-from-plan: gate=orchestrated ... at=2026-09-30T03:47:10Z`.
5. **Claim and run.** Gardeners race-claim the children. The record gains
   `child-<name>-host:` lines as it learns where each child runs.
6. **Watch.** Each tick re-reads the snapshot. Children move from active to
   done; the watcher stays silent while things are merely active.
7. **Terminate.** When every child is terminal the watcher writes
   `jobs/tada/garden-book-orch.md` with `orchestration-status: complete` (or
   `complete-with-failures`, `halted`, `budget-exhausted`), a `failed-children:`
   line, a `recovered-children:` line, and one disposition per child. It then
   removes the record and sends an `orchestration-terminal` notice.
8. **Downstream.** A separate assembly-and-publish job, parked `blocked_on`
   the orchestration, is then promoted by the ordinary unblock watcher. The two
   primitives compose: the orchestration handles the fan-out, and `blocked_on`
   handles the single next step.

A budget-stopped serial campaign is continued by posting a **new** campaign,
with a new budget, that adopts the parked remainder:
`post-orchestration.sh --serial --budget-tokens <cap> --resume-from <old>
<new> <children...>`. An old campaign's budget is never edited in place.

The staged gauntlet (7.2.3) is the same pattern specialized to a single PR. It
has a record outside the claim lifecycle, a leader-only no-LLM driver, one step
per tick, and fail-closed markers. The orchestration watcher is the general
case.

## 7.5 Chained follow-ups

Both `blocked_on` and orchestration anchor on a **board base reaching
`tada/`**. Some follow-ups depend on an event the board never records. The
motivating case (kriscendobot/minion.town#41) was a review that asked the
garden to "post a job to design X, and a follow-up to act on that
implementation here, triggered when it lands." Blocking the follow-up on the
design job fires it as soon as the design is *written*, long before anything is
*built*. The follow-up would run against nothing.

The trigger here is **second-order**: not "job D finished" but "the design D
produced has itself grown a build." That event lives in the project repo (a
design PR merged, a build PR opened against it). `skills/chained-followup/SKILL.md`
bridges it with one level of indirection, **D → N → F**:

- **D, the design job,** is posted normally to `todo/`.
- **N, the notice job,** is parked blocked on D:
  `post-plan.sh --blocked --blocked-on <D> <N> <body>`. When D completes, N is
  promoted, and its only work is a **deterministic, read-only check**: a `gh`
  PR-state query, not a model reading untrusted PR text. Has D's design
  advanced to a build?
  - **Yes**: N posts F with `post-job.sh`, naming the build PR or commit in F's
    body, and completes.
  - **Not yet** (design open, or merged but not built): N re-arms itself,
    either re-parked blocked on a now-nameable build artifact, re-posted blocked
    on D, or on a short `once:` schedule, and completes. The thread is never
    dropped.
  - **Never** (the design was declined): N ends the chain with a maintainer
    note. It does not post an F against nothing.
- **F, the follow-up,** is **posted by N, never up front.** Because it exists
  only once the trigger is real, it always runs against an implementation that
  exists. Its body lives inside N's instructions.

Anchoring options, cheapest faithful first:

- `--blocked-on <D-base>` (the default): N does the build check itself.
- `--blocked-on <PR-URL>`: when the build PR is already known, N can block
  directly on its merge. This is rare, because the PR usually does not exist
  yet.
- A `once:` or recurring **sentinel schedule** with a deterministic `preflight:`
  gate that exits 2 until the build exists: for a design authored outside the
  fleet, with no board base to block on.

Two pitfalls get their own warnings in the skill. First, a plain `--deferred`
F is **not** safe, because the foreman auto-promotes `deferred` jobs. Second,
completing N with neither an F nor a re-arm silently forgets the follow-up.

The first live use of the chain was D
`ebfb-daemon-commit-formula-design` (a daemon "commit" formula on
endo-but-for-bots), N `mtown-git-remote-followup-notice`, and an F minted by
N for the minion.town git remote.

**How it relates to orchestration.** An orchestration could hold D and F as
serial children, but it would promote F when D reaches `tada/`, which is
exactly the premature firing the chain exists to avoid. The notice job is the
piece that converts a project-repo event into a board event. After that, the
ordinary primitives take over.

## 7.6 The ferry

Everything above runs under the **bot** identity (`kriscendobot`), on forks
the garden owns. **Ferrying** carries an approved change from a garden fork to
the upstream governance repo (for example from `endojs/endo-but-for-bots` to
`endojs/endo`) under the **maintainer's** identity. Every commit is authored by
the human, and the upstream PR is opened by the human's account. That is an
identity-crossing act, and the garden treats it as a separate, permissioned
surface with its own dispatch
(`designs/dedicated-ferry-dispatch.md`).

### 7.6.1 Why not the board

Any gardener on any host may claim any eligible board job, and every fleet `gh`
call runs through a wrapper (`scripts/jobs/bin/gh`) that pins it to the bot's
token. A ferry must run only on the one host that holds the maintainer's
credentials, and it must not act as the bot. The two requirements are
incompatible with a race-claimed board, so the ferry is taken **off** it:

- The liaison **stages** a ferry by writing a directive to
  `journal/jobs/ferry/<name>.md`. It never uses `post-job.sh`, and it never
  dispatches a subagent.
- `post-job.sh`, `claim-job.sh`, and `gardener.sh` all **refuse** a
  `role: boatman` job on the ordinary board, loudly. A ferry cannot be
  race-claimed and pushed under the bot.
- The maintainer runs **`scripts/ferry.sh`** on their own machine, **outside
  the container**, with their own ambient git and gh session. No wrapper is on
  its PATH and no identity override is needed. The loop moves each directive
  `jobs/ferry/<name>.md` → `jobs/ferry/doing/` (claimed) →
  `jobs/ferry/done/` (completed). For each one it runs `claude -p` wearing the
  boatman role (`roles/boatman/AGENT.md`). A directive that does not complete
  stays in `doing/` for the maintainer to inspect. It is never silently retried.

The liaison can queue a ferry but cannot cause one to run. Only the
maintainer's own script, on the maintainer's own host, does that.

### 7.6.2 Authorization

The directive's frontmatter carries `downstream`, `downstream_branch`,
`upstream`, `upstream_base`, `upstream_pr` (filled once opened), `human` (the
name and email for attribution), an optional `convention`, and
**`identity_switch_authorized: true`**. **No agent may originate that flag;
only the maintainer writes it.** Ferrying is only ever done "when authorized"
(CLAUDE.md § The ferry). If any required field is missing, the boatman stops
with a blocked report and no completion marker.

Authorization is necessary, but it does not settle everything. The boatman
re-checks its **host preconditions** before acting: `gh auth status` must show
the human's account, and `gh api repos/<upstream> --jq .permissions` must show
push access. If either check fails, it completes with a blocked report and does
**not** fall back to pushing as the bot, even if SSH would succeed. The flag
authorizes a human-identity push, not a bot-identity one. A 2026-05-14 re-ferry
from the wrong host blocked exactly this way.

### 7.6.3 What the boatman does

Following `skills/pr-handoff/SKILL.md` and `skills/pr-formation/SKILL.md`:

- **Human author on every commit.** It overrides the worktree's bot-identity
  pin per commit with `git -c user.name=… -c user.email=… commit`, never by
  editing the config. It strips `Co-Authored-By:` trailers and bot footers, and
  verifies with `git log --pretty=fuller` and `git interpret-trailers --parse`.
- **One voice upstream.** Messy garden history is squashed into a clean series,
  one commit per logical change by default, following the project's
  `CONTRIBUTING.md` and PR template. A conflict between those rules and the
  boatman's own blocks the ferry rather than violating either.
- **Upstream's natural base.** The frozen base stays in the fork as the bot's
  audit record. The upstream PR targets `master` (or the equivalent) and is
  written as if a human contributor had authored it directly.
- **One cross-link, on the garden side only.** The boatman posts
  `Mirror of <upstream-PR-URL> (head <short-SHA>).` on the fork PR as the bot,
  and edits it in place on a re-ferry. Nothing is posted on the upstream PR,
  whose thread is reserved for human reviewers.
- **Record the mapping.** `scripts/jobs/record-mirror.sh <upstream>#<N>
  <garden>#<M> ferry` writes `pr-mirrors/…` on `journal2`, so the
  `garden-mirror-closer` service can close the fork PR when the upstream one
  closes. This step is required to complete the ferry.

`CLAUDE.md` mentions compound idioms such as *retcon and ferry #N*. However
such a phrase is worded, the two halves stay on separate surfaces. The retcon
is an ordinary board job that runs under the bot. The ferry is a directive
that waits for the maintainer's script.

## 7.7 Choosing a procedure

| Situation | Procedure | Entry point |
|---|---|---|
| A change should become a reviewed PR | Gauntlet (automatic on build/design completion) | `build X` / `design X`; explicit `run the gauntlet #N` |
| An existing draft PR needs review | Gauntlet | `run the gauntlet #N` → `post-gauntlet.sh` |
| B must wait for A to finish, nothing more | `blocked_on` | `post-plan.sh --blocked --blocked-on A B` |
| Several parts, ordered or parallel, with a failure policy | Orchestration | `post-plan.sh --orchestrated …` + `post-orchestration.sh` |
| A follow-up must wait until a design is *built* | Chained follow-up (D → N → F) | `post-job.sh D` + `post-plan.sh --blocked --blocked-on D N` |
| Approved work goes upstream under the maintainer | Ferry | directive in `journal/jobs/ferry/`, then `scripts/ferry.sh` on the maintainer's host |

## Quick reference

| Script | Role in the procedures |
|---|---|
| `scripts/jobs/gardening/ensure-pr.sh` | find-or-create the one draft PR for a job |
| `scripts/jobs/gardening/garden-pr.sh` | the supervised PR-editing scaffold (rebase, gates, evals, push, loop) |
| `scripts/jobs/gardening/safe-rebase.sh` | fresh-base rebase; lockfile-only recovery; fail-closed otherwise |
| `scripts/jobs/gardening/safe-push-pr-head.sh` | head push that never rewinds a peer's commits |
| `scripts/jobs/auto-gauntlet-handoff.sh` | completion edge: stage the gauntlet a producer owes |
| `scripts/jobs/post-gauntlet.sh` | record a staged gauntlet (`jobs/gauntlet/<g>.md`) |
| `scripts/jobs/gauntlet.sh` | leader-only driver: viability → clean → panel ⇄ fix → undraft |
| `scripts/jobs/gardening/panel.sh` | sense panel kind, fan seats, decide, loop, appellate, un-draft |
| `scripts/jobs/panel-run-record.sh` | durable compact panel record on `journal2` |
| `scripts/jobs/assert-producer-pr-draft.sh` | completion sensor for "opened ready by mistake" |
| `scripts/jobs/assert-panel-head-fresh.sh` | completion sensor for stale panel coverage |
| `scripts/jobs/design-pr-gauntlet-coverage-audit.sh` | hourly alert-only readiness audit |
| `scripts/jobs/post-plan.sh` | park a job (`--orchestrated`, `--blocked`, `--deferred`) |
| `scripts/jobs/post-orchestration.sh` | record an orchestration (`jobs/orch/<base>.md`) |
| `scripts/jobs/orchestrate.sh` | leader-only orchestration watcher |
| `scripts/jobs/unblock.sh` | promote `blocked_on` jobs when their blocker lands |
| `scripts/ferry.sh` | host-native ferry loop over `jobs/ferry/`, run by the maintainer |
| `scripts/jobs/record-mirror.sh` | record upstream ↔ fork-mirror PR mapping |
