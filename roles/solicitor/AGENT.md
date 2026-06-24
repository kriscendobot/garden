---
created: 2026-05-21
updated: 2026-06-24
author: gardener
---

# Role: solicitor (the design-panel stage of the scripted panel)

The judicial stage for **designer work**: the seven-seat **design panel** run over a design-only PR (paths only under a `designs/` directory, no source or tests touched). The PR is a written artifact and the panel reviews it as such.

In v2 this is not a dispatched agent. It is the design-panel branch of the gardener-supervised panel state machine (`scripts/jobs/gardening/panel.sh`), per [`designs/judicial-workflow.md`](../../designs/judicial-workflow.md). The script senses the design-only kind from the diff and selects the seven-seat list; a gardener supervises the run and reacts to its terminal line. This file documents the design-panel composition and the design-stage discipline the script carries.

Like the prior judge, the design panel has no foreperson that itself reviews: the script fans one `claude -p` per seat and a separate `claude -p` decides the disposition. Keeping the aggregation off the review surface is what lets the panel stay honest.

## Skills

- [panel](../../skills/panel/SKILL.md): the scripted panel workflow; the design panel is its 7-seat branch.

## The design panel

Seven seats, fanned concurrently by the script (each briefed with `roles/jurors/<seat>/AGENT.md` and the diff):

- [critic](../jurors/critic/AGENT.md): substantive critique of the proposed approach.
- [skeptic](../jurors/skeptic/AGENT.md): adversarial premise attacks.
- [decomplector](../jurors/decomplector/AGENT.md): Rich-Hickey-lens reading.
- [ergonomist](../jurors/ergonomist/AGENT.md): interface ergonomics on the proposed surface.
- [copyeditor](../jurors/copyeditor/AGENT.md): prose mechanics.
- [pedant](../jurors/pedant/AGENT.md): formal style (Chicago Manual + the garden's own rules).
- [novice](../jurors/novice/AGENT.md): top-down clarity as a naive reader.

No Copilot reviewer fire (the design surface is prose).

## Stage discipline

- **Pre-run state check.** Before fanning the panel, confirm the PR is `OPEN` and still `isDraft`; a PR that was closed or un-drafted since the gauntlet decided to run the panel short-circuits to a no-op. This is the script's first step.
- **Disposition decision.** The script's decide step reduces the panel's findings to the load-bearing binary: does any concrete request-changes (`must-fix`) finding remain (loop) or not (`pass`)? On a design-only PR a fixer round edits the design text and the panel re-runs; designer edits to a design document are still design content, so the re-run stays on the design panel.
- **External-author calibration.** When the PR's GitHub `author.login` is not the host's bot identity, the decide step downgrades findings that cite the house prose-style rules (em-dash, no-Latin-shorthand) to `drop`, and proposed-rule findings escalate to the improver/watchman for the garden's adoption rather than being bundled into a project-side ask.
- **Appellate pass on termination.** On `pass`, the script runs the appellate hook over the passing aggregate to propose promoting small-and-in-context deferrals; the proposals are advisory and do not block the un-draft.
- **Terminate by un-drafting.** On `pass`, the script runs the un-draft hook (`gh pr ready <N>`) and prints one terminal line.
- **No pushes to the PR branch.** The panel stage submits the review, runs the appellate, and un-drafts; it does not author commits. The fixer stage owns commits.

## Definition of done

- The design panel ran, the disposition decided `pass`, the appellate pass ran on the terminating round, and the PR is un-drafted; OR the loop iterated to a fixer stage on a `must-fix` round.
- The supervisor's terminal line names the panel kind (`design-panel`), the round count, and the un-draft. Per-seat verdicts stay on disk in the run dir, out of the supervisor's context.
