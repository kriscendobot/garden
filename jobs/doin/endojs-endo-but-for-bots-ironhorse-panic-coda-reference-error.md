---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-29T21:25:08Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Coda: panic-on-reference-error construction option

Repo: endojs/endo-but-for-bots (base branch `llm`).
Design: `designs/ironhorse-panic.md` (merged via https://github.com/endojs/endo-but-for-bots/pull/1018). Already built: https://github.com/endojs/endo-but-for-bots/pull/1150 (Halt::Panic(PanicKind::EngineFault), Halt::is_panic(), ExecutionOutcome classifier, live FFI-abort guard).
Directive: kriskowal, https://github.com/endojs/endo-but-for-bots/pull/1018#issuecomment-5884163049 — build every deferred branch of this design, and probe it end to end.
Orchestration: `endojs-endo-but-for-bots-pr1018-followups-20260929` (serial). Open design questions are being answered by the manual mentat job `endojs-endo-but-for-bots-ironhorse-panic-open-questions-mentat`: before you start, check `journal/jobs/tada/` for its report (and the design-amendment PR it names) and follow its answers where they bear on this leg. If it has not landed yet, follow the design's recorded leanings, and list every open-question decision you depended on in the PR body as a review item.
Stacking: if an earlier leg of this orchestration left an unmerged PR your work depends on, stack on its head branch (skills/stacked-pr-build) rather than duplicating it.
Open a DRAFT PR through scripts/jobs/gardening/ensure-pr.sh, with `Refs: #1018` in the body, and meet the design's § Verification cases for this leg. A successful build hands off to the gauntlet automatically.

## This leg

§ Coda: add an off-by-default `Machine` construction option under which the `XS_CODE_GET_LOCAL`, `XS_CODE_GET_VARIABLE` and (once routed through `raise_js`) `XS_CODE_GET_CLOSURE` reference-error sites surface `Halt::Panic(PanicKind::ReferenceError)` instead of a catchable throw. Pin the setting in the worker's `snapshot` record, and reject a replay under a different setting as a deterministic replay fault. The companion design https://github.com/endojs/endo-but-for-bots/pull/1016 (panic-on-reference-error plus unhandled-rejection handling) overlaps this leg. Build the #1018 Coda, reconcile it with #1016's current text, and leave #1016's rejection-handling scope to #1016. Acceptance: the Coda bullet (a)–(c) in § Verification, with the `<panic kind="reference-error">` case building on the debugger leg.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-29T21:37:12Z
