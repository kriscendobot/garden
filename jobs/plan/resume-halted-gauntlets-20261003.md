---
gate: go-ahead
priority: normal
role: shepherd
tier: minion
handler-timeout: 10800
token-budget: 250000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: deterministic
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-10-03T05:23:09Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-10-03T05:23:09Z
---

---
role: shepherd
handler-timeout: 10800
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
# Resume three gauntlets halted by an unknown stage-job death

Maintainer (kriskowal, muster 2026-10-03) approved resuming these from where they stopped.

- https://github.com/kriscendobot/minion.town/pull/145 — build-ci-minion-town-actions-runner-gauntlet, stopped at panel-4 (requeue-exhausted)
- https://github.com/endojs/endo-but-for-bots/pull/1406 — build-endo-claude-pinned-cli-bump-gauntlet, stopped at panel-6 (requeue-exhausted)
- https://github.com/endojs/endo-but-for-bots/pull/1393 — ebfb-sturdyref-layer4-marshal-20260930-gauntlet, stopped at fix-3 (requeue-exhausted)

For each: find why the stage job died (its doom record and journal log), fix the
cause if it is in the garden or the PR, then resume the gauntlet at the stage where it
stopped (not from round 1) so it runs to un-draft or its review budget. If a resume
mechanism is missing for a finished record, re-post just that stage with the same
iteration count and say how. For minion.town use GARDEN_YARN=npm. Report per-PR outcome.
