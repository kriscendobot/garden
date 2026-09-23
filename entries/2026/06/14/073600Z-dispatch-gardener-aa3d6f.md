---
ts: 2026-06-14T07:36:00Z
kind: dispatch
role: liaison
host: endolinbot
project: garden
to: gardener
dispatch_root: /home/kris/dispatches/gardener--aa3d6f
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4701061078
---

# dispatch: gardener — relax shepherd's surgical-fix constraint per kriskowal directive

Maintainer directive (kriskowal at 2026-06-14T07:34:19Z,
issue comment on kriscendobot/agoric-sdk #5):

> Please dispatch a gardener to relax the shepherd's
> standing instructions such that shepherds pursue a all
> tests passing in CI by whatever means necessary until
> reaching an impasse or success.

**Companion fixer dispatch** `c997e7` is already running on
PR #5 with the override applied in its dispatch brief; this
gardener change makes that override the standing default
for future shepherds.

## State at dispatch time

- Current `roles/shepherd/AGENT.md` carries a
  "surgical-fix" / "in-scope" constraint that the
  maintainer is now relaxing.
- The relaxation is structural: shepherds should pursue
  green CI by whatever means necessary, with impasse as
  the escalation criterion (rather than scope-of-fix as
  the escalation criterion).

## Task

In your `garden/` worktree:

1. **Read** `roles/shepherd/AGENT.md` in full to understand
   the current constraint shape. Likely sections to look
   at:
   - The "Operating norms" / "In-scope" / "Out-of-scope"
     section.
   - Any "Escalate `next: fixer`" guidance keyed on
     surgical-fix limits.
   - The verdict-and-escalation rules.
2. **Relax the constraint** per the maintainer's framing.
   Concrete edits likely:
   - Remove or rephrase the "only surgical fixes" /
     "in-scope only" guidance.
   - Add the "pursue green by whatever means necessary
     until impasse or success" framing as the new norm.
   - Re-anchor the escalation criterion on "genuine
     impasse" rather than "out of surgical scope".
   - Preserve safety guardrails: do NOT push to
     base/main; do NOT amend other people's commits; do
     NOT bypass safety checks (--no-verify, etc.).
3. **Update any cross-references** in `roles/COMMON.md` or
   skills under `skills/` that reference the old
   surgical-fix framing (grep first).
4. **Commit** with conventional commit:
   `roles(shepherd): relax surgical-fix constraint;
   pursue green CI by whatever means until impasse per
   kriskowal directive`.
5. **Push** to garden `main` (direct, per garden
   convention; no PR).

## Authorizations

- **Direct push to garden main** per garden norm (no PR).
- Do NOT touch other roles beyond cross-reference updates.
- Do NOT modify journal entries (this is a roles/ change
  only).

## Out of scope

- Do NOT touch the fixer role file (the fixer doesn't have
  the surgical-fix constraint; only the shepherd does).
- Do NOT touch project work; the companion fixer dispatch
  handles PR #5 with the override already applied to its
  brief.

## Deliverable

A `result` entry under `journal/entries/2026/06/14/` naming:

- The before/after of the relaxed sections in
  `roles/shepherd/AGENT.md`.
- Any cross-reference updates in `roles/COMMON.md` or
  skills.
- The garden main commit SHA.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator.
