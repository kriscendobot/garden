---
role: builder
---

Build the daemon graduation of the EndoClaw interval scheduler in endojs/endo-but-for-bots (design `journal/plan/designs/endo-but-for-bots/endoclaw-timer.md`, § "Implementation Phases → Phase 1 remainder / daemon integration"): graduate the prototype interval scheduler from `packages/genie/src/interval/` into `@endo/daemon` as a real capability — add the interval-scheduler formula type, its `extractDeps` integration, and the maker-table entry so intervals persist as daemon formulas rather than the genie prototype's directory-only persistence, with tests. First reconcile against the existing `@endo/genie` scheduler so the work moves/extends it additively rather than duplicating. Base on `llm`, bot identity; run the standard PR-creation chain.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  claimed_at: 2026-07-09T21:31:31Z
