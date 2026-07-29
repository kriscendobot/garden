In the garden's own repo (kriscendobot/garden, `main2`), edit `roles/botanist/AGENT.md` step 6: the fixer-escalation clause currently reads as mandatory even when the botanist has already diagnosed and solved the break, which would waste a whole fixer job re-deriving a known diagnosis. Reword it so escalation is conditional — escalate only when the botanist cannot land the repair itself — while keeping the escalation path intact for genuine blocks.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 8
  worker_kind: gardener
  claimed_at: 2026-07-29T01:39:10Z
