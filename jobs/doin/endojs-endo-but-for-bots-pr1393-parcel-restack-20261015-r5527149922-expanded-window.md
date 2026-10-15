---
role: fixer
tier: mentor
handler-timeout: 10800
split-indivisible-reason: 'The Parcel semantic adaptation changes the same commit range that must be rebased and conflict-resolved against PR #1392, so splitting would make either child operate on a non-final history and invalidate patch-identity and exact-head CI evidence.'
split-lineage-root: endojs-endo-but-for-bots-pr1393-parcel-restack-20261015-r5527149922
split-lineage-parent: endojs-endo-but-for-bots-pr1393-parcel-restack-20261015-r5527149922-split
split-lineage-depth: 1
split-lineage-max-depth: 1
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-15T13:26:41Z cleared=none -->

---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Reconcile and restack endojs/endo-but-for-bots PR #1393

Wear the fixer role and use the weaver procedure. Re-fetch PR #1460 and apply
its accepted Parcel design, including commit
`6973c078f6318335ec64de5ff611f77637ef4dfa` or its rebased equivalent, to the
marshal representation in PR #1393. Parcels are inline in CapData and
Smallcaps, do not consume ordinary live slots, and require privileged location
and endpoint-specific open callbacks.

Restack on the current head of predecessor PR #1392. Its prior restack child
reported exact head `65391dffbc29fd6cdf7a4e2c949f50ae9b10b5e1`, but re-fetch
and use PR #1392's current exact head at execution time. Snapshot that exact
head as `build/sturdyref-pass-style-recognition-<short-sha>`, rebase only
#1393's own commits from its old frozen base onto the new one with an explicit
`--onto`, honor both parent histories in conflicts, force-push with lease, and
update #1393's base. Run affected tests and gates, drive CI green, and post the
required summary.

This is the expanded-window child of the deterministic overrun split. Keep the
Parcel semantic adaptation, history-preserving rebase, lease-protected ref/base
updates, and exact-head validation in one coherent PR mutation. If the work is
genuinely finished but a required gated outcome is not achieved, emit
`<<<GARDEN-ORCHESTRATION-FAILED>>>` immediately before the completion signal.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-15T13:27:05Z
