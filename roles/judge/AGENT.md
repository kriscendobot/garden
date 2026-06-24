---
created: 2026-05-14
updated: 2026-06-24
author: gardener
---

# Role: judge (collapsed into the scripted panel workflow)

In v1 the `judge` role orchestrated a jury panel over a PR: it discriminated the panel kind, fanned out one subagent per seat, aggregated their verdicts, decided dispositions, looped to a fixer while changes were required, and un-drafted on termination. It had already split into three specializations (solicitor / barrister / justice) plus an appellate.

In v2 the **whole judicial control flow is a shell state machine** (`scripts/jobs/gardening/panel.sh`) that a **gardener supervises**, per [`designs/judicial-workflow.md`](../../designs/judicial-workflow.md). The script runs the deterministic parts (panel-kind discrimination, seat fan-out and collection, the fixer loop, termination) itself and shells to `claude -p` only for the genuine judgments (each seat's review, the disposition decision, the appellate pass). There is no separately dispatched judge agent; the gardener invokes the panel script as the review stage of the gauntlet and reacts only to its terminal line or a `loop` / failure signal.

The three v1 judge specializations and the appellate are retained as role files because they document *which seats, which briefing, which diff base* the script uses at each point in the panel→fixer loop. They are stage descriptions for the gardener supervising the script, not dispatchable agents.

## Skills

- [panel](../../skills/panel/SKILL.md): the scripted jury-panel workflow this role collapsed into. Canonical for the per-seat fan-out, the disposition decision, the fixer loop, the appellate pass, and the un-draft termination.

## Panel-kind discrimination (now deterministic)

The script senses the panel kind from the diff, not an agent:

1. **Design-only PR** (every changed path under a design directory, `designs/*.md`, `*/designs/*.md`, or matching `DESIGN*.md`) → the **design panel** (7 seats; the solicitor's surface).
2. **Source-touching PR, first round** → the **code panel** (26 seats; the barrister's surface).
3. **Source-touching PR, re-run after a fixer push** → the same code panel, briefed with the prior verdict and the fixer's delta (the justice's surface).

On *any* ambiguity (missing base ref, git error, empty diff) the script falls to the code panel, the broader and safer panel, mirroring `sense.sh`'s bias toward over-reviewing.

## Mapping

| v1 role | v2 stage in `panel.sh` |
|---|---|
| solicitor | the design-panel branch of seat selection |
| barrister | the first iteration of the loop on the code panel |
| justice | the loop's subsequent iterations (re-review of the delta) |
| appellate | the appellate pass on the terminating round |
| the jury seats | the per-seat `claude -p` fan-out over `roles/jurors/<seat>/` |
| disposition rubric | the disposition decision (`must-fix` \| `pass`) |

The three judge roles collapse into one loop because their only real difference was the briefing (first round vs delta re-review), now carried by the seat prompt and the diff base rather than a distinct role.

## Vocabulary

v1 called the end-to-end chain "the gamut"; v2 calls it the **gauntlet**. The panel workflow is the review segment of the gauntlet.
