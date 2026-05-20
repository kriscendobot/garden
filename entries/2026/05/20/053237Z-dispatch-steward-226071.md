---
ts: 2026-05-20T05:32:37Z
kind: dispatch
role: steward
to: weaver
dispatch_id: 226071
dispatch_root: /home/kris/dispatches/weaver--226071
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 307
    role: target
---

# Dispatch weaver 226071 — rebase #307 onto current llm (post conductor stall + un-draft)

Conductor cb04ea stalled: PR #307 (APPROVED) was 91 commits behind `origin/llm` after #304 merged. Un-drafted inline by the steward (draft-flag was blocking the conductor too).

Weaver: rebase onto current `origin/llm`, resolution favors the more-recent truth (post-#304 designs/README sweeps), force-push with lease.
