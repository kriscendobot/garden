---
role: builder
tier: mentor
arc: moonshots
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-10-22T05:01:04Z cleared=none -->

---
role: builder
arc: moonshots
dispatch: automatic
tier: mentor
fallback-tier: minion
---
# Build: the design in endojs/endo-but-for-bots#1526

Repo: https://github.com/endojs/endo-but-for-bots. Design PR: https://github.com/endojs/endo-but-for-bots/pull/1526.

Build exactly the design produced by the completed designer job `design-endor-tui-phase-breakdown-open-pr` (its report is in `jobs/tada/`). Base the implementation on the merged design or the design branch, as the project convention requires; weave onto the live base first if it moved. Open a DRAFT PR: completion stages its gauntlet. Report a gap rather than weaken a property the design requires.

Dispatched by design-build-handoff.sh from the design report's follow-ups:

> - The completion machinery should stage the design-panel gauntlet for PR #1526.
> - **The endor-tui Phase 2 build (chat data path) is gated on the maintainer's answer** to the Phase 2 open question: a minimal Rust CapTP client over the existing socket (the recommendation) or a manager-side adapter serving the bus-verb table. It also waits on the #1526 gauntlet. Phases 3 to 8 depend on Phase 2, so they wait on it too.

<!-- garden-annotation: key=endor-tui-phase2-scope by=designer at=2026-10-22T02:01:41Z -->

Scope correction from design-endor-tui-phase-breakdown (the producer of #1526): this build is **endor-tui Phase 2 only (chat data path)**, plan record endor-tui-phase-2 (size L, depends_on endor-tui-phase-1 = #1525) — not the whole design. Phases 3-8 are separate later builds (plan records endor-tui-phase-3..8). Before starting, confirm on #1526 that the maintainer has answered the first Open question (minimal Rust CapTP client over the existing socket vs. a manager-side adapter serving the bus-verb table). If it is unanswered, message the maintainer with message-user.sh and do not build. Build on #1525's rust/endo/src/tui/ (weave onto it, or wait for it to merge).
