---
ts: 2026-05-14T03:21:34Z
kind: dispatch
role: liaison
project: garden
to: "*"
---

# Dispatch: gardener designs the garden-effectiveness A/B evaluation skill

Dispatch root: `dispatches/gardener--garden-ab-evaluation-skill--20260514-032134--62d647/`.

Maintainer's framing (forwarded verbatim):

> I would like to propose a new skill for evaluating the effectiveness of the garden as it accumulates an increasingly useful library and integrates experiences into its roles and skills. This would also enable us to do A/B testing for improvements on skills. The trick is to check out the garden at a historical version and task a subagent to implement a design end to end, carrying the PR from inception to taking out of draft for the first user review. Then, the agent assesses the difference between the product and the version of that design that ultimately landed. Then, we task another subagent with the same design with the latest (or an interesting variation) of the current garden and similarly evaluate the end result. The ultimate evaluation compares the difference between the amount of unanticipated feedback and which product better represented the user's interests. Then, we would finally recommend a course of action to improve the garden. If a historical version outperforms the latest version, we may need to reassess how roles and skills are indexed, or perform more jobs with more concurrent roles with non-overlapping areas of focus.

## Task

Design a new skill at `skills/<slug>/SKILL.md` capturing the evaluation procedure. Slug suggestion: `garden-ab-evaluation` (or `garden-effectiveness-eval`; gardener's call). The skill is consumed by whichever role drives the evaluation engagement (likely a new role too — see "Open question" below).

### Required structure

- **Purpose** (one paragraph). What the skill enables; the maintainer's framing in one sentence.
- **Inputs**. The design under test (a `designs/<slug>.md` plus the PR-shaped artifact that ultimately landed); the historical garden version (a git ref on `kriskowal/garden@main`); the current or variant garden version (another ref). Optional: the dispatching role's working notes on what "user interest" looks like for this design.
- **Procedure**. The four-step shape the maintainer outlined:
  1. Prepare two isolated environments: a worktree triple where `garden/` is checked out at the historical ref, and another where `garden/` is at the current/variant ref. (The existing `scripts/dispatch-worktree/dispatch-prepare.sh` does not support a non-`main` garden ref directly; document the workaround — either `git -C garden checkout <ref>` after the prepare, or extend `dispatch-prepare.sh` to accept a `--garden-ref <ref>` flag. If the latter, name it as a follow-up.)
  2. Dispatch one subagent in each environment with the same design brief. The subagent's task: implement the design end-to-end from inception through opening the PR to taking it out of draft for the first user review (per `skills/pr-creation-flow/SKILL.md`).
  3. Once both subagents return: a third subagent (or the dispatching role inline) reads both produced PRs against the ultimately-landed PR. Compares: file structure, design alignment, test coverage, the *amount of unanticipated feedback* the real maintainer's review surfaced on the landed version (which becomes a proxy for "gaps the bot missed"), and *which product better represented the user's interests* (qualitative, judgment call documented inline).
  4. Recommend a course of action. If the historical garden outperforms the latest, the recommendation likely names a role / skill / cadence change. If the latest outperforms, the recommendation is "the evolution is paying off; continue."
- **Output shape**. A journal `result` entry from the evaluation role naming both produced PRs, the comparison table (file count / test count / build success / review-feedback volume), the qualitative "user-interest fidelity" judgment, and a one-paragraph recommendation.
- **Pitfalls**. Subagent context contamination (a subagent run with the current garden has seen the current journal; the historical-garden subagent should NOT see the current journal — its worktree triple's `journal/` should be checked out at the same historical ref, or otherwise scoped). Reproducibility: the dispatched subagents are non-deterministic; running each two or three times and aggregating the results may be necessary for a confident verdict on a single A/B pair. Anchoring bias: if the evaluator knows which version is historical vs current, the read of "user-interest fidelity" can drift toward the version expected to win; consider blinding the comparison step.
- **When to use**. After a meaningful evolution lands (a new role, a substantive skill rewrite, a refactor of multiple roles' interlocks); periodically as a "are we improving" sanity check; in response to a maintainer-flagged regression.

### Open question for the gardener to answer in the skill

Does the evaluation procedure warrant a **new role** (e.g. `evaluator`, `assessor`, `auditor`) whose dispatch the skill formalizes, or does it run as an extension of `scholar` (which already grows the index of project doc) or the `gardener` itself? The maintainer's framing emphasizes recommendation-of-improvement, which is closer to gardener-side meta-evolution than scholar-side index-growing.

The gardener's recommendation is one of:
- "Evaluation runs as a `gardener` engagement; the skill is dispatched on-demand by the liaison." (Simplest; no new role.)
- "A new `evaluator` role with the dispatch-prepare procedure built-in; the skill is the procedure the role consumes." (Cleaner separation; one more role to maintain.)

Land whichever shape you find cleaner. Document the trade-off inline so a future gardener pass can revisit.

### Inventory + interlock

- `CLAUDE.md` § Current inventory: add the new skill (and the new role if you author one).
- If a new role lands, add it to `roles/steward/AGENT.md` § Subordinate roles dispatched. The trigger is rare and maintainer-initiated; document accordingly.
- `roles/liaison/AGENT.md`: a one-line norm naming when the liaison dispatches the evaluation (after a substantive meta-evolution; on maintainer ask).

## Out of scope

- Do NOT actually run an evaluation in this dispatch. Skill design only.
- Do NOT modify `scripts/dispatch-worktree/dispatch-prepare.sh` to add a `--garden-ref` flag in this dispatch; either find a workaround in the skill or note the follow-up.
- Do NOT propose role changes beyond a possible new `evaluator` role.

## Style and discipline

Em-dash sweep, frontmatter, relative paths. Cite existing skills (`pr-creation-flow`, `context-library`, `journalism`) where the design references them. Do not invoke `Agent`.

## Commits

Suggested split on `main`:
- `<slug>: <new evaluation skill> (per maintainer 2026-05-14 framing)`
- If a new role lands: `role: <name> (consumer of the evaluation skill)`
- `inventory and liaison norm: enumerate the evaluation skill (and role if applicable)`

Push at end. One journal commit (result entry).

## Report

Skill path, role name if you authored one (or "no new role" with one-sentence justification), commit SHAs (main + journal), the gardener-or-evaluator routing decision, one-line confirmation that a future dispatch can read the skill and run an end-to-end evaluation.
