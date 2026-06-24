---
kind: dispatch
role: fixer
host: endolinbot
posture: liaison
short_id: 2b194d
dispatch_root: dispatches/fixer--2b194d
repo: endojs/endo-but-for-bots
branch: feat/formula-inspector
pr_number: 440
model: haiku
---

RSVP kriskowal's comment on PR #440
(2026-06-22T07:56:56Z): "Please shepherd or escalate to fixer."

CI lint job has been failing since 06:55 with Prettier style
violations ("Code style issues found in the above file. Run
Prettier with --write to fix.") — a deterministic mechanical fix.
Skip the shepherd intermediate per the auto-escalate rule (memory
`feedback_auto_escalate_fixer_resume_gamut.md`).

Fixer brief: run `yarn format`, commit the diff as a single
`chore: yarn format` commit, force-push with lease anchor
`403217826`.
