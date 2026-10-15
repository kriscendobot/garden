---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-15T02:22:42Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Reconcile and restack endojs/endo-but-for-bots PR #774

Wear the fixer role and use the weaver procedure. Apply the accepted Parcel
design from PR #1460, including design commit
`6973c078f6318335ec64de5ff611f77637ef4dfa` or its rebased equivalent, to the
layer-1 implementation in PR #774. Re-fetch #1460 before editing and reconcile
the whole current design, not merely names. Preserve the existing
first-wins/open behavior while implementing the initial/shared authority and
location contract relevant to this layer.

Weave #774 onto the current `llm` tip: create or reuse the frozen
`llm-<short-sha>` base at that exact tip, rebase the PR's own commits onto it,
resolve every conflict by honoring both histories, force-push with lease, and
move the PR base to the new frozen branch. Verify the resulting delta contains
only #774's intended layer. Run affected tests and gates, drive CI green, reply
to any applicable review threads, and post the required top-level summary.

<!-- garden-reaped: 0 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-15T04:18:58Z
