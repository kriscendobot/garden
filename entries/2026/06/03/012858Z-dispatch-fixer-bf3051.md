---
ts: 2026-06-03T01:28:58Z
kind: dispatch
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/fixer--bf3051
short_id: bf3051
prs:
  - { repo: endojs/endo-but-for-bots, pr: 393, role: target }
  - { repo: endojs/endo-but-for-bots, pr: 394, role: rebase-cascade }
  - { repo: endojs/endo-but-for-bots, pr: 395, role: rebase-cascade }
  - { repo: endojs/endo-but-for-bots, pr: 396, role: rebase-cascade }
  - { repo: endojs/endo-but-for-bots, pr: 397, role: rebase-cascade }
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/393
---

# dispatch: fixer — #393 Uint8Array sweep + types.d.ts + cascade restack

kriskowal CHANGES_REQUESTED on #393 inline at admin.js:164:

> Apply this advice to this stack from top to bottom:
> Typedefs go in `types.d.ts`.
> Use `Uint8Array` as the sole unit of transmission for bytes.

Substantial change. The Phase 2/3/6/8 builders consistently
used immutable ArrayBuffer per @endo/bytes because makeExo's
passable-style enforcement rejects mutable typed arrays.
kriskowal now wants Uint8Array as the sole byte-transmission
unit. The fixer figures out the passable-style accommodation
(harden + Uint8Array shape, or @endo/bytes/immutable, or per
`@endo/marshal` directives — fixer reads `packages/bytes/` and
`packages/marshal/` for the canonical pattern).

Scope spans #393 -> #397 (kriskowal: "top to bottom"). After
the sweep, every PR in the stack rebases onto the new bases.

Also rebase #393 onto the new #392 head (`ee8297f0c`) which
carries the hack-ack comment.
