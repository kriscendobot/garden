---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 452
created_at: 2026-06-17T23:20:39Z
last_appended_at: 2026-06-17T23:20:39Z
status: parked
---

# Follow-ups for endo-but-for-bots#452

## Items

- [ ] `iroh-heartbeat.js: pump()`: verify that `readDatagram` rejects when the QUIC connection closes in the `@number0/iroh` binding (the pump loop holds a live reference if the promise never resolves, and stop() does not cancel it). Add a comment in `pump()` noting the assumption, and revisit when the iroh binding version changes.
  **Source juror(s)**: corner-prober
  **Round**: 1
  **Recommended action**: consult `@number0/iroh` changelog and binding source to verify `readDatagram` rejects on connection close; add a comment to the pump loop documenting the assumption; if the assumption is wrong, add an AbortSignal or cancelled-promise parameter to the readDatagram loop

- [ ] `packages/daemon/test/iroh-heartbeat.test.js`: the tests use real wall-clock timers. Consider adding injectable timer factories (`setInterval`, `setTimeout`) to `makeIrohHeartbeat`'s options object (defaulting to the globals) so the test suite can use a fake clock and be deterministic on all hosts.
  **Source juror(s)**: fast-checker
  **Round**: 1
  **Recommended action**: open a follow-up PR that adds `setInterval` and `setTimeout` as injectable options to `makeIrohHeartbeat` and ports the heartbeat tests to `@sinonjs/fake-timers`
