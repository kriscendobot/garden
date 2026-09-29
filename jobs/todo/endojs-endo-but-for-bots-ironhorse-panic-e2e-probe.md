---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-29T08:58:03Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Probe the Ironhorse panic feature end to end (gap-revealing build)

Repo: endojs/endo-but-for-bots (base branch `llm`).
Design: `designs/ironhorse-panic.md` (merged via https://github.com/endojs/endo-but-for-bots/pull/1018). Already built: https://github.com/endojs/endo-but-for-bots/pull/1150 (Halt::Panic(PanicKind::EngineFault), Halt::is_panic(), ExecutionOutcome classifier, live FFI-abort guard).
Directive: kriskowal, https://github.com/endojs/endo-but-for-bots/pull/1018#issuecomment-5884163049 — build every deferred branch of this design, and probe it end to end.
Orchestration: `endojs-endo-but-for-bots-pr1018-followups-20260929` (serial). Open design questions are being answered by the manual mentat job `endojs-endo-but-for-bots-ironhorse-panic-open-questions-mentat`: before you start, check `journal/jobs/tada/` for its report (and the design-amendment PR it names) and follow its answers where they bear on this leg. If it has not landed yet, follow the design's recorded leanings, and list every open-question decision you depended on in the PR body as a review item.
Stacking: if an earlier leg of this orchestration left an unmerged PR your work depends on, stack on its head branch (skills/stacked-pr-build) rather than duplicating it.
Open a DRAFT PR through scripts/jobs/gardening/ensure-pr.sh, with `Refs: #1018` in the body, and meet the design's § Verification cases for this leg. A successful build hands off to the gauntlet automatically.

## This leg

Work under skills/gap-revealing-build: a DRAFT PR that STAYS draft (no fix, panel, or un-draft chain) and delivers a structured gap report. Drive one worker, end to end, through: a panic mid-delivery (an FFI callback panic, a StackOverflow, a MeterAbort) → supervisor-visible Panicked → outbound embargo discard → terminate → snapshot restore → transcript replay up to, but not including, the panicking delivery → debugger stop at the panic site. Where a stage does not exist yet, write the test as a pending/skipped case naming the missing mechanism. The gap report maps each gap to the later leg of `endojs-endo-but-for-bots-pr1018-followups-20260929` that owns it, or names an unowned gap. Post the report as a PR comment and put it in your completion report, so the later legs and the mentat job can read it.
