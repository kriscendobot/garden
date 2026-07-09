---
kind: result
role: weaver
host: endolin-garden-ece02cb4
at: 2026-07-09T22:21:54Z
---
project: endo-but-for-bots
prs: [617, 619]
repo: endojs/endo-but-for-bots

Restacked the endoclaw-timer scheduled-execution PRs onto the grown head of #609.

- #617 (Phase 2, tick delivery as mail + `TickResponse` exo): rebased from old base `c4e32e3797` onto #609's head `c84fb80ed1` (Phase 4 host integration). Head now `07298d0ff1`, MERGEABLE. Reconciled the facet-pair split: #617's Phase 2 was written against the pre-Phase-4 flat `Far('IntervalScheduler', {...})` return; Phase 4 changed the incarnation to the `{ scheduler, schedulerControl }` facet-pair record. Kept Phase 4's record (a pure CopyRecord of Remotables, so it cannot carry a `handle()` method without breaking CapTP serialization) and moved the scheduler's mail-handle resolution into a daemon-internal `schedulerHandleForId` map that the generic `handle` formula maker consults. Comment: https://github.com/endojs/endo-but-for-bots/pull/617#issuecomment-4930072707

- #619 (Phase 3, startup recovery / coalesced catch-up tick): rebased onto #617's new head. Head now `4af18a8611`, MERGEABLE (was CONFLICTING). Dropped #619's stale duplicate Phase 1 / Phase 1 fixup / Phase 2 copies (it had forked from an older `llm` base). Phase 3's daemon.js hook is in `seedFormulaGraphFromPersistence`, orthogonal to Phase 2's tick-delivery region, so it applied clean; only the daemon-restart test needed the `{ scheduler }` facet-pair destructure. Comment: https://github.com/endojs/endo-but-for-bots/pull/619#issuecomment-4930072792

Verified against a real daemon (short `/tmp` socket): `interval-scheduler-daemon.test.js` both tests pass (tick delivery + 9.5s daemon-restart recovery); `interval-scheduler.test.js` 15 unit tests pass; a targeted check confirmed a tick's `@from` resolves to the scheduler handle through the new map. `node --check` clean.
