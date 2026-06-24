---
ts: 2026-06-03T01:13:04Z
kind: dispatch
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/fixer--37e82a
short_id: 37e82a
prs:
  - { repo: endojs/endo-but-for-bots, pr: 394, role: rebase-cascade }
  - { repo: endojs/endo-but-for-bots, pr: 395, role: rebase-cascade }
  - { repo: endojs/endo-but-for-bots, pr: 396, role: rebase-cascade }
  - { repo: endojs/endo-but-for-bots, pr: 397, role: rebase-cascade }
refs:
  - entries/2026/06/03/004412Z-dispatch-fixer-2deace.md
---

# dispatch: fixer — resume #389 cascade rebase (PRs #394 → #397 still on old base)

Prior fixer `2deace` stalled mid-cascade after settling #389
(`bc807ca78`), rebasing #392 (`a658ea60e`), rebasing #393
(`fc2b7adc3`). #394 → #397 remain on PRE-#389-fix bases.

Resume: rebase #394 → #395 → #396 → #397 onto the new
#393 head (`fc2b7adc3`), in serial order, force-with-lease,
just propagating the separate-admin-sock changes through each
layer.

DO NOT re-do the #389 fix or re-rebase #392/#393. They are
already settled at their new heads.
