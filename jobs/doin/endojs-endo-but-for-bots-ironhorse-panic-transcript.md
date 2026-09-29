---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-29T14:34:09Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Slot Machine per-worker write-ahead transcript

Repo: endojs/endo-but-for-bots (base branch `llm`).
Design: `designs/ironhorse-panic.md` (merged via https://github.com/endojs/endo-but-for-bots/pull/1018). Already built: https://github.com/endojs/endo-but-for-bots/pull/1150 (Halt::Panic(PanicKind::EngineFault), Halt::is_panic(), ExecutionOutcome classifier, live FFI-abort guard).
Directive: kriskowal, https://github.com/endojs/endo-but-for-bots/pull/1018#issuecomment-5884163049 — build every deferred branch of this design, and probe it end to end.
Orchestration: `endojs-endo-but-for-bots-pr1018-followups-20260929` (serial). Open design questions are being answered by the manual mentat job `endojs-endo-but-for-bots-ironhorse-panic-open-questions-mentat`: before you start, check `journal/jobs/tada/` for its report (and the design-amendment PR it names) and follow its answers where they bear on this leg. If it has not landed yet, follow the design's recorded leanings, and list every open-question decision you depended on in the PR body as a review item.
Stacking: if an earlier leg of this orchestration left an unmerged PR your work depends on, stack on its head branch (skills/stacked-pr-build) rather than duplicating it.
Open a DRAFT PR through scripts/jobs/gardening/ensure-pr.sh, with `Refs: #1018` in the body, and meet the design's § Verification cases for this leg. A successful build hands off to the gauntlet automatically.

## This leg

§ Slot Machine per-worker write-ahead transcript: one SQLite WAL database per worker, holding snapshot watermarks, crank state, inbound and outbound rows, and stable event identifiers. Use the commit discipline (store-backed ATTACH/2PC or XS/CAS watermark ordering) the mentat job chose for the first production backend. Apply the SQLite I/O-failure disposition and the per-crank fsync bound it chose. Acceptance: the crash-injection matrix over every ordering point of a committing crank, run with a deterministic fault-injection seam (fail the Nth fsync/write), asserting replay reaches exactly the pre-crank or the post-crank state and never a torn one. Performance tuning is out of scope; correctness gates landing.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-29T14:34:28Z
