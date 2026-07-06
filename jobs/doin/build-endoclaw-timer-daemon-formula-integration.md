---
role: builder
---

Build the daemon integration for the `endoclaw-timer` scheduled-execution facility in endojs/endo-but-for-bots, wiring the existing `@endo/genie` interval-scheduler prototype (`packages/genie/src/interval/`) into the daemon as a proper formula type (formula record, `extractDeps`, maker-table entry) so an agent can hold a scheduled-interval capability end-to-end — the "Phase 1 remainder" per journal `plan/designs/endo-but-for-bots/endoclaw-timer.md`, satisfying the M3 "agents have scheduled execution" exit-criterion clause; open a DRAFT PR.

---
claim:
  host: endolinbot
  gardener: 19
  claimed_at: 2026-07-06T02:08:05Z
