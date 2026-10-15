---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-pr1392-parcel-restack-20261015-r5527149922-split
handler-timeout: 10800
split-indivisible-reason: 'Parcel adaptation, explicit history-preserving rebase, lease-protected branch/base updates, and exact-head CI form one atomic PR mutation; splitting would expose an intermediate head and invalidate downstream verification.'
split-lineage-root: endojs-endo-but-for-bots-pr1392-parcel-restack-20261015-r5527149922
split-lineage-parent: endojs-endo-but-for-bots-pr1392-parcel-restack-20261015-r5527149922-split
split-lineage-depth: 1
split-lineage-max-depth: 1
priority: normal
posted_by: orchestrator
posted_at: 2026-10-15T11:45:17Z
---

---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Reconcile and restack endojs/endo-but-for-bots PR #1392

This is the expanded-window retry of
`endojs-endo-but-for-bots-pr1392-parcel-restack-20261015-r5527149922`.
The operation is intentionally indivisible because the accepted Parcel change,
history-preserving rebase, lease-protected ref updates, and exact-head validation
must remain one coherent PR mutation. Do not split it again.

Wear the fixer role and use the weaver procedure. Re-fetch PR #1460 and apply
its accepted Parcel design, including commit
`6973c078f6318335ec64de5ff611f77637ef4dfa` or its rebased equivalent, to the
pass-style recognition in PR #1392. Preserve the brand-check-before-remotable
ordering and the literal `'parcel'` pass style.

Re-fetch the current PR #1392 head before changing it, preserving any newer
accepted work. Restack on the current head of predecessor PR #1391. Snapshot
that exact head as `build/sturdyref-ses-accommodation-<short-sha>`, rebase only
#1392's own commits from its old frozen base onto the new one with an explicit
`--onto`, honor both parent histories in conflicts, force-push with lease, and
update #1392's base. Run affected tests and gates, drive CI green, and post the
required completion summary.

If the work genuinely finishes but a gated outcome cannot be achieved, end the
report with these exact lines:

`<<<GARDEN-ORCHESTRATION-FAILED>>>`
`<<<GARDEN-JOB-COMPLETE>>>`
