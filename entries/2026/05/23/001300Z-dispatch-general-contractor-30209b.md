---
ts: 2026-05-23T00:13:00Z
kind: dispatch
role: fixer
project: endo-but-for-bots
to: fixer
host: endolinbot
slot: 1
prs:
  - repo: endojs/endo-but-for-bots
    pr: 359
    role: target
refs:
  - entries/2026/05/23/001000Z-result-solicitor-32b9d1.md
---

# Dispatch: fixer 30209b — address 5 must-fix + 20 summary-fix on #359 (endoclaw pinchtab)

Solicitor-32b9d1 verdict: 5 must-fix-loop:
1. designs/README.md stale — reverts endopi raft + 9 other rows + status flips + M½ deletion + 2026-05-20 calibration. Redo README delta on top of origin/llm-b1c3f4d preserving every untouched row.
2. Phase 6 / EvalCapableBrowser cross-document mismatch on eval.
3. Auth model braiding (one server per daemon vs per-capability token isolation).
4. PinchTab-as-upstream evidence pointers missing (no release tag/SHA).
5. Snapshot-cache TOCTOU between role-and-name resolution and dispatched action.

Plus 20 summary-fix items. Don't touch follow-ups.

Report to result-fixer-30209b.md.
