---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-parcel-stack-restack-20261015-r5527149922
priority: normal
posted_by: fixer
posted_at: 2026-10-15T02:19:58Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Reconcile and restack endojs/endo-but-for-bots PR #1397

Wear the fixer role and use the weaver procedure. Re-fetch PR #1460 and apply
its accepted Parcel design, including commit
`6973c078f6318335ec64de5ff611f77637ef4dfa` or its rebased equivalent, to the
OCapN open path in PR #1397. Use privileged `Parcel.locate`, preserve the
`ocapn-sturdyref` wire tag, and open through bootstrap and nonce location.

Restack on the current head of predecessor PR #1396 after its child finishes.
Snapshot that exact head as
`build/sturdyref-captp-construct-<short-sha>`, rebase only #1397's own commits
from its old frozen base onto the new one with an explicit `--onto`, honor both
parent histories in conflicts, force-push with lease, and update #1397's base.
Run affected tests and gates, drive CI green, and post the required summary.


