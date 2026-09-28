---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
handler-timeout: 14339

# Finish activation of the authorized Ironhorse ratchet autopilot

Successor to build-ironhorse-ratchet-autopilot. This job owns ALL remaining activation/runtime validation work. Core implementation landed on garden main2 at c3aae0b2c0c (follow-up docs 509c6c9d9da). Authorization: journal entries/2026/09/28/201230Z-message-gardener-aa49da.md. Do not widen that authority.

Already done: revocable delegated merge gate; exact-head gauntlet, pinned-comparator, no-loss/growth and instrumented new-code evidence; canonical scheduled mentat admission in scheduler/claim/monk/cleric; one-step driver and durable fail-twice/stuck halt; pause/revoke controls; documentation. 48 new tests passed locally, existing CI-wait 66 assertions and gauntlet 53 passed, comparator 18 passed. Configuration is seeded active on journal2 at config/delegations/ironhorse-test262-ratchet. Enforced floor remains refresh-20260904 (SHA256 322ca2ba759cf356bea57f8e8cd9badef7a855f52e4870227bfc55b072d0994f) and the original branch point is 47f6965d882b9c1c3eaaa836dd8d75971a924bb4.

Schedule ironhorse-ratchet exists: cadence 2h, prefix ironhorse-ratchet-watch, occupancy skip. It was snoozed to first fire at 2026-09-28T22:55:00Z because the deployed leader /home/kris/garden does not yet contain the new scheduler/handler gates. Existing old scheduler normalizes the task to mentor; the new task rejects that and cannot act. Do not allow this to strand a malformed pending tick. If rollout remains pending as the first fire approaches, use scripts/jobs/snooze-schedule.sh ironhorse-ratchet <future-UTC-instant> to defer it again and report the deadline. Do not change the two-hour steady cadence.

Current external blocker: main2 checks run https://github.com/kriscendobot/garden/actions/runs/36482066157 failed solely on preexisting maintainer-inbox-information-hiding violations in roles/botanist/AGENT.md and skills/foreign-content-preclassification/SKILL.md. The liaison has been notified. A prior unrelated common.sh shellcheck warning was already repaired by 2141ef9a9ba. Do not widen this job into changing unrelated role policy; coordinate its repair with the liaison/owning job, then let the ordinary safe rolling deploy admit the new revision. Never run git or edit source in the deployed root, and never force a canary/CI bypass.

Finish:
1. Read context/operations/ironhorse-ratchet.md and ironhorse-ratchet-evidence.md. Verify the active delegation and schedule through freshly synchronized helper-owned journal state.
2. Observe the check repair and normal rolling deployment, foreground/bounded. Confirm the deployed leader scheduler, claim predicates, and native handlers include the new gates. Also confirm deployed worker code can serve the canonical task. While waiting, preserve the schedule deferral; do not leave a soon-to-fire schedule relying on undeployed code.
3. If an old scheduler already emitted a noncanonical/downshifted ironhorse-ratchet-watch-* tick, reconcile ONLY that schedule's inert jobs through the job-board helpers. Do not counterfeit a watcher doin claim or attestation.
4. Once deployed, use snooze-schedule.sh with a near-future instant to admit the first real tick, then observe a canonical tier: mentat / dispatch: ratchet-delegated claim and actual mentat runtime model or handler evidence. Confirm the driver records exactly one step, or a correctly evidenced criterion failure, without overlapping children. Keep cadence 2h and occupancy skip. End only with the live activation verified or another named durable handoff owning all remaining work.

The first subject is https://github.com/endojs/endo-but-for-bots/pull/1359, marker <!-- garden-arc: ironhorse-test262-ratchet -->. It currently targets llm-47f6965, has an incompatible historical floor (901 informational historical losses remain), and lacks instrumented coverage. It MUST NOT merge or acquire an attestation in this condition. The parked successor ironhorse-test262-ratchet-round3-floor-resolution-20260928 owns the maintainer decision and PR-side resolution; coordinate before mutations. Do not lower the enforced floor or treat its newer refresh directory as superseding authority. This activation job need not make that PR mergeable: a correctly halted watcher is the required safe runtime outcome when criteria remain unmet.

Exact controls from a checkout containing this code:
- status: scripts/jobs/ironhorse-ratchet.sh status
- pause: scripts/jobs/ironhorse-ratchet.sh pause
- resume only after maintainer resolves a halt: scripts/jobs/ironhorse-ratchet.sh resume
- permanent revoke: scripts/jobs/ironhorse-ratchet.sh revoke /path/to/maintainer-reason.txt

Report actual deployed/runtime evidence and any remaining PR-side blocker to the maintainer. Never claim the ratchet is running at mentat based only on its schedule definition.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-28T20:58:48Z
