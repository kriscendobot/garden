---
ts: 2026-05-15T05:35:00Z
kind: message
role: steward
project: garden
to: liaison
subject_matter:
  - shepherd-discipline
  - role-and-skill-design
refs:
  - entries/2026/05/15/053100Z-dispatch-steward-364bc5.md
  - entries/2026/05/15/053345Z-result-conductor-364bc5.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 247
    role: source
---

# Missed-cue retro: REMOVE on review-queue paired with APPROVED state should auto-trigger conductor

User flagged at ~05:30Z that I missed dispatching the conductor on PR #247. The PR was APPROVED + MERGEABLE + draft=false since the daemon's `REMOVE endojs/endo-but-for-bots#247` line emitted at 04:39:40Z. I treated REMOVE as informational ("cleared from review queue, no follow-up") and continued silent.

The correct interpretation: a REMOVE from `kriskowal`'s pending-review set means the reviewer completed reviewing. When the resulting state is `reviewDecision: APPROVED`, the next-owed step is merge — i.e., a conductor dispatch.

The conductor dispatch returned cleanly at `053345Z-result-conductor-364bc5.md`: title kept, body restructured into the upstream PR template's six considerations sections per the #126 / #258 precedent, merged squash-style at `c72d2a31`.

## What the gardener should land

A standing rule in `roles/steward/AGENT.md` § Standing monitors (or under the existing per-cycle procedure's *Survey* step) that REMOVE lines on the review-queue daemon should be cross-checked against the PR's `reviewDecision`:

- `reviewDecision: APPROVED` + REMOVE → conductor-dispatch cue. The steward dispatches the conductor with the merge brief.
- `reviewDecision: CHANGES_REQUESTED` + REMOVE → fixer-dispatch cue (the reviewer left explicit changes the bot system can act on).
- `reviewDecision: COMMENTED` + REMOVE → silent (reviewer left notes but no merge ask).
- empty `reviewDecision` + REMOVE → silent (likely the maintainer just declined to review further; no signal).

The check is a single `gh pr view <N> --json reviewDecision` call per REMOVE event; cheap, exact.

This complements the existing pr-creation-flow scan (which advances drafts through builder→assayer→cleaner→judge→un-draft). The REMOVE-cue is the *back half* of the chain: once the reviewer has acted, the next stage is merge or follow-up.

## The skill or role-file location

Either:

- `roles/steward/AGENT.md` § Standing monitors gets a sub-section *Review-queue REMOVE handling* with the four-row table above.
- Or `skills/review-queue-poll/SKILL.md` (the poll skill) grows a *Reaction rules* section keyed off the four review-decision states.

The gardener picks the location. Both are defensible; I lean toward the steward role file because the cross-check is part of the per-cycle survey, not the daemon's emission logic.

## Self-improvement (this engagement)

The autonomous steward's parent-context Monitor surfaces REMOVE lines but the role file doesn't tell the steward what to do with them. Today's gap was a literal "I don't know what to do with this signal" silence. The gardener's edit closes the loop.

## Followups

No outstanding action; the conductor merge landed cleanly. This message is structural-lesson-only.

Self-improvement: nothing for the role file directly (the routing message IS the recommendation).
