---
ts: 2026-05-15T01:50:12Z
kind: dispatch
role: liaison
to: gardener
---

# Dispatch gardener: carve role `general-contractor`

Dispatch root: `dispatches/gardener--a8e396`.

The maintainer wants a new long-lived orchestrator role that maintains up to three concurrent PR-pipeline slots, each one taking a design from selection through gamut-completion. The maintainer's framing:

> Each subagent will be a builder who will be responsible for identifying an eligible design to build. If the chosen design has clear prerequisites among the unfinished designs, the builder is to walk the chain of dependencies until it finds a design that hasn't started yet, or try again. If the dependency has an implementation PR, the builder is to implement their design based on a merge of all its dependency PRs, in a stack. The builder will implement the design and then run the gamut for their PR, until done. If, when searching for a design to build on, you find an unfinished PR, you are to help it along.

The liaison will adopt this role for the next four days running in the foreground.

Task: author `roles/general-contractor/AGENT.md` plus any supporting skills, and update `CLAUDE.md` § Current inventory. Decide the shape per the requirements below; do not feel bound to specific interpretations.

Requirements the role must encode:

1. **Slot model**. Up to three concurrent PR-pipeline slots. Each slot lives in the journal (e.g. `journal/contractor-slots/<host>/slot-<N>.md`) so state survives across cycles. Slot fields: status, design path, PR number, current stage, in-flight dispatch id, last-update timestamp.

2. **Per-cycle procedure**.
   - Survey: read the three slot files, drain inbox, sync journal.
   - Advance: for each slot whose in-flight dispatch has returned, dispatch the next-stage-owed per `skills/pr-creation-flow/SKILL.md` § The next-stage-owed heuristic.
   - Refill: for each empty slot, first look for any stuck garden-authored draft PR on the active repo (today `endojs/endo-but-for-bots`) and adopt it; otherwise pick a fresh design from the roadmap branch.
   - Journal: write a cycle-summary `result` entry naming the three slots' current states.
   - Schedule: pick next wake per `skills/autonomous-loop-pacing/SKILL.md` (active mode under 1800s when any slot is in-flight; idle 1800s otherwise).

3. **Design selection with dependency walking**. Pick the next-eligible design from the active repo's roadmap branch (today `endojs/endo-but-for-bots` on `llm`). Use the existing `skills/design-to-pr-pipeline/SKILL.md` § What counts as covered rule plus `skills/design-queue-drift-check/SKILL.md` § eligibility filter. New requirement on top of those: if a chosen design depends on another unfinished design, walk the dependency chain until landing on one whose deps are all satisfied (merged) or in-flight (have an open PR the contractor can stack on). If a dep has neither a started design nor an implementation PR, walk to the dep instead and build it first.

4. **Stacked-PR builds**. When a chosen design's deps have open implementation PRs (not yet merged), the builder branches the implementation off `master ⊕ <dep-PR-1-head> ⊕ <dep-PR-2-head> ⊕ ...` — i.e. a stack. The role file should reference (or create) a skill that documents the stack-merge procedure. Consider whether an existing skill (`skills/pr-dependency-graph/SKILL.md`, `skills/pr-dependency-topo-sort/SKILL.md`) already covers this, and only author a new one if neither suffices.

5. **Adopt stuck PRs during search**. While walking the design queue, if the contractor encounters a garden-authored draft PR that has not progressed in over (say) 2 hours, prefer adopting that PR into a slot over starting a new design. The slot's next dispatch advances the stuck PR's next-stage-owed.

6. **Concurrency caps**. Three slots is the soft cap. The contractor never dispatches more than one cleaner across the estate at a time (existing PR-creation-flow rule); the cleaner cap composes with the three-slot cap. Judges-running-the-panel are concurrent across slots.

7. **Posture and authority**. The role runs as a fourth orchestrator posture alongside liaison / steward / understudy. The maintainer's instruction is for the *liaison* to assume it for four days, so the role's posture text should clarify that adoption happens through the liaison session continuing in this posture (similar in shape to the understudy section in `roles/understudy/AGENT.md`). The contractor holds the same bounded authority as the steward (no role/skill edits, no upstream pushes, no per-action authorization origination); meta-evolution still goes through the liaison.

8. **Redundant scheduling**. Document that the contractor runs with two independent durable cron triggers (target cadence ~30 min, offset on different prime-minute marks to dodge cache-fleet collisions) plus an adaptive `ScheduleWakeup` loop via `<<autonomous-loop-dynamic>>`. The cron-vs-ScheduleWakeup pitfall in `skills/autonomous-loop-pacing/SKILL.md` is overridden by maintainer directive here; cite the override in the role file. The contractor's per-cycle work must be idempotent (a tick that arrives 30 seconds after the prior tick does nothing if all slots are already advanced).

9. **Tick body**. The contractor's per-tick prompt should be a short sentinel (analogous to the steward's `<<autonomous-loop-dynamic>>` or a fixed phrase like "run one contractor cycle"). The cron jobs' prompts are the same phrase. Document the exact phrase in the role file so the liaison can wire it identically across the three triggers.

10. **Definition of done for a slot**. Slot terminates when the judge un-drafts the PR (`gh pr ready <N>`). The contractor then archives the slot's state to a slot-history directory and the slot is empty again, ready for refill.

11. **Stall detection**. If a slot's last-update timestamp is older than (say) 60 minutes with no in-flight dispatch return, surface to a journal `message` entry to liaison and try to advance the slot anyway. If still stuck after 120 minutes, mark the slot stalled, clear it, and refill.

12. **Inventory and disambiguation**. Add the role to `CLAUDE.md` § Current inventory and to both orchestrator vocabularies (a row like "contract #N" / "the gamut at #N" only if it doesn't clash with the existing gamut idiom; if it does, leave the vocabularies alone and surface the conflict in your `result`). The role should NOT clash with the steward's existing PR-creation-flow scan and design-to-PR pipeline; the contractor is a focused, parallelized, foreground variant the liaison adopts when explicitly told to, not a standing autonomous role.

Non-goals: no boatman dispatches, no upstream ferrying, no merging. The contractor's deliverable is un-drafted PRs in the maintainer's review queue, three at a time.

Skills to consult or extend (do not assume; verify):

- `skills/design-to-pr-pipeline/SKILL.md`
- `skills/design-queue-drift-check/SKILL.md`
- `skills/pr-creation-flow/SKILL.md`
- `skills/autonomous-loop-pacing/SKILL.md`
- `skills/pr-dependency-graph/SKILL.md` and `skills/pr-dependency-topo-sort/SKILL.md` (for the stacked-PR question)
- `skills/agent-termination/SKILL.md` (for the slot-stall path)
- `roles/steward/AGENT.md` § Per-cycle procedure (the closest template)
- `roles/understudy/AGENT.md` (for the posture-adoption pattern)

Report shape: file paths authored or revised, the exact tick-prompt phrase the contractor expects, any decisions you made on the dependency-walk shape and the stack-merge skill, and any open questions for the liaison.

Self-improvement: nothing this time.
