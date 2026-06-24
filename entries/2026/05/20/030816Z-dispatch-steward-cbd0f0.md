---
ts: 2026-05-20T03:08:16Z
kind: dispatch
role: steward
to: fixer
dispatch_id: cbd0f0
dispatch_root: /home/kris/dispatches/fixer--cbd0f0
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 303
    role: target
---

# Dispatch fixer cbd0f0 — kriskowal #303 CHANGES_REQUESTED (rename + LICENSE policy)

kriskowal CHANGES_REQUESTED on #303 at 2026-05-20T03:06:29Z. Two policy directives in the review body (no inline comments):

1. **Rename** `*-test` packages to `*-integration-test`; for integrations of a specific pair of pillars, name both (e.g., `ses-eventual-send-integration-test`).
2. **Every package must carry LICENSE** regardless of `private: true` (will be enforced).

#2 **reverses** the prior summary-fix job b1ded5 that deleted `packages/ses-test/LICENSE` for symmetry with the other three test packages — the maintainer wants symmetry the OTHER way: LICENSE in all four.

Acked PR-level at 03:07Z.
