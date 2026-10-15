---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-parcel-stack-restack-20261015-r5527149922-resume-resume
priority: normal
posted_by: fixer
posted_at: 2026-10-15T02:19:58Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Reconcile and restack endojs/endo-but-for-bots PR #1392

Wear the fixer role and use the weaver procedure. Re-fetch PR #1460 and apply
its accepted Parcel design, including commit
`6973c078f6318335ec64de5ff611f77637ef4dfa` or its rebased equivalent, to the
pass-style recognition in PR #1392. Preserve the brand-check-before-remotable
ordering and the literal `'parcel'` pass style.

Restack on the current head of predecessor PR #1391 after its child finishes.
Snapshot that exact head as
`build/sturdyref-ses-accommodation-<short-sha>`, rebase only #1392's own commits
from its old frozen base onto the new one with an explicit `--onto`, honor both
parent histories in conflicts, force-push with lease, and update #1392's base.
Run affected tests and gates, drive CI green, and post the required summary.


