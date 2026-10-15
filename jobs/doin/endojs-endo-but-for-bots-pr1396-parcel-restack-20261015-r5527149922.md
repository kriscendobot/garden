---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-15T16:24:20Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Reconcile and restack endojs/endo-but-for-bots PR #1396

Wear the fixer role and use the weaver procedure. Re-fetch PR #1460 and apply
its accepted Parcel design, including commit
`6973c078f6318335ec64de5ff611f77637ef4dfa` or its rebased equivalent, to the
CapTP construction and forwarding work in PR #1396. Construct received Parcels
with the endpoint open hook and permit trusted forwarding through location
authority without exposing locations to guests.

Restack on the current head of predecessor PR #1394 after its child finishes.
Snapshot that exact head as `build/sturdyref-captp-wire-<short-sha>`, rebase only
#1396's own commits from its old frozen base onto the new one with an explicit
`--onto`, honor both parent histories in conflicts, force-push with lease, and
update #1396's base. Run affected tests and gates, drive CI green, and post the
required summary.



<!-- garden-transient-elapsed: kind=exit0 through=0 values=46 -->

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-10-15T17:53:21Z -->

<!-- garden-productive-cycle -->
---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-15T18:19:54Z
