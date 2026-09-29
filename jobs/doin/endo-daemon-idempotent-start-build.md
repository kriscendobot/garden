---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Endo daemon: idempotent start + early single-instance lock (phase 1)

Repo: endojs/endo-but-for-bots, base `llm` (DRAFT PR). Design: https://github.com/endojs/endo-but-for-bots/pull/1383 (designs/daemon-lifecycle-idempotency.md). Motivation: kriscendobot/minion.town#130 and #137 deploy workarounds.

Implement §§ 1–2 of the design:
1. `start()` (packages/daemon/index.js) must not `clean()` a live daemon. Probe the socket first. If it is live, report "already running" and succeed without changes. If the lock marker names a live pid that is not serving yet, wait for the bounded window socket-lock.js uses. `clean()` removes the socket, marker, and endo.pid only when their owner is dead. Add `--force` for the old behavior. Apply this to the engo path too.
2. In packages/daemon/src/manager-node.js `main()`, claim a single-instance lock keyed on the ephemeral state dir (reuse the socket-lock.js primitives) BEFORE `initializePersistence()`, `killStaleWorkers()`, and `updateRecordedPid()`. The loser exits with a distinct code (69, EX_UNAVAILABLE) and a clear message, and does not touch workers or the DB. Write endo.pid right after the claim. Drop the kill-previous-pid behavior of `updateRecordedPid`.
Tests: `start` twice leaves one daemon; `start` while booting; a second run-daemon against the same state exits 69 and the first daemon's workers survive.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-29T23:08:13Z
