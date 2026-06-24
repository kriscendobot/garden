# Design: the judicial workflow as a supervised shell state machine

| Created | 2026-06-24 |
| Author  | gardener |
| Status  | Proposed |

The v1 garden ran a PR's review through a **judicial** workflow: an orchestrator
agent (liaison or steward) dispatched one of three judge roles — `solicitor`,
`barrister`, `justice` — each of which fanned out a jury of subagents (one per
seat), aggregated their per-juror blocks by hand, decided dispositions, looped to
a fixer when changes were required, and finally un-drafted the PR. An
`appellate` ran between the terminating verdict and the un-draft. The whole
control flow lived in an agent's context, walked as a checklist.

This generation keeps the *same workflow* but moves the **state machine into a
shell script** (`scripts/jobs/gardening/panel.sh`) that a gardener supervises,
consistent with `designs/gardening-state-machine.md`. The script runs the
deterministic parts itself and shells out to `claude -p` only for the genuine
**judgments**. The agent-context skill counterpart is `skills/panel/SKILL.md`.

## What was deterministically scripted vs left to `claude -p`

The dividing line is the gardening-state-machine principle: mechanical steps are
the script's job; only real judgment calls reach an LLM.

**Deterministic (the script does it):**

- **Panel-kind discrimination.** Diffing `<base>...HEAD` and classifying the PR
  as design-only vs source-touching is a path test, not a judgment. v1 made the
  orchestrator do this "mechanically"; the script does it in `sense_panel_kind`.
- **Seat fan-out and collection.** Iterating the seat list, shelling one review
  per seat, filing each block to the run dir, and concatenating the round's
  aggregate are bookkeeping.
- **The loop itself.** "While the disposition is must-fix, run the fixer and
  re-review" is control flow, not a decision. The script owns the iteration,
  the round counter, and the convergence safety bound.
- **Termination.** Calling the un-draft hook and emitting the terminal line is
  mechanical once the decision says `pass`.

**Judgment (shelled to `claude -p`, each overridable by a test hook):**

- **Each seat's review** (`GARDEN_PANEL_SEAT`). A juror reads its brief and the
  diff and produces a verdict block. This is irreducibly an LLM task.
- **The disposition decision** (`GARDEN_PANEL_DECIDE`). Aggregating the seats'
  verdicts into one of `must-fix` / `pass` is the v1 judge's foreperson role —
  applying the disposition rubric. Reduced here to the load-bearing binary: does
  any concrete request-changes finding remain (loop) or not (terminate)?
- **The appellate pass** (`GARDEN_PANEL_APPELLATE`). Reading the passing verdict
  and conservatively proposing promotions is judgment, kept advisory.

The test hooks (`GARDEN_PANEL_SEAT`, `GARDEN_PANEL_DECIDE`,
`GARDEN_PANEL_APPELLATE`) let the script's control flow be exercised non-
interactively, the same pattern `garden-pr.sh` uses with `GARDEN_DECIDE`.

## Panel-kind discrimination

Two panel kinds, carried over verbatim from v1's jury composition:

- **Code panel — 26 seats** for source-touching PRs: assessor, typist, stylist,
  packager, archivist, prover, curator, migrator, locksmith, warden, saboteur,
  breaker, purist, spec-keeper, wire-watcher, engine-realist, integrator,
  benchmarker, changeset-auditor, surfacer, scribe, pruner, gateway,
  corner-prober, fast-checker, releaser.
- **Design panel — 7 seats** for design-only PRs (every changed path under a
  design directory or matching `DESIGN*.md`): critic, skeptic, decomplector,
  ergonomist, copyeditor, pedant, novice.

The script senses the kind from the diff and selects the matching seat list. On
*any* ambiguity (missing base ref, git error, empty diff) it falls to the code
panel — the broader, safer panel — mirroring `sense.sh`'s standing bias toward
false positives over false negatives. v1's richer `panel-hints` signal-gating
(firing only the subset of seats whose lens has a diff signal) is deliberately
*not* reproduced in this first cut: the script runs the full panel for the kind.
Signal-gated seat selection is a future refinement that can plug into the seat-
list selection step without touching the loop.

## The fixer-loop

v1's jury-fixer loop iterated: a judge's request-changes verdict (any must-fix-
loop disposition) drove a fixer dispatch with the must-fix items inline; after
the fixer pushed, the panel re-ran (the `justice`'s re-review of the delta) and
the loop continued until a round produced no must-fix items.

The script collapses the three judge roles into one loop because their only real
difference was the *briefing* — `barrister` briefed the panel fresh on the first
round; `justice` briefed it with the prior verdict and the fixer's delta. In the
script, that difference is carried by the seat prompt and the diff base, not by a
separate dispatched role. Each iteration is one round; the round counter and a
`GARDEN_PANEL_MAX_ROUNDS` safety bound guard against non-convergence (a loud
failure, not a silent exit). The fixer invocation is a clearly-marked pluggable
hook (`GARDEN_PANEL_FIXER`, default no-op) because *which* fixer to dispatch and
how is project-specific.

## The appellate step

v1's `appellate` ran after a terminating verdict and before the un-draft, to
appeal small-and-in-context `follow-up` / `acknowledge` items into `summary-fix`
so they were not lost to the deferral surface. In the script it is a single
`claude -p` over the passing round's aggregate, run on the terminating round
only. Its output is conservative promotion proposals that land in the run dir and
are **advisory**: they do not block the un-draft. The hook is skippable
(`GARDEN_PANEL_APPELLATE=:`), matching v1's "the orchestrator may skip the
appellate when there is nothing to appeal."

## The termination condition

The loop terminates when the disposition decision returns `pass` — i.e. no
concrete request-changes (must-fix) finding remains. That is exactly v1's loop-
exit rule ("no must-fix-loop items remain after the panel round"). On
termination the script runs the appellate pass, calls the un-draft hook (v1's
`gh pr ready <N>`, left pluggable so the project supplies the identity-bearing
call), and prints one terminal line. Per the quiet-on-success contract, that
single line — passed + un-drafted — is the only thing the supervisor normally
sees; every per-seat verdict stays on disk in the run dir.

## Vocabulary fix

v1 called the end-to-end PR-creation chain **"the gamut"** ("run the gamut on
#N"). v2 renames it the **"gauntlet."** The script, `skills/panel/SKILL.md`, and
this note use "gauntlet" / "panel" throughout; the panel workflow is the review
segment of the gauntlet.

## What the script owns and the supervisor evolves

The reusable parts — the panel/fixer loop, panel-kind sensing, quiet-on-success
discipline, diverted tracing, and the per-seat fan-out — are the script. The
project-specific parts are pluggable hooks the supervisor wires: the fixer
invocation, the un-draft call, and (optionally) reduced or signal-gated seat
lists. When a stage fails in a fixable way, the supervisor edits the script and
re-runs — the state machine is data the supervisor owns, per the gardening-state-
machine design.
