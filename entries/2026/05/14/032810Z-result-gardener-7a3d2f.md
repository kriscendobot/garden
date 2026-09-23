---
ts: 2026-05-14T03:28:10Z
kind: result
role: gardener
refs:
  - entries/2026/05/14/032134Z-dispatch-liaison-62d647.md
---

# Result: garden-ab-evaluation skill + evaluator role

Landed the A/B evaluation skill and a new `evaluator` role to consume it. The skill captures the four-step procedure from the maintainer's 2026-05-14 framing: prepare two isolated dispatch roots at historical and current garden refs, replay the same design end-to-end through `skills/pr-creation-flow/SKILL.md` in each, dispatch the evaluator blinded to compare both replays against the landed reference, and recommend a course of action.

## Files

- `skills/garden-ab-evaluation/SKILL.md` (new): the procedure, inputs, output shape, pitfalls (contamination, non-determinism, anchoring bias, replay-PR pollution, cost, design-selection bias), and follow-up items.
- `roles/evaluator/AGENT.md` (new): the read-and-judge posture that consumes the skill. Authority bounds preclude role/skill edits, sub-dispatches, and external-repo comments; deliverable is one blinded `result` plus one unblinded follow-up.
- `CLAUDE.md` (edit): inventory adds `evaluator` to roles and `garden-ab-evaluation` to skills.
- `roles/liaison/AGENT.md` (edit): adds an operating norm naming when to orchestrate the evaluation (after substantive meta-evolution; on maintainer ask).
- `roles/steward/AGENT.md` (edit): documents the asymmetry. The steward does not dispatch the evaluator; the engagement is rare, maintainer-initiated, and produces meta-evolution input that lives outside the steward's authority bounds.

## Routing decision

A new `evaluator` role rather than inlining into the gardener. Rationale captured inline in `skills/garden-ab-evaluation/SKILL.md` § Notes on routing:

1. The evaluator's posture is read-and-judge, distinct from the gardener's meta-evolution authorship. The gardener lands changes; the evaluator hands recommendations off.
2. The gardener cannot dispatch sub-subagents per its role file. Wedging this procedure into a gardener engagement would either bloat the gardener's authority or require the gardener to re-enter the liaison's surface.
3. The procedure is large enough (four steps, around 13 to 20 subagent dispatches per A/B pair, blinding discipline) that a dedicated role keeps the gardener uncontaminated by per-evaluation context.

The liaison drives the dispatch fanout (per the new liaison norm); the evaluator does the comparison; the gardener (or the liaison directly) lands any recommended meta-evolution.

## Commits

- main: `2cdbe47` — skills: garden-ab-evaluation + role: evaluator
- main: `e361b5d` — inventory + liaison/steward interlock: enumerate garden-ab-evaluation and evaluator
- journal: (this entry; sha lands at push time)

## Out of scope confirmation

- No `--garden-ref` extension to `dispatch-prepare.sh`. The manual `git reset --hard` workaround is documented in the skill's § Step 1 and the script extension is named as a follow-up engagement in § Follow-ups.
- No evaluation runs. The skill is unvalidated in practice; the first real run will produce a notes-from-the-field entry.
- No role changes beyond the new `evaluator`.

## End-to-end confirmation

A future dispatch can read `skills/garden-ab-evaluation/SKILL.md` and `roles/evaluator/AGENT.md`, prepare two dispatch roots per § Step 1 (with the documented manual ref-pin workaround), dispatch the two replay chains and the blinded evaluator, and produce a comparison `result` entry whose shape is named in § Output. The skill cites all referenced playbooks by relative path: `pr-creation-flow`, `dispatch-worktree`, `context-library`, `journalism`, `journal-sync`, `self-improvement`, `em-dash-style`, `relative-paths`.

Self-improvement: the routing decision (evaluator vs. gardener-inline) generalized from the gardener-can-not-dispatch constraint named in `roles/gardener/AGENT.md`; future skills whose procedure spans multiple subagent dispatches should default to a dedicated role rather than a gardener engagement unless the procedure is small enough to fit one writer's authority.
