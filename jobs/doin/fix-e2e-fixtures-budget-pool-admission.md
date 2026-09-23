---
role: fixer
priority: normal
posted_by: fix-finished-but-not-completed-requeue
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix: e2e gardener test fixtures blocked by the fail-closed budget-pool claim gate

Repo: the garden itself (`kriscendobot/garden`, `main2`, push direct).

On `main2` (verified on a pristine export at 987bb13b9b5 and again after 44ed0aa2243), these
suites fail because their hermetic journals seed no budget pool, so `claim-job.sh` refuses
admission ("budget pool 'unknown:anthropic:<host>:gardener' refuses admission (fail-closed):
unrecognized inference source"). The gardener therefore claims nothing and every
end-to-end assertion downstream fails:
completion-signal-test (19 FAIL), handler-budget-test (13), worker-spine-kinds-test (32),
deadline-nudge-test (5), mystic-kimi-harness-test (4), worker-health-gate-test (2), and
gauntlet-test (1: `tick 1: todo=[g1-viability ]`; confirm whether it is the same cause).

Fix: seed a calibrated test pool in each fixture's journal, e.g.
`config/budget-pools`: `anthropic:test anthropic weekly-tokens 73000000 measured` and
`config/subscription-mapping`: `anthropic:test <fixture-host> <kind>` (the pattern
productive-cycle-test.sh `seed_board` now uses). A shared fixture helper is better than
seven copies. Do NOT add a GARDEN_TEST bypass to the production gate. Run each suite to
green and push.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-23T22:21:06Z
