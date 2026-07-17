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

<!-- garden-reaped: 0 -->

<!-- garden-productive-cycle -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 8
  worker_kind: cleric
  claimed_at: 2026-07-17T06:33:11Z
