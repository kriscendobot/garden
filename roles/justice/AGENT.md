---
created: 2026-05-21
updated: 2026-06-24
author: gardener
---

# Role: justice (the code-panel re-run rounds of the scripted panel)

The judicial stage for **fixer work**: the **re-run rounds** of the twenty-six-seat code panel over a source-touching draft PR after a fixer has pushed in response to a prior panel verdict. Each seat is briefed with the prior verdict and the fixer's response so it verifies the prior `must-fix` items are addressed and surfaces any *new* in-scope findings the fix introduced.

In v2 this is not a dispatched agent. It is the loop's subsequent iterations in the gardener-supervised panel state machine (`scripts/jobs/gardening/panel.sh`), per [`designs/judicial-workflow.md`](../../designs/judicial-workflow.md). The distinction from the [barrister](../barrister/AGENT.md)'s first round is the **briefing**: the script briefs each seat with the prior verdict and diffs against the prior head (the fixer's delta), not the whole PR. That difference is carried by the seat prompt and the diff base, which is why the three v1 judge roles collapse into one loop.

## Skills

- [panel](../../skills/panel/SKILL.md): the scripted panel workflow; the justice surface is its loop re-run rounds.

## The code panel

Same twenty-six seats as the [barrister](../barrister/AGENT.md) § The code panel; same idempotent Copilot reviewer re-add on the re-run rounds. See that file for the seat list.

## Stage discipline

- **Pre-run state check.** Confirm the PR is `OPEN` and still `isDraft` before fanning the panel; a PR closed or un-drafted since the gauntlet decided to re-run short-circuits to a no-op.
- **Delta briefing.** Each seat's prompt cites the prior verdict, the fixer's response and the commits since the prior head, and the seat's primary surface. The seat reads the prior verdict to know what was contested, the fixer's response to know what was addressed, then the diff *delta* for what changed and any new in-scope findings. The script diffs against the prior head rather than the PR base so earlier-round signals the prior round already covered are not re-fired.
- **Verify prior must-fix items.** Each seat opens with a one-line closure status per prior must-fix item on its surface ("addressed at SHA `abc123`" / "deferred with rationale" / "not addressed" / "fix introduces new finding X"); the disposition decision rolls these into a per-finding closure status before any new findings.
- **Disposition decision and loop exit.** The script's decide step returns `must-fix` (loop again via a fixer stage) or `pass` (terminate). The loop exits when no further `must-fix` finding remains. A `GARDEN_PANEL_MAX_ROUNDS` safety bound guards against non-convergence (a loud failure, not a silent exit). A finding that recurs across rounds with the same disposition is demoted to a deferral rather than iterated on forever.
- **External-author calibration.** Same as the barrister: house-prose-style findings downgrade to `drop` on external-author PRs; proposed-rule findings escalate to the mentor/watchman.
- **Termination.** On `pass`, the script runs the appellate pass on the terminating round and un-drafts via `gh pr ready <N>`.
- **No pushes to the PR branch.** The panel stage reviews and un-drafts; the fixer stage owns commits.

## Definition of done

- The re-run round ran with the delta briefing, each prior must-fix item has a recorded closure status, and the disposition decided either `must-fix` (the loop continues) or `pass` (the appellate pass ran and the PR un-drafted).
- The supervisor's terminal line names the panel kind (`code-panel`), the round number (the justice's first round is round 2 by definition), and the outcome. Per-seat verdicts stay on disk in the run dir.
