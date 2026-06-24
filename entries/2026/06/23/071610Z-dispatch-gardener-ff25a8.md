---
kind: dispatch
role: gardener
host: endolinbot
posture: liaison
short_id: ff25a8
dispatch_root: dispatches/gardener--ff25a8
repo: kriskowal/garden
branch: main
pr_number: null
model: opus
---

Follow-up dispatch from kriskowal's #474 comment (2026-06-23T06:25:14Z):

> Dispatch a gardener to reinforce this house style going forward.

The #474 fixer (8693b0) moved the design to
`docs/house-style/function-keyword.md` in endo-but-for-bots and
linked it from AGENTS.md. This gardener dispatch reinforces the
house style across the garden's roles, jurors, and skills so the
rule (use arrow / method syntax; do not use the `function`
keyword) is consistently applied in dispatched subagents'
defaults.

Gardener brief: introduce the no-`function`-keyword rule into the
garden's role and juror context so future builder / fixer
dispatches honor it without explicit instruction. Candidate
landing places:
- `roles/COMMON.md` (standing instructions every dispatched
  subagent reads first)
- `roles/builder/AGENT.md` operating norms
- `roles/fixer/AGENT.md` operating norms
- `roles/jurors/stylist/AGENT.md` or `roles/jurors/purist/AGENT.md`
  (juror lenses for catching violations)
- A new skill like `skills/no-function-keyword/SKILL.md` if the
  rule warrants standalone reuse.

Use your gardener judgment. Reference the docs file at
`docs/house-style/function-keyword.md` on
endo-but-for-bots/chore/retire-function-keyword.
