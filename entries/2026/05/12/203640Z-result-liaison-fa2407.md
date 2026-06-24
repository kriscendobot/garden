---
ts: 2026-05-12T20:36:40Z
kind: result
role: liaison
worktree: worktrees/endojs-endo-but-for-bots/integrate--liaison--20260512-194515
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
refs:
  - entries/2026/05/12/194807Z-worktree-liaison-619681.md
---

Integration of endojs/endo-but-for-bots:garden@cc79140a6 complete.

Outcome: staged as a read-only reference shelf at
`references/endo-but-for-bots/` on main `c68a23c`. 26 role files, 47 skill
files, plus their READMEs and CLAUDE.md / AGENTS.md. No active library file
adopted yet — adoption requires explicit user confirmation and translation
to our naming, layout, and journal-based state model.

Liaison's operating norms in `roles/liaison/AGENT.md` now include "translate
user prompts to a role": active library first, then references, then propose
drafting from scratch. CLAUDE.md mentions the references/ shelf at the layout
level. WORKTREES.md fixes the bare-clone exclude recipe.

Drift to be aware of when adopting from this shelf:
- Their `liaison` is narrower (issue management); their `steward` is closer
  to ours.
- Their `process/<...>.md` state pattern is alien to our orphan-branch
  journal; rewrite to journal entries with `project:` slugs when adopting.
- Their self-improvement skill is more developed than the standing
  instruction in our roles/COMMON.md. Likely worth a targeted adoption when
  we revisit the self-improvement norm.

Worktree at `worktrees/endojs-endo-but-for-bots/integrate--liaison--20260512-194515/`
is now `idle` — the snapshot copy in `references/` is the durable record;
the worktree remains for grep-against-upstream and for refreshing imports
when needed. Per WORKTREES.md, it is collectable after 1h of no heartbeat
unless re-claimed.

Procedural observation worth flagging: a bulk `cp -R` followed by a single
commit is cheap to write and to review (one logical change), but it gives no
opportunity for the user to react to individual files. If a future import
includes anything potentially load-bearing (skills that would silently
change defaults if mistaken for active library), break the import into a
draft branch + PR-style review pass instead of committing straight to main.
