---
ts: 2026-06-03T02:28:43Z
kind: dispatch
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/fixer--495b1c
short_id: 495b1c
prs:
  - { repo: endojs/endo-but-for-bots, pr: 394, role: target }
  - { repo: endojs/endo-but-for-bots, pr: 395, role: rebase-cascade }
  - { repo: endojs/endo-but-for-bots, pr: 396, role: rebase-cascade }
  - { repo: endojs/endo-but-for-bots, pr: 397, role: rebase-cascade }
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/394
---

# dispatch: fixer — #394 one-repo-per-daemon + refs/formulas/${id} GC + cascade

kriskowal CHANGES_REQUESTED on #394 inline at
`git-http-integration.test.js:456`:

> A daemon, including the gateway, should only have one
> repository for content to serve on virtual hosts, where the
> bearer token corresponds to and may even be identical to a
> ref like refs/formulas/${id}, such that a formula GC can
> effect [collection].

The other two #394 inline items (bitwise rule + lewd
constants) are already addressed by sibling commit `77bebfb1f`.
Only this substantive one remains.

Redesign Phase 6:
- Drop `(token, repoId)` resolver — daemon has ONE repo.
- Bearer = formula-id (unchanged), resolves to
  `refs/formulas/<id>` in the daemon's one git repo.
- Path: `/git/<formula-id>/<git-rpc>` → `/git/<git-rpc>` (or
  similar; the formula-id moves to the bearer-only surface).
- Formula GC → ref deletion → orphan content collectible by
  git gc.

After #394 redesign lands, restack #395-#397 onto new head.
