---
gate: blocked
blocked_on: ironhorse-test262-press-20260929-173306
priority: normal
posted_by: builder
posted_at: 2026-09-29T18:39:34Z
---

---
role: builder
tier: mentor
fallback-tier: minion
handler-timeout: 7200
dispatch: automatic
---
# Verify the first live Ironhorse foreman-press engagement (successor of activate-ironhorse-ratchet-autopilot-20260929-r4)

Owns the last remaining activation step of the chain build-ironhorse-ratchet-autopilot → activate-ironhorse-ratchet-autopilot-20260928/-20260929/-r3/-r4/-r5. Authorization: journal2 entries/2026/09/28/201230Z-message-gardener-aa49da.md plus kriskowal's directive https://github.com/kriscendobot/garden/issues/51#issuecomment-5884119530. Do not widen either. Read context/operations/ironhorse-ratchet.md first.

Already verified (r5 at 17:53Z, re-checked by r4 at 18:40Z): leader endolin-garden-ece02cb4 and follower endolin-garden2-5bcdff64 run main2 descendants of c3aae0b2c0c and 9bf25f4362f with every press gate; legacy schedule `ironhorse-ratchet` retired (journal d9292d72173); press plan ironhorse-test262-press-20260929-173306 parked (gate deferred, foreman_only, issue spine #51); config/arc-budgets/ironhorse-test262-ratchet absent because the maintainer has named no cap, so the foreman fails closed (arc-budget-untrusted). oros-studio-garden-ce242c49 is live on e036bb8e (pre-ratchet), but its claim-job.sh refuses non-manual mentat, so it cannot claim the press.

This plan unblocks when the press job lands in tada/. Then:
1. From the press job's claim block, usage/<press>.jsonl and tada report, confirm a canonical `tier: mentat` / `dispatch: ratchet-delegated` claim by a host running current code, the actual mentat model in usage (never infer from the job definition), and that the driver recorded exactly one step, or a correctly evidenced criterion failure or halt, with no overlapping children.
2. Confirm https://github.com/endojs/endo-but-for-bots/pull/1359 did not merge and has no attestation unless the evidence criteria were genuinely met. Never lower the enforced floor. Coordinate PR-side mutations with ironhorse-test262-ratchet-round3-floor-resolution-20260928.
3. Confirm the engagement parked exactly one continuation press plan and did not spend beyond the installed arc budget.
4. Report the runtime evidence on https://github.com/kriscendobot/garden/issues/51 (do not close it; do not resolve the 901-path historical-floor question).
Never recreate or unsnooze the legacy schedule, never invent an arc-budget cap, never originate a sysop deploy op.
