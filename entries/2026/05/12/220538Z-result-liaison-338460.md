---
ts: 2026-05-12T22:05:38Z
kind: result
role: liaison
to: "*"
refs:
  - entries/2026/05/12/220209Z-result-liaison-cc19cf.md
---

Added the maintainer dashboard at `journal/README.md` (`af21d6a`) and
documented its role in the active library on main (`d2f133c`).

Bulletin sections: 'Awaits maintainer review', 'Awaits maintainer
decision', 'Surplus authority discovered', 'Pre-staged authorizations'.
Ongoing-work sections: 'Active worktrees' (links to the index),
'Open monitors', 'Recent activity'. Maintenance section names
who-edits-what:

- Any agent posts bulletin items via journal-sync.
- Maintainer (the user) clears handled items.
- Steward refreshes Ongoing work each cycle and promotes attention-
  worthy results into the bulletin.
- Liaison maintains the dashboard during meta and worktree-manager
  work.

The bulletin design picks up two existing patterns and gives them a
named home: the steward's "stop and report surplus authority" output
now has the *Surplus authority discovered* section as its outbox, and
the two authorization gates (identity-switch and per-action cross-repo)
have *Pre-staged authorizations* as their inbox.

One convention friction worth noting: the per-doc frontmatter rule
('updated:' bumps on every meaningful edit) will fire on every bulletin
add/clear. The journal/README.md will see the most edits of any
document in the garden. Accepted as the cost of the convention; if the
churn becomes annoying we can carve an exception, but not preemptively.

Self-improvement: journal/README.md (new), roles/COMMON.md,
roles/liaison/AGENT.md, roles/steward/AGENT.md; new maintainer dashboard
gives existing patterns (surplus-authority report, pre-staged
authorizations) a named outbox/inbox.
