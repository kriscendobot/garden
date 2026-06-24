---
ts: 2026-05-20T05:25:50Z
kind: dispatch
role: steward
to: fixer
dispatch_id: 979eb9
dispatch_root: /home/kris/dispatches/fixer--979eb9
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 303
    role: target
---

# Dispatch fixer 979eb9 — remove designs dir + retcon #303 (kriskowal directive)

kriskowal CHANGES_REQUESTED on PR #303 at 2026-05-20T05:25:03Z: "Please remove the designs directory and retcon."

Two-part:
1. Remove the `designs/` directory changes from this PR (PR #303 is the master-mirror devDep-cycle workspace PR, not a designs PR — designs likely got swept in by accident or by an over-broad rename earlier).
2. Standard retcon per `skills/retcon/SKILL.md`.

Acked PR-level 05:25Z.
