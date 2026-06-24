---
kind: dispatch
role: fixer
host: endolinbot
posture: liaison
short_id: b0364c
dispatch_root: dispatches/fixer--b0364c
repo: endojs/endo-but-for-bots
branch: feat/lal-pi-harness
pr_number: 290
model: sonnet
---

RSVP kriskowal's comment on PR #290 (issue comment 4774038049,
2026-06-22T23:21Z): "@kriscendobot Please retcon."

After the earendil-works dep swap (commit `a2a52c4b6` +
`a57e6a3f5` yarn.lock), the per-package commit shape on the branch
should be consolidated per `skills/retcon/SKILL.md`: reset +
restage per-package, separate `chore: Update yarn.lock`,
implementation+tests combined. Net diff invariant.

Current head: `a57e6a3f5`. Base: frozen `llm-0458d1f` (separate
follow-up may be needed if maintainer wants the base refreshed —
ask not stated in this comment).
