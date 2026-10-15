---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-15T11:50:41Z cleared=none -->

---
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

Restack on the current head of predecessor PR #1392 after its child finishes.
Snapshot that exact head as
`build/sturdyref-pass-style-recognition-<short-sha>`, rebase only #1393's own
commits from its old frozen base onto the new one with an explicit `--onto`,
honor both parent histories in conflicts, force-push with lease, and update
#1393's base. Run affected tests and gates, drive CI green, and post the required
summary.

<!-- garden-reaped: 0 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-15T12:33:45Z
