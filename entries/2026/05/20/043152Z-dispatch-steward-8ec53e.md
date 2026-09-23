---
ts: 2026-05-20T04:31:52Z
kind: dispatch
role: steward
to: judge
dispatch_id: 8ec53e
dispatch_root: /home/kris/dispatches/judge--8ec53e
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 306
    role: target
refs:
  - entries/2026/05/20/020226Z-result-judge-907068.md
---

# Dispatch judge 8ec53e — re-panel on PR #306 (must-fix-loop addressed)

Prior judge 2c6af1 posted 1 must-fix-loop (graph dep edge for handle.epithets[].principal). Fixer a78379 addressed it in `b6f332621`. CI now fully green 25/25 at the new head.

Re-run the code panel (23 seats) per jury-fixer loop. If 0 must-fix-loop this round, un-draft + post-loop actions per the chain.
