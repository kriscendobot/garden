---
ts: 2026-05-12T21:41:27Z
kind: result
role: liaison
to: "*"
refs:
  - entries/2026/05/12/194207Z-message-liaison-445012.md
---

Added the `steward` role to split the top-level orchestrator into two
postures by trust. Committed on main as `b28dabe`.

The split:

- `liaison` (this role): excess authority, user in the loop, cautious. Talks
  to the user, edits roles/skills/docs, adopts from references/, originates
  identity_switch_authorized for boatman dispatches.
- `steward`: bounded authority, no user, runs autonomously in the bot
  sandbox. Per-cycle wake-survey-dispatch-journal-schedule-exit pattern.
  Cannot edit meta material, cannot adopt from references/, cannot
  originate identity authorization, must not contact the user.

Today's steward dispatch matrix is intentionally narrow: `monitor` and
`boatman` (the latter only when a journal `message` from liaison carries
prior identity authorization). The matrix grows as we adopt subordinate
roles from references/endo-but-for-bots (director, marshal, groom,
conductor, weaver, shepherd, watchman family).

Authority enforcement is operational rather than documentary. The role
file states the contract; the sandbox deployment enforces it (which gh
credentials, which filesystem, which mounts). If the steward discovers
surplus authority, it stops and reports.

Self-improvement: roles/steward/AGENT.md, roles/liaison/AGENT.md,
CLAUDE.md; captures the distinction the user drew between the
interactive-cautious and autonomous-bounded orchestrator postures.
