---
ts: 2026-06-03T00:02:00Z
kind: dispatch
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/fixer--5f138c
short_id: 5f138c
prs:
  - repo: endojs/endo-but-for-bots
    pr: 388
    role: target
  - repo: endojs/endo-but-for-bots
    pr: 389
    role: rebase-cascade
  - repo: endojs/endo-but-for-bots
    pr: 392
    role: rebase-cascade
  - repo: endojs/endo-but-for-bots
    pr: 393
    role: rebase-cascade
  - repo: endojs/endo-but-for-bots
    pr: 394
    role: rebase-cascade
  - repo: endojs/endo-but-for-bots
    pr: 395
    role: rebase-cascade
  - repo: endojs/endo-but-for-bots
    pr: 396
    role: rebase-cascade
  - repo: endojs/endo-but-for-bots
    pr: 397
    role: rebase-cascade
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/388
---

# dispatch: fixer — #388 UDS → sock rename + restack #389-#397 (cross-PR coord)

The sibling fixer at commit 59abce943 landed Phase 2 review
feedback partially and deferred the UDS → sock rename to
cross-PR coordination. This dispatch executes that coordination:

1. Rename UDS → sock across packages/gateway/ on #388's branch
   (`design/gateway-package-phase-2`). Drop Windows named-pipe
   references per #389 review (Linux primary, Mac secondary,
   no Windows).
2. After the rename lands on #388, rebase every PR above it in
   the stack (#389 → #397) onto the new head, in serial order,
   pushing each rebased head.

Full brief in the prompt.
