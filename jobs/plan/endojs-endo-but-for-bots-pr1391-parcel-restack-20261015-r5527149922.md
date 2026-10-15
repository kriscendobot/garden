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
# Reconcile and restack endojs/endo-but-for-bots PR #1391

Wear the fixer role and use the weaver procedure. Re-fetch PR #1460 and apply
its accepted Parcel design, including commit
`6973c078f6318335ec64de5ff611f77637ef4dfa` or its rebased equivalent, to the
SES accommodation in PR #1391. Ensure `%InitialParcel%` retains location
authority and `%SharedParcel%` withholds it.

Restack on the current head of predecessor PR #774 after its orchestration child
finishes. Snapshot that exact head as
`build/sturdyref-shim-first-wins-<short-sha>`, rebase only #1391's own commits
from its old frozen base onto the new one with an explicit `--onto`, resolve
conflicts without flattening or dropping either parent chain, force-push with
lease, and update #1391's base. Run affected tests and gates, drive CI green,
and post the required summary.


