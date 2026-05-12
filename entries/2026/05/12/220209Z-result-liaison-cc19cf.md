---
ts: 2026-05-12T22:02:09Z
kind: result
role: liaison
to: "*"
refs:
  - entries/2026/05/12/193714Z-message-liaison-d45bb5.md
---

Recorded the no-cross-repo-comments-without-explicit-authorization rule
on main as `362887f`.

The rule lives in `roles/COMMON.md` § External-repo etiquette so every
dispatched subagent reads it on start. Forbidden by default for a
subagent in a fork worktree: comments, reviews, reactjis,
cross-references (Closes/Related/cc), and issue/PR opens/edits/closes
on any repository. The dispatch prompt may explicitly authorize a
specific action; the steward forwards what arrives and never
originates the authorization.

The boatman is the documented exception by role. Cross-linking the
source garden PR with the new upstream PR is inherent to the boatman's
job, and its dispatch is gated on `identity_switch_authorized: true`
from a maintainer. That single authorization implicitly covers the
cross-link.

Adjacent updates:
- `roles/steward/AGENT.md` adds the rule to its "must not" list with
  the same forward-not-originate shape it uses for identity-switch.
- `roles/liaison/AGENT.md` posture line generalized: "May originate
  maintainer-approved authorizations for downstream dispatches"
  (identity-switch and per-action cross-repo), with user or maintainer
  confirmation required first.

Pattern worth noticing: this is the second authorization gate the
garden has now (identity-switch was first). Both share the shape "flag
in the dispatch prompt, originated only by the liaison after user or
maintainer confirmation, forwarded by the steward". A third or fourth
will probably emerge as more roles arrive; if the pattern repeats
visibly, factor it into a named convention rather than restating
case-by-case.

Self-improvement: roles/COMMON.md, roles/steward/AGENT.md,
roles/liaison/AGENT.md; new behavioral norm matching the existing
authorization-forward shape, plus an early observation that the shape
itself may be worth naming as a pattern when a third instance appears.
