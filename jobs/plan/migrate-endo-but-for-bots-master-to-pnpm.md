---
gate: go-ahead
priority: normal
parked_at: 2026-08-02T21:03:45Z
parked_by: liaison:endolin-garden-ece02cb4
parked_reason: maintainer directive — board cleared so the fleet runs
  ONLY the budget/cost-attribution orchestration. Restore with
  promote-plan.sh when that work concludes.
---

---
role: builder
model: gpt-5.6-terra
handler-timeout: 10800
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-01T09:01:40Z cleared=none -->

---
role: builder
model: gpt-5.6-terra
priority: high
handler-timeout: 10800
---
Migrate endojs/endo-but-for-bots completely from Yarn to pnpm, starting from the live upstream endojs/endo master lineage.

Create a fresh bot-authored branch based on the latest upstream master commit (first fetch endojs/endo master and ensure the target base is not a stale fork snapshot), then make endojs/endo-but-for-bots a pnpm-native repository. Replace package-manager configuration, lockfiles, workspace commands, scripts, bootstrap/development instructions, CI workflows, release tooling, Docker/build automation, and every other tracked Yarn dependency with pnpm equivalents. Preserve monorepo/workspace semantics and reproducibility. Remove obsolete Yarn artifacts rather than carrying compatibility shims.

Acceptance is literal and exhaustive: a case-insensitive search of all tracked files must find no mention of yarn; pnpm install must reproduce from the committed pnpm lockfile; every applicable lint, format, typecheck, unit, integration, build, and CI-equivalent test must pass. Exercise workflows locally where practical and fix pnpm-specific lifecycle/workspace differences rather than skipping tests. Do not weaken checks or exclude failures. Record exact commands and results.

Open one bot-authored PR on endojs/endo-but-for-bots against master, clearly labeled as the pnpm migration experiment and citing the exact upstream master SHA used. Run the normal build-produced gauntlet through clean panel review and un-draft only when all acceptance criteria are met. Do not merge.
