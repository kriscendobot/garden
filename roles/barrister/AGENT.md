---
created: 2026-05-21
updated: 2026-06-24
author: gardener
---

# Role: barrister (the first code-panel round of the scripted panel)

The judicial stage for **builder work**: the **first round** of the twenty-six-seat code panel over a source-touching draft PR after the cleaner stage has run. The PR carries the builder's initial implementation (and the cleaner's coverage additions); this is the first formal review the gauntlet produces.

In v2 this is not a dispatched agent. It is the first iteration of the gardener-supervised panel state machine on the code panel (`scripts/jobs/gardening/panel.sh`), per [`designs/judicial-workflow.md`](../../designs/judicial-workflow.md). The script senses the source-touching kind, selects the code-panel seat list, fans one `claude -p` per seat with no prior verdict to cite (the fresh-briefing distinction from the [justice](../justice/AGENT.md)), and decides the disposition. This file documents the code-panel composition and the first-round briefing the script carries.

## Skills

- [panel](../../skills/panel/SKILL.md): the scripted panel workflow; the code panel is its 26-seat branch.

## The code panel

Twenty-six seats, fanned concurrently by the script (each briefed with `roles/jurors/<seat>/AGENT.md` and the diff):

assessor, typist, stylist, packager, archivist, prover, curator, migrator, locksmith, warden, saboteur, breaker, purist, spec-keeper, wire-watcher, engine-realist, integrator, benchmarker, changeset-auditor, surfacer, scribe, pruner, gateway, corner-prober, fast-checker, releaser.

Plus the fire-and-forget Copilot reviewer add (`gh pr edit <N> -R <owner>/<repo> --add-reviewer @copilot`).

v1's `panel-hints` signal-gating (firing only the subset of seats whose lens has a diff signal) is **not** reproduced in this first cut: the script runs the full code panel. Signal-gated seat selection is a future refinement that plugs into the seat-list selection step without touching the loop.

## Stage discipline

- **Pre-run state check.** Confirm the PR is `OPEN` and still `isDraft` before fanning the panel; a PR closed or un-drafted since the gauntlet decided to run short-circuits to a no-op.
- **First-round briefing.** This is the first code-panel round: each seat approaches the PR fresh, with no prior verdict to cite. The delta-briefed re-runs are the [justice](../justice/AGENT.md)'s surface (the loop's later iterations).
- **Disposition decision.** The script's decide step reduces the panel's findings to `must-fix` (loop) or `pass` (terminate). On `must-fix`, the script invokes the fixer hook with the must-fix items and re-runs the panel against the new head; that re-run is the justice surface.
- **External-author calibration.** When the PR's `author.login` is not the host's bot identity, the decide step downgrades house-prose-style findings (em-dash, no-Latin-shorthand) to `drop` and escalates proposed-rule findings to the improver/watchman rather than bundling them into a project-side ask.
- **Termination.** On a (rare but valid) first-round `pass`, the script runs the appellate pass and un-drafts via `gh pr ready <N>`.
- **No pushes to the PR branch.** The panel stage reviews and un-drafts; the fixer stage owns commits.

## Definition of done

- The first code-panel round ran and decided either `must-fix` (the loop continues into the justice's re-run via a fixer stage) or `pass` (the appellate pass ran and the PR un-drafted).
- The supervisor's terminal line names the panel kind (`code-panel`), the round, and the outcome. Per-seat verdicts stay on disk in the run dir.
