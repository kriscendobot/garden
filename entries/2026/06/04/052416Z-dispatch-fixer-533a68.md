---
ts: 2026-06-04T05:24:16Z
kind: dispatch
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/fixer--533a68
short_id: 533a68
prs:
  - { repo: endojs/endo-but-for-bots, pr: 244, role: target }
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/244
  - https://github.com/endojs/endo/pull/3263
---

# dispatch: fixer — rebase mirror of endo#3263 (our PR #244) on current master; maintainer will ferry on completion

Maintainer directive:

> Please dispatch a fixer to rebase our mirror of
> https://github.com/endojs/endo/pull/3263 on current master.
> I will referry when complete.

Mirror is PR #244 (`chore(eslint-plugin): require underscore-
delimited groups in numeric literals`), currently OPEN, base
`master-ba26f4c` (frozen-base from 2026-05-29), head SHA
`dbe04c499`. Drift: bot-fork master has advanced since the
frozen base was snapshot.

Per `skills/frozen-base-branch/SKILL.md`, create a fresh
frozen-base from current `endojs/endo-but-for-bots:master`
(name like `master-<7-char-sha>`), rebase the feature branch
onto it, change PR #244's base to the new frozen branch via
`gh pr edit 244 --base master-<sha>`. Resolve conflicts per
`skills/conflict-resolution/SKILL.md`.

The maintainer will dispatch the boatman after the rebase
lands (the "I will referry" framing); this dispatch does NOT
ferry upstream.
