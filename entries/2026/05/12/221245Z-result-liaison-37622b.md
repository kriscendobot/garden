---
ts: 2026-05-12T22:12:45Z
kind: result
role: liaison
to: "*"
refs:
  - entries/2026/05/12/220538Z-result-liaison-338460.md
---

Inverted the bulletin maintenance model per user direction. Agents now
own posting *and* clearing; the maintainer reads the bulletin and acts
in the upstream system (review the PR, comment on the issue, fix the
deployment), and the next steward cycle detects the action and clears
the item.

Touches:
- `roles/COMMON.md` § The journal: bulletin paragraph reworded.
- `roles/liaison/AGENT.md` Maintainer-dashboard norm: clarifies that the
  liaison posts AND clears.
- `roles/steward/AGENT.md` Housekeep step: spells out the per-cycle
  bulletin maintenance (post, re-check, clear).
- `journal/README.md` Bulletin and Maintenance sections updated.

Main: `2e6235b`. Journal: `3613500`.

Reasoning behind the inversion: making the maintainer edit a markdown
file in the journal branch as a separate step from their natural action
in GitHub creates two places to update. The second one goes stale. By
putting clearing on the steward (which already runs per cycle and reads
upstream state), we close the loop without imposing any extra work on
the maintainer.

Concrete clearing logic per section is informal for now (described in
prose: "PR has a maintainer review", "decision was made in upstream
comments", etc.). The first cycle that actually clears items will
reveal the procedure that wants codifying as a skill.

Self-improvement: roles/COMMON.md, roles/liaison/AGENT.md,
roles/steward/AGENT.md; corrects a v1 maintenance model that would have
required the maintainer to edit two places.
