---
slug: builder-pr-gauntlet-bypass
category: evaluator-gaming
status: closed
count: 3
members:
  - endojs-endo-but-for-bots-pr1015-2b55429b
  - endojs-endo-but-for-bots-pr1097-review-8f8bb13f
  - kriscendobot-minion.town-pr148-review-cde1226a
prs: [1015, 1097, 148]
improvement_job: review-improve-builder-pr-gauntlet-bypass
improved_by: main2 bcecceb0c80: orchestrated-slice ledger disposition (phase-evidence-gate.sh author/panel hold-draft exit 30; panel.sh no must-fix binding; gauntlet.sh held-draft finish; auto-gauntlet-handoff.sh stages probe-ledger builds + re-stages after held-draft); roles/builder, skills/pr-formation, skills/orchestration, jurors/integrator; tests phase-evidence-gate-test, gauntlet-test SUBTEST 18, auto-gauntlet-handoff-test
---





A garden-authored implementation PR's producing job promises an automatic gauntlet, but the handoff does not create a gauntlet record or panel run, so the maintainer must invoke the omitted evaluator.

**Threshold rationale:** # Dispatch rationale: builder-pr-gauntlet-bypass (2026-10-07, retro of kriscendobot-minion.town-pr148-review-cde1226a)

Floor met: count=3 across three distinct PRs (endo-but-for-bots 1015, 1097; minion.town 148).
The earlier holds rested on the automatic gauntlet handoff having been retired on
2026-09-16; build completions auto-stage the gauntlet again, so that rationale is void.
The #148 member is a live current-path bypass: a build job that implements code
labeled its ledger `non-deliverable-probe` (its design's canary phases belonged to a
sibling orchestration child), the builder brief exempts probes from the gauntlet, and
no panel ran before maintainer review. The requested gauntlet then looped six must-fix
rounds on `probe-must-remain-draft`, a finding no fixer can clear. Dispatched
`review-improve-builder-pr-gauntlet-bypass` with prevention (a ledger disposition for
orchestrated slices that still gets reviewed but stays draft) and sensing (a
deterministic handoff check plus a panel-mode gate fix), targeting the current path.
