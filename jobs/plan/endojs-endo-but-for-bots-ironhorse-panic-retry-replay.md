---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-pr1018-followups-20260929
priority: normal
role: builder
posted_by: gardener
posted_at: 2026-09-29T08:52:47Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Terminate, restore, replay: retry after a panic

Repo: endojs/endo-but-for-bots (base branch `llm`).
Design: `designs/ironhorse-panic.md` (merged via https://github.com/endojs/endo-but-for-bots/pull/1018). Already built: https://github.com/endojs/endo-but-for-bots/pull/1150 (Halt::Panic(PanicKind::EngineFault), Halt::is_panic(), ExecutionOutcome classifier, live FFI-abort guard).
Directive: kriskowal, https://github.com/endojs/endo-but-for-bots/pull/1018#issuecomment-5884163049 — build every deferred branch of this design, and probe it end to end.
Orchestration: `endojs-endo-but-for-bots-pr1018-followups-20260929` (serial). Open design questions are being answered by the manual mentat job `endojs-endo-but-for-bots-ironhorse-panic-open-questions-mentat`: before you start, check `journal/jobs/tada/` for its report (and the design-amendment PR it names) and follow its answers where they bear on this leg. If it has not landed yet, follow the design's recorded leanings, and list every open-question decision you depended on in the PR body as a review item.
Stacking: if an earlier leg of this orchestration left an unmerged PR your work depends on, stack on its head branch (skills/stacked-pr-build) rather than duplicating it.
Open a DRAFT PR through scripts/jobs/gardening/ensure-pr.sh, with `Refs: #1018` in the body, and meet the design's § Verification cases for this leg. A successful build hands off to the gauntlet automatically.

## This leg

§ Slot Machine Termination and Retry, composed with debugWorker's snapshot suspend/resume (designs/daemon-debug-worker-restart.md): on `Panicked`, terminate the worker, restore the last committed snapshot, replay the transcript suffix up to (not including) the panicking delivery, and offer retry for the three "fixed" cases (a new-snapshot code fix, a config-change retry, an external-condition retry). Apply the mentat job's answer on uncaught-throw disposition (terminate vs reject-and-continue). Acceptance: metamorphic replay == live (byte-identical heap state and identical outbound-frame sequence), including handle re-seating.
