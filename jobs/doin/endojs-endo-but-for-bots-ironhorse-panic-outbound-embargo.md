---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-29T15:40:06Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Outbound embargo, commit-gated release, duplicate suppression

Repo: endojs/endo-but-for-bots (base branch `llm`).
Design: `designs/ironhorse-panic.md` (merged via https://github.com/endojs/endo-but-for-bots/pull/1018). Already built: https://github.com/endojs/endo-but-for-bots/pull/1150 (Halt::Panic(PanicKind::EngineFault), Halt::is_panic(), ExecutionOutcome classifier, live FFI-abort guard).
Directive: kriskowal, https://github.com/endojs/endo-but-for-bots/pull/1018#issuecomment-5884163049 — build every deferred branch of this design, and probe it end to end.
Orchestration: `endojs-endo-but-for-bots-pr1018-followups-20260929` (serial). Open design questions are being answered by the manual mentat job `endojs-endo-but-for-bots-ironhorse-panic-open-questions-mentat`: before you start, check `journal/jobs/tada/` for its report (and the design-amendment PR it names) and follow its answers where they bear on this leg. If it has not landed yet, follow the design's recorded leanings, and list every open-question decision you depended on in the PR body as a review item.
Stacking: if an earlier leg of this orchestration left an unmerged PR your work depends on, stack on its head branch (skills/stacked-pr-build) rather than duplicating it.
Open a DRAFT PR through scripts/jobs/gardening/ensure-pr.sh, with `Refs: #1018` in the body, and meet the design's § Verification cases for this leg. A successful build hands off to the gauntlet automatically.

## This leg

§ The Slot Machine Message Embargo Contract: stage outbound frames per crank; release them in sequence order only after the crank commits; discard them on every non-`Quiesced` outcome (`MeterAbort` explicitly included); receivers suppress duplicates by stable event sequence, so at-least-once release is observed exactly once. Reconcile with the draft design https://github.com/endojs/endo-but-for-bots/pull/989 (worker quiescence embargo), following the mentat job's supersede/merge answer. Acceptance: one embargo-coverage case per row of the design's termination-path table, plus the crash-after-send, before-ack idempotency property.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-29T15:49:59Z
