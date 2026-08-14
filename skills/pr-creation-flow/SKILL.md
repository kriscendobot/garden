---
created: 2026-05-13
updated: 2026-07-29
author: gardener
---

# Skill: pr-creation-flow

The canonical procedure that ties a PR's lifecycle stages together: which stage
opens the PR, which stages touch it before the maintainer ever sees it, and which
stage decides it is ready for the maintainer's review queue. This is the **spine
of the gauntlet** — the end-to-end chain the gardening state machine
(`scripts/jobs/gardening/garden-pr.sh`, design
[`gardening-state-machine`](../../designs/gardening-state-machine.md)) drives.

In v1 an orchestrator agent (the now-retired steward, or the liaison) dispatched
one subagent per stage via the `Agent` tool and chained them by hand. In v2 the
chain is a **shell state machine a gardener supervises**: the gardener claims a
`build` (or `run the gauntlet`) job off the [job board](../job-board/SKILL.md),
runs the script, and reacts only to its terminal line or a `loop`/failure signal.
The script runs deterministic automation itself and shells `claude -p` only for
the genuine judgments (each panel seat's review, the disposition decision, the
appellate pass — all delegated to [`panel`](../panel/SKILL.md)).

This skill is the orchestration map: the order of stages and the rule that the
chain must run to termination, not stop at the first draft. Per-stage detail (how
to write a test, how to address a review thread, how to delete dead code) lives in
the per-stage skills this file links.

## Vocabulary: "the gauntlet"

The chain as a whole is **the gauntlet** (v1's "gamut" was erroneous and is not
used). "Run the gauntlet on #N" means resume the chain from wherever the PR
currently sits and chase it until the panel passes and the PR is un-drafted. It is
one of the triager's canonical PR-comment directives (per
[`roles/triager`](../../roles/triager/AGENT.md)): a `run the gauntlet #N` comment
posts a job a gardener claims. The procedure below does not change; the phrase is
just the directive the triager maps to the job.

## When to use

- A gardener claims a `build` job: the chain starts here (the build stage opens
  the draft PR, the rest of the chain advances it to un-draft).
- A gardener claims a `run the gauntlet #N` job: resume an existing draft PR from
  its next-stage-owed (see *The next-stage-owed heuristic*) and drive to un-draft.
- A cold PR opened by someone else needs a panel after the fact: the cleaner and
  panel stages still apply; only the build stage is skipped.

## Frozen base branches (fork-side)

Every PR the garden opens on a fork uses a **frozen base branch** named
`<base>-<short-sha>` (e.g. `master-abc1234`) — a snapshot of the upstream branch
pushed to the fork at PR-open time, with the PR's `base` field pointing at the
snapshot rather than the moving upstream branch. This isolates concurrent PRs from
each other's rebases: every PR sees its own frozen surface. The convention applies
to fork-side PRs only; an upstream PR (after a `ferry` job carries it upstream, per
[`pr-handoff`](../pr-handoff/SKILL.md)) uses upstream's natural branch. Full
procedure in [frozen-base-branch].

## One job, one PR (find-or-create)

The build stage does not run `gh pr create`. It runs
[`scripts/jobs/gardening/ensure-pr.sh`](../../scripts/jobs/gardening/ensure-pr.sh),
which owns the pairing of a job base to its pull request:

```sh
scripts/jobs/gardening/ensure-pr.sh <job-base> <owner/repo> <head-branch> <base-branch> \
  --title '<title>' --body-file <body-file>     # after the head branch is pushed
```

It looks for the job's PR two independent ways — the **head branch**, and a
`<!-- garden-job: <base> -->` **marker** it embeds in every body it writes — and
then: adopts the one it finds (creating nothing, exit 0, number on stdout);
creates one when there is none; or, finding **more than one**, prints them all and
exits 3 for a human or a gardener to resolve. It never guesses and never adds a
third. A discovery query that fails or may have been truncated is inconclusive
(exit 4, nothing created): a retry is cheap, a duplicate PR is not.

This exists because **a job can be claimed more than once** — a stranded worker,
a reaper requeue, a resumed claim — and idempotence must not rest on an agent
remembering. On 2026-07-28 `endo-sturdyref-agent-surface-build` was claimed four times:
an early stranded run opened `endojs/endo-but-for-bots#865` on an in-repo branch,
the completed run opened `#871` on the fork head, the two diverged (3 ahead /
5 behind), #865 went red on all four test-matrix legs, drew auto-shepherd
minting, and was closed by hand. The marker is what relates two incarnations that
share nothing else — not even a head branch.

It is the third of the deterministic guards around a re-claimed job's writes:
[`safe-push-pr-head.sh`](../../scripts/jobs/gardening/safe-push-pr-head.sh) stops
a stale worker from rewinding a peer's head, a claim fence stops a stranded one
from pushing at all, and this stops a re-claimed one from opening a second PR.
Push the head branch first; `gh pr create` needs the ref to exist.

The resulting number is stamped into the job's journal `work/<base>` record
(`pr_number:`), so a later call within the same claim resolves it with no GitHub
query. That record does not survive a reaper requeue — across incarnations the
durable converger is the marker, not the record.

## Draft discipline

**Every new PR the garden opens MUST be created in draft state** —
`ensure-pr.sh` is draft-by-default and only the ferry's *upstream* PR may pass
`--no-draft` — no exceptions, whatever opens it: a `build`, a `probe`,
a design PR, a stacked or initial-stub PR, or a maintainer-requested PR posted as a
job. This is the single most load-bearing rule in this skill (reinforced by the
maintainer, 2026-07-27): **opening a PR ready-for-review is a defect, because it
makes the gauntlet abort early.** The gardening state machine reads a non-draft PR
as "the bot-side chain already finished, nothing owed," so it **skips the
clean → panel → fixer-loop → un-draft chain entirely** and an *unreviewed* PR lands
straight in the maintainer's queue — the exact outcome the draft flag exists to
prevent. The draft flag is the load-bearing signal that the bot-side chain has not
yet finished; it is what *triggers* the gauntlet, not merely a status label. When in
doubt, open draft: an over-cautious draft costs nothing (the chain un-drafts it),
while a premature ready-for-review skips review on a PR nobody vetted.

**The panel stage is the only thing that moves a PR out of draft**
(`gh pr ready <N>`), and only when the panel-fixer loop terminates with no must-fix
items and the appellate pass has finished. Un-draft is **earned at the end of the
chain, never the starting state**. Draft state is enforced by GitHub itself (no
auto-requested reviewers, merge button disabled), which is why it is the
load-bearing state rather than an advisory label.

The lone deliberate exception is the *un-draft*, not the *open*: a **probe**
([`gap-revealing-build`](../gap-revealing-build/SKILL.md)) is opened draft like
everything else and is simply *meant to stay* draft (its chain deliberately does not
un-draft). So "open every PR draft" holds without exception; only which PRs later
leave draft varies.

## Flow ordering

```
build (ensure-pr.sh: finds or opens THE draft PR)
   |
   |  in concert (default), or before, or after
   v
assayer-step  (authors tests for this PR's contribution; same branch)
   |
   v
cleaner-step (coverage pass; dead-code removal; watch CI converge; same branch)
   |
   v
panel (scripts/jobs/gardening/panel.sh — senses code-vs-design panel,
       fans the jury seats, decides disposition)
   |
   |  on must-fix: the script's fixer stage pushes follow-up commits and
   |  re-runs the panel against the new head — the panel-fixer loop
   v
appellate pass (advisory; proposes promoting small-and-in-context deferrals
                to summary-fix before un-draft)
   |
   v
gh pr ready <N>  (panel.sh un-drafts; PR enters the maintainer's review queue)
```

All of the above are **stages of one script the gardener supervises**, not
separate dispatched agents. The panel-fixer loop lives entirely inside
[`panel`](../panel/SKILL.md); this file's job is the stage order around it.

### Variants

- **Cleaner-skipped tiny-PR variant.** When the PR is pure documentation, a
  lockfile-only churn, a one-file format sweep, or a single bug-fix line whose
  test fixture is already in the diff, the cleaner stage has no coverage surface
  to expand. The script skips it and runs the panel directly after the build
  stage. The panel still runs and un-drafts at the end of the loop.
- **Design-only-PR variant.** When every changed path is under `<project>/designs/`
  (or the project's design directory) with no source or test changes, the chain
  is **build → panel (design panel) → fixer loop → un-draft**. The assayer and
  cleaner stages are skipped (no test or source surface). `panel.sh` senses the
  design panel automatically (7 seats: critic, skeptic, decomplector, ergonomist,
  copyeditor, pedant, novice) per [`panel`](../panel/SKILL.md). The base of a
  design-only PR is the project's bot-fork roadmap branch; see *Designs versus
  implementations*. A design PR is usually opened not by a `build` but by a
  `design` job (a designer), or by a research/issue job that happens to carry a
  design — none of which is `role: builder`. So the gauntlet on a design PR is
  staged **at job completion, for any role**, not only for builds: when a job
  completes naming a bot-authored open **draft** design-only PR in its report,
  [`scripts/jobs/auto-gauntlet-handoff.sh`](../../scripts/jobs/auto-gauntlet-handoff.sh)
  records that PR's design gauntlet (`<owner>-<repo>-pr<N>-gauntlet`, PR-keyed so
  two producers on one design PR converge on one record), and
  [`scripts/jobs/assert-design-pr-gauntlet.sh`](../../scripts/jobs/assert-design-pr-gauntlet.sh)
  refuses to record the job complete until that record exists. This closes the
  review-miss cluster `garden-design-pr-gauntlet-bypass` (garden #7,
  endo-but-for-bots #809, minion.town #41), where the old `role: builder`-only edge
  let three design PRs reach the maintainer with no panel. The un-draft is still
  earned only by the panel at the end of the loop.
- **No must-fix on first panel round.** The fixer stage does not run; the panel
  declares the loop done after the first verdict, the appellate pass runs, then
  `gh pr ready <N>`.
- **Pre-merge fix-up rounds (after maintainer review).** A maintainer's
  `CHANGES_REQUESTED` triggers a fixer loop (fixer → CI-green → re-request the
  maintainer) but **not** a re-cleaner or re-panel by default. The PR stays out of
  draft; the maintainer's review queue is the venue. A maintainer who explicitly
  asks for a fresh cleaner or panel pass overrides this default.

## Designs versus implementations

Design PRs and implementation PRs are two separate PRs against two different
bases. Maintainer framing (2026-05-14): "We don't carry designs onto the master
branch. The designs should be based on llm. The implementations should be based on
master, for those designs."

- A **design PR** lands on the project's bot-fork roadmap branch (today `llm` on
  `endojs/endo-but-for-bots`). Its diff is the `designs/<slug>.md` file. It runs
  the *Design-only-PR variant* above.
- An **implementation PR** lands on the project's natural implementation base
  (today `master`). A separate `build` job opens it; its diff is the source change
  that realizes the design. It runs the full chain (build, assayer, cleaner, code
  panel, fixer loop, un-draft).
- A later `ferry` job carries the implementation upstream when the maintainer
  authorizes (per [`pr-handoff`](../pr-handoff/SKILL.md)).

The two PRs are intentionally not combined: a single PR carrying both the design
prose and the implementation source forces the maintainer to review documentation
alongside source diff, dilutes each panel's audience, and prevents the ferry from
carrying the implementation alone. The split also lets the code and design panels
review the two surfaces independently with the seat lists each shape warrants.

## Assayer placement

The assayer stage authors tests for *this PR's contribution*. Default placement is
**in concert with the build stage**: production change and pinning tests land on
the same branch, their commits touching disjoint files (production vs test). Two
other orderings are supported when the change's shape calls for them:

- **Before the build (TDD-style).** Tests that fail closed against current
  production code, then the production change makes them pass. Best fit: the
  contract is fully specified in the issue or design.
- **After the build (regression-coverage).** Production lands a draft PR, then the
  tests pin the regressions the change closes. Best fit: a bug fix whose contract
  is "the behavior described in the bug report."

The default is in-concert because the two surfaces share the branch and push
cleanly (disjoint files); TDD stretches time-to-first-CI-green, and
regression-after writes the test against code that already passes (less
load-bearing per [`regression-evidence`](../regression-evidence/SKILL.md)).

## Cleaner placement

The cleaner stage stands **between the build/assayer stages and the panel**, so
the panel reads the final shape (test surface expanded, dead code gone) rather
than a half-tested draft. Its remit: run a coverage pass on the touched
package(s) per [coverage-driven-testing], push coverage commits to the same
branch, watch CI converge to green (or only documented pre-existing infra red),
and report done. **The cleaner does not un-draft** — that authority belongs to the
panel. The cleaner is explicitly **not a juror**; its mutating work (writing and
running tests) does not fit the read-only review posture the panel seats hold. If
the PR is `CONFLICTING` against its base when the cleaner stage arrives, it does
not push coverage commits onto a non-mergeable head: the script surfaces a need
for a weave/rebase first (a `rebase`/`weave` job, per [conflict-resolution]).

## Panel composition

There are **two panels**: the code panel (~28 seats, for source-touching PRs) and
the design panel (7 seats, for design-only PRs). `panel.sh` senses which one
applies from the PR's file list (every changed path under a design directory →
design panel; otherwise code panel; ambiguity falls to the broader code panel).
The seat lists, the per-seat review procedure, the disposition rubric, the
panel-fixer loop, the appellate pass, and the un-draft step all live in
[`panel`](../panel/SKILL.md) and [`panel-review`](../panel-review/SKILL.md); the
jury seats themselves live under [`roles/jurors/<seat>/`](../../roles/jurors/).
The diff-signal recommender that emphasizes seats per the diff's shape is
[`panel-hints`](../panel-hints/SKILL.md).

The code panel additionally adds `@copilot` as a reviewer
(`gh pr edit <N> --add-reviewer @copilot`), fire-and-forget; the design panel does
not (its surface is prose, not code). This file does not repeat the seat lists —
[`panel`](../panel/SKILL.md) owns them so the library does not drift.

## The next-stage-owed heuristic

When a gardener claims a `run the gauntlet #N` job (or resumes a quiet draft PR),
it reads the **next stage owed** directly from GitHub state — not from journal
entries, which can lag. Reading order, top to bottom; the first match is the stage
owed:

1. **PR `CONFLICTING` against its base?** A weave/rebase is owed first (post or
   run a `rebase`/`weave` job). Re-evaluate after it lands.
2. **Already un-drafted?** Flow complete; the PR is in the maintainer's queue.
   Nothing owed.
3. **Panel passed (an `--approve`, or a `--comment` with no in-scope must-fix),
   no later push, but PR still draft?** The un-draft did not happen; run
   `gh pr ready <N>` and note the lapse.
4. **Panel verdict has must-fix items and no fixer push since?** The fixer stage
   is owed (it runs inside the panel-fixer loop).
5. **Fixer pushed since the last verdict and the panel has not re-run since?** A
   panel re-run is owed.
6. **Cleaner pushed and CI green, no panel verdict yet?** The panel is owed.
7. **Build's PR open and no cleaner push yet?** The cleaner is owed (default); on
   the tiny-PR variant skip it and run the panel; on the design-only variant skip
   the assayer and cleaner and run the design panel. The script decides the
   variant by inspecting the diff.

A *panel verdict* is a garden-authored formal `gh pr review` whose body matches the
panel-review shape (in-scope/out-of-scope, must-fix/should-fix). A plain
`gh pr comment` is not a panel verdict and does not advance the flow.

## Chaining is load-bearing

The single-stage stop (open a draft PR and leave it) is the **failure mode** this
skill exists to prevent. A draft PR with no role advancing it sits orphaned: the
garden opens drafts it never finishes, the maintainer's queue stays empty, and the
work never closes. In v2 the supervising gardener runs the script to its terminal
line precisely so the chain does not stall mid-way; if it claims a job and the
script stops before un-draft without a clear owed stage, that is a signal the
heuristic is missing a case — surface it over the [message bus](../message-bus/SKILL.md)
(`role/gardener` or `broadcast`) rather than guessing.

The gardener does not need per-PR maintainer authorization to advance a
garden-authored draft PR through its own chain; the chain is normal operation.
Authorization is only required for cross-repo etiquette actions (the ferry
handoff, replying on inline review threads, posting top-level PR comments) per
`roles/COMMON.md`.

## State on the PR

- **Draft vs ready-for-review** (load-bearing): draft = the chain is in progress;
  ready = the panel un-drafted and the maintainer's queue is next.
- **Labels** (advisory, optional): `state:building`, `state:cleaning`,
  `state:in-review`, `state:fixing`, `state:ready` for dashboards only. The script
  never makes a flow decision from a label alone — it keys on actual GitHub state
  (draft? has reviews? CI green?). Labels can be added or omitted without
  affecting correctness.

## Output

A PR driven through this chain ends out of draft, in the maintainer's review
queue, with a panel verdict on record and the panel-fixer loop terminated. The
gardener's job report (`jobs/tada/<base>` per [job-board](../job-board/SKILL.md))
names the PR, the panel kind (code/design), the number of fixer rounds, and the
un-draft.

## Pitfalls

- **A second PR for one job.** A `gh pr create` run by hand carries no memory of
  what an earlier incarnation of the same job did, so a re-claimed job opens a
  duplicate (#865/#871). Every PR-open goes through `ensure-pr.sh` per § One job,
  one PR. On its exit 3 (ambiguous), resolve the duplicate — close or retarget the
  strays so exactly one stays open — before advancing the chain; do not pick one
  and carry on, because the other keeps burning CI and attracting shepherd jobs.
- **A non-panel stage un-drafting** is a discipline violation. Only `panel.sh`
  un-drafts, and only after the loop declares done. A build stage that opens a PR
  ready-for-review (skipping draft) bypasses the whole chain; the first corrective
  action is `gh pr ready --undo <N>`.
- **The panel-fixer loop spinning on out-of-scope findings.** The loop's exit
  condition is "no in-scope must-fix," not "all complaints addressed." Non-must-fix
  dispositions (summary-fix, follow-up, acknowledge, drop) do not block the loop;
  see the disposition rubric in [`panel-review`](../panel-review/SKILL.md).
- **The cleaner pushing onto a CONFLICTING head.** The cleaner stage verifies
  `mergeable_state` first; if `CONFLICTING`, it surfaces a weave/rebase need and
  stops.
- **A follow-up push REWINDING a peer's newer commits.** The gauntlet may claim a
  PR long after a shepherd or fixer pushed CI fixes; if it works from a worktree
  that predates those commits, a plain `git push --force` rewinds the head to an
  ancestor and silently discards them (endojs/endo-but-for-bots #792, 2026-07-18:
  green head rewound to a strict ancestor, CI went red, the arc stalled until a
  manual restore). **Never `--force` a PR head.** Every head push — the state
  machine's CI push and any fixer/cleaner/assayer follow-up wired via
  `GARDEN_PANEL_FIXER` — goes through
  [`scripts/jobs/gardening/safe-push-pr-head.sh`](../../scripts/jobs/gardening/safe-push-pr-head.sh),
  which fetches the live head fresh, **refuses** to push a head that is behind
  (an ancestor of) or diverged from it (rc 3 — rebase onto the live head and
  re-run), and otherwise pushes with `--force-with-lease` keyed to the just-fetched
  sha. `garden-pr.sh` calls it automatically when `GARDEN_PR_REMOTE`/`GARDEN_PR_HEAD`
  are wired; a rebase/retcon that intends to rewrite history passes `--mode rewrite`
  (still refused for a strictly-behind head).
- **A maintainer's `CHANGES_REQUESTED` reactivating draft state.** It does not.
  After maintainer review the loop is fixer → CI-green → re-request the maintainer
  (no re-cleaner, no re-panel by default). The PR stays out of draft.

## Notes from the field

- _2026-07-29_: PR find-or-create moved off the agent into
  `scripts/jobs/gardening/ensure-pr.sh` (§ One job, one PR), after a job claimed
  four times left two divergent PRs for one change (`endojs/endo-but-for-bots#865` and
  `#871`) and a gardener closed the stray by hand.
- _2026-06-24_: translated from v1 for the v2 garden. The v1 chain was an
  orchestrator (steward/liaison) dispatching one subagent per stage via the
  `Agent` tool; v2 makes the chain a shell state machine a gardener supervises
  (`scripts/jobs/gardening/garden-pr.sh`), claimed as a `build`/`run the gauntlet`
  job off the board. The three v1 judge roles (solicitor/barrister/justice) and
  the appellate collapsed into [`panel`](../panel/SKILL.md)
  (`scripts/jobs/gardening/panel.sh`); the per-seat review procedure and
  disposition rubric live in [`panel-review`](../panel-review/SKILL.md). v1's
  "gamut" is rendered "gauntlet" throughout. The historical seat-expansion
  narrative (the 2026-05-14 → 2026-05-21 seat-count growth from 6 to ~26 code-panel
  seats and 5 to 7 design-panel seats) is preserved in
  [`panel`](../panel/SKILL.md), the single site that owns the seat lists, so the
  count does not drift across files.
