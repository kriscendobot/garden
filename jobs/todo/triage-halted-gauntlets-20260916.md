---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Triage five halted gauntlets/orchestrations parked since early September and
report a per-item disposition to the maintainer inbox. Do NOT re-post any of
them blindly: the credit investigation (reports/credit-investigation-endolin-
garden2-20260905.md) named stale PRs churning at iteration 6/6 as a top cost
multiplier, so a stale premise must be found BEFORE the budget is spent.

The five (parked bases live in journal/jobs/plan/):
1. sweep-ci-starved-conflicting-prs-20260901-gauntlet-clean — clean stage
   doom-parked, doom_signature=requeue-exhausted, failure_classification=unknown.
2. build-minion-town-invitation-only-guest-onboarding-gauntlet-panel-2 — panel
   stage doom-parked, same unknown classification.
3. ebfb-exo-stream-drop-base64-stream-methods-gauntlet — fix-2 stage declared
   the gated outcome failed/declined; not retried.
4. build-minion-town-claude-harness-provisioning-gauntlet — panel/fix loop did
   not converge in 6 rounds (max_iterations=6).
5. minion-town-clipometer-esbuild-orchestration — HALTED, 0/4 children done;
   child ...-pipeline stalled in flight 2501s against handler-timeout=2400s.
   Remaining parked children: minion-town-clipometer-esbuild-validate,
   minion-town-clipometer-primer-esbuild-update,
   minion-town-clipometer-esbuild-issue-report.

For EACH, determine and report:
- Is the underlying PR/premise still live? (open, not merged, not superseded —
  check state, mergedAt, and whether a later change already did the work). If a
  premise is overtaken, say so plainly and recommend "close as superseded",
  naming the deciding question.
- Was the halt a TRANSIENT infrastructure failure or a real failure of the work?
  The halts that read failure_classification=unknown deliberately were not
  retried because the record did not prove transience — look at the actual stage
  records and say which it was.
- Item 5 is a plain handler-budget overrun (2501s vs a 2400s budget), so the
  remedy is likely a `handler-timeout:` header or a split into claim-sized
  stages, not a retry. Confirm and recommend the specific value or split.
- Recommend exactly one of: RE-POST (with any header/scope change spelled out),
  RE-SCOPE (say how), or DROP (say why), with the evidence you checked.

Do NOT promote or re-post anything yourself. Report all five dispositions in ONE
message to the maintainer inbox so the decision is a single read.
